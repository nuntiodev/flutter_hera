import 'dart:convert';

import 'package:dart_blocks/softcorp_authorize/softcorp_authorize.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_softcorp_blocks/block_user.pbgrpc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserClient {
  // _grpcUserClient is an object to communicate with the mobile_blocks
  late final UserServiceClient _grpcUserClient;
  late final String? _encryptionKey;
  late final String? _jwtPublicKey;
  late final Authorize _authorize;
  User currentUser = User();
  String accessToken = "";
  String _refreshToken = "";

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
    String accessToken = await _authorize.getAccessToken();
    UserRequest req = UserRequest();
    User user = User();
    user.id = userId ?? "";
    user.optionalId = optionalId ?? "";
    user.email = email ?? "";
    user.password = password;
    req.cloudToken = accessToken;
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
      currentUser = resp.user;
      accessToken = resp.token.accessToken;
      _refreshToken = resp.token.refreshToken;
    } catch (e) {
      print("could not create user");
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    if (currentUser.id != "") {
      try {
        if (JwtDecoder.getRemainingTime(accessToken).inMinutes < 2) {
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
        req.token = Token()..refreshToken = _refreshToken;
        UserResponse refreshResp = await _grpcUserClient.refreshToken(req);
        _refreshToken = refreshResp.token.refreshToken;
        accessToken = refreshResp.token.accessToken;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
