import 'dart:convert';

import 'package:dart_blocks/softcorp_authorize/softcorp_authorize.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_softcorp_blocks/block_user.pbgrpc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserClient {
  UserClient({
    required UserServiceClient grpcUserClient,
    required Authorize authorize,
    required String? jwtPublicKey,
    String? encryptionKey,
  }) {
    _grpcUserClient = grpcUserClient;
    _authorize = authorize;
    _encryptionKey = encryptionKey;
    _jwtPublicKey = jwtPublicKey;
  }

  // Create storage which is used to store tokens
  final storage = FlutterSecureStorage();

  // _grpcUserClient is an object to communicate with the mobile_blocks
  late final UserServiceClient _grpcUserClient;

  // _encryptionKey is used to encrypt users
  late final String? _encryptionKey;

  // _jwtPublicKey is used to validate auth sessions
  late final String? _jwtPublicKey;

  // _authorize is used to retrieve access token
  late final Authorize _authorize;

  // currentUser is created after user logs in
  User _currentUser = User();
  final String _currentUserKey = "softcorp-blocks-current-user";

  // accessToken is used to authenticate user
  String _accessToken = "";
  final String _accessTokenKey = "softcorp-blocks-access-token";

  // _refreshToken is used to get a new accessToken
  String _refreshToken = "";
  final String _refreshTokenKey = "softcorp-blocks-refresh-token";

  Future<User> getCurrentUser() async {
    if (_currentUser.id != "") {
      return _currentUser;
    }
    var jsonCurrentUser = await storage.read(key: _currentUserKey);
    if (jsonCurrentUser != "") {
      _currentUser = jsonDecode(jsonCurrentUser!);
      return _currentUser!;
    }
    return User();
  }

  void _setCurrentUser(User currentUser) async {
    _currentUser = currentUser;
    storage.write(key: _currentUserKey, value: jsonEncode(currentUser));
  }

  Future<String> getAccessToken() async {
    if (_accessToken != "") {
      return _accessToken;
    }
    var accessToken = await storage.read(key: _accessTokenKey);
    if (accessToken != "") {
      _accessToken = accessToken!;
      return accessToken!;
    }
    return "";
  }

  void _setAccessToken(String accessToken) async {
    _accessToken = accessToken;
    storage.write(key: _accessTokenKey, value: accessToken);
  }

  Future<String> _getRefreshToken() async {
    if (_refreshToken != "") {
      return _refreshToken;
    }
    var refreshToken = await storage.read(key: _refreshTokenKey);
    if (refreshToken != "") {
      _refreshToken = refreshToken!;
      return refreshToken!;
    }
    return "";
  }

  void _setRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<User> create({
    String? userId,
    String? optionalId,
    String? email,
    String? image,
    String? password,
    bool? validatePassword,
    dynamic metadata,
  }) async {
    String accessToken = await _authorize.getAccessToken();
    UserRequest req = UserRequest();
    User user = User();
    user.id = userId ?? "";
    user.optionalId = optionalId ?? "";
    user.email = email ?? "";
    user.image = image ?? "";
    user.password = password ?? "";
    req.validatePassword = validatePassword ?? false;
    req.cloudToken = accessToken;
    req.encryptionKey = _encryptionKey ?? "";
    req.user = user;
    if (metadata != null) {
      String encodeMetadata = jsonEncode(metadata);
      user.metadata = encodeMetadata;
    }
    try {
      UserResponse resp = await _grpcUserClient.create(req);
      return resp.user;
    } catch (e) {
      print("could not create user");
      rethrow;
    }
  }

  Future<void> login({
    String? userId,
    String? optionalId,
    String? email,
    required String password,
  }) async {
    if (userId == null && optionalId == null && email == null) {
      throw Exception(
          "missing one required identifier: userId, optionalId or email");
    }
    String cloudToken = await _authorize.getAccessToken();
    UserRequest req = UserRequest();
    User user = User();
    user.id = userId ?? "";
    user.optionalId = optionalId ?? "";
    user.email = email ?? "";
    user.password = password;
    req.cloudToken = cloudToken;
    req.encryptionKey = _encryptionKey ?? "";
    req.user = user;
    try {
      UserResponse resp = await _grpcUserClient.login(req);
      if (resp.token.accessToken == "" || resp.token.refreshToken == "") {
        throw Exception("token is null. Contact info@softcorp.io");
      }
      if (resp.user.id == "") {
        throw Exception("user is null. Contact info@softcorp.io");
      }
      _setCurrentUser(resp.user);
      _setAccessToken(resp.token.accessToken);
      _setRefreshToken(resp.token.refreshToken);
    } catch (e) {
      print("could not create user");
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    if ((await getCurrentUser()).id != "") {
      try {
        var accessToken = await getAccessToken();
        if (accessToken != "" &&
            JwtDecoder.getRemainingTime(accessToken).inMinutes < 2) {
          try {
            if (_jwtPublicKey != "") {
              throw Exception("empty jwt public  key");
            }
            JWT.verify(accessToken, SecretKey(_jwtPublicKey!));
            return true;
          } catch (e) {
            print("could not verify token with err" + e.toString());
          }
        }
        // token is expired - refresh
        UserRequest req = UserRequest();
        req.token = Token()..refreshToken = await _getRefreshToken();
        UserResponse refreshResp = await _grpcUserClient.refreshToken(req);
        _setAccessToken(refreshResp.token.accessToken);
        _setRefreshToken(refreshResp.token.refreshToken);
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
