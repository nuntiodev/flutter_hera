import 'dart:async';
import 'dart:convert';
import 'dart:io' as WhichPlatform;
import 'package:dart_blocks/nuntio_authorize/nuntio_authorize.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:nuntio_blocks/block_user.pbgrpc.dart' as dart_blocks;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBlock {
  UserBlock({
    required dart_blocks.UserServiceClient grpcUserClient,
    required Authorize authorize,
    required String? jwtPublicKey,
    required this.sharedPreferences,
    this.debug,
    String? encryptionKey,
    Function? onLogin,
    Function? onLogout,
    bool? recordActive,
  }) {
    _grpcUserClient = grpcUserClient;
    _authorize = authorize;
    _encryptionKey = encryptionKey;
    _jwtPublicKey = jwtPublicKey;
    _secureStorage = FlutterSecureStorage();
  }

  // Debug will print error logs if true
  late final bool? debug;

  // Create storage which is used to store tokens
  late final FlutterSecureStorage _secureStorage;
  late final SharedPreferences sharedPreferences;

  // _grpcUserClient is an object to communicate with the dart_blocks
  late final dart_blocks.UserServiceClient _grpcUserClient;

  // _encryptionKey is used to encrypt users
  late final String? _encryptionKey;

  // _jwtPublicKey is used to validate auth sessions
  late final String? _jwtPublicKey;

  // _authorize is used to retrieve access token
  late final Authorize _authorize;

  // currentUser is created after user logs in
  dart_blocks.User _currentUser = dart_blocks.User();
  final String _currentUserKey = "nuntio-blocks-current-user";

  // accessToken is used to authenticate user
  String _accessToken = "";
  final String _accessTokenKey = "nuntio-blocks-access-token";

  // _refreshToken is used to get a new accessToken
  String _refreshToken = "";
  final String _refreshTokenKey = "nuntio-blocks-refresh-token";

  // _placemark is used to send data to the backend about user location
  Placemark? _placemark;

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<dart_blocks.User> getCurrentUser() async {
    if (_currentUser.id != "") {
      return _currentUser;
    }
    var jsonCurrentUser = await _secureStorage.read(key: _currentUserKey);
    if (jsonCurrentUser != null && jsonCurrentUser != "") {
      _currentUser = dart_blocks.User.fromJson(jsonCurrentUser);
      return _currentUser;
    }
    return dart_blocks.User();
  }

  void _setCurrentUser(dart_blocks.User currentUser) async {
    _currentUser = currentUser;
    _secureStorage.write(
        key: _currentUserKey, value: currentUser.writeToJson());
  }

  Future<String> getAccessToken() async {
    if (_accessToken != "") {
      return _accessToken;
    }
    var accessToken = await _secureStorage.read(key: _accessTokenKey);
    if (accessToken != "") {
      _accessToken = accessToken!;
      return accessToken;
    }
    return "";
  }

  void _setAccessToken(String accessToken) async {
    _accessToken = accessToken;
    _secureStorage.write(key: _accessTokenKey, value: accessToken);
  }

  Future<String> _getRefreshToken() async {
    if (_refreshToken != "") {
      return _refreshToken;
    }
    var refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    if (refreshToken != "") {
      _refreshToken = refreshToken!;
      return refreshToken;
    }
    return "";
  }

  void _setRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<dart_blocks.User> create({
    String? userId,
    String? username,
    String? email,
    String? image,
    String? password,
    dynamic metadata,
  }) async {
    dart_blocks.UserRequest req = dart_blocks.UserRequest();
    dart_blocks.User user = dart_blocks.User();
    user.id = userId ?? "";
    user.username = username ?? "";
    user.email = email ?? "";
    user.image = image ?? "";
    user.password = password ?? "";
    req.cloudToken = await _authorize.getAccessToken();
    req.encryptionKey = _encryptionKey ?? "";
    req.user = user;
    if (metadata != null) {
      String encodeMetadata = jsonEncode(metadata);
      user.metadata = encodeMetadata;
    }
    try {
      dart_blocks.UserResponse resp = await _grpcUserClient.create(req);
      return resp.user;
    } catch (e) {
      if (debug == true)
        print("could not create user with err: " + e.toString());
      rethrow;
    }
  }

  Future<dart_blocks.User> updateEmail({
    String? userId,
    String? username,
    String? currentEmail,
    required String newEmail,
  }) async {
    dart_blocks.UserRequest req = dart_blocks.UserRequest();
    dart_blocks.User get = dart_blocks.User();
    get.id = userId ?? "";
    get.username = username ?? "";
    get.email = currentEmail ?? "";
    dart_blocks.User update = dart_blocks.User();
    update.email = newEmail;
    req.cloudToken = await _authorize.getAccessToken();
    req.encryptionKey = _encryptionKey ?? "";
    req.user = get;
    req.update = update;
    try {
      dart_blocks.UserResponse resp = await _grpcUserClient.updateEmail(req);
      _setCurrentUser(_currentUser..email = newEmail);
      return resp.user;
    } catch (e) {
      if (debug == true)
        print("could not create user with err: " + e.toString());
      rethrow;
    }
  }

  Future<dart_blocks.User> updatePassword({
    String? userId,
    String? username,
    String? currentEmail,
    required String newPassword,
  }) async {
    dart_blocks.UserRequest req = dart_blocks.UserRequest();
    dart_blocks.User get = dart_blocks.User();
    get.id = userId ?? "";
    get.username = username ?? "";
    get.email = currentEmail ?? "";
    dart_blocks.User update = dart_blocks.User();
    update.password = newPassword;
    req.cloudToken = await _authorize.getAccessToken();
    req.encryptionKey = _encryptionKey ?? "";
    req.user = get;
    req.update = update;
    try {
      dart_blocks.UserResponse resp = await _grpcUserClient.updatePassword(req);
      return resp.user;
    } catch (e) {
      if (debug == true)
        print("could not create user with err: " + e.toString());
      rethrow;
    }
  }

  Future<dart_blocks.LoginSession> login({
    String? userId,
    String? username,
    String? email,
    required String password,
  }) async {
    if ((userId == null || userId == "") &&
        (username == null || username == "") &&
        (email == null || email == "")) {
      throw Exception(
          "missing one required identifier: userId, username or email");
    }
    String cloudToken = await _authorize.getAccessToken();
    dart_blocks.UserRequest req = dart_blocks.UserRequest();
    dart_blocks.User user = dart_blocks.User();
    user.id = userId ?? "";
    user.username = username ?? "";
    user.email = email ?? "";
    user.password = password;
    req.cloudToken = cloudToken;
    req.encryptionKey = _encryptionKey ?? "";
    req.user = user;
    // set metadata for token
    dart_blocks.Token _token = dart_blocks.Token();
    _token.deviceInfo = await _getDeviceInfo();
    var _placemark = await _determinePlacemark();
    if (_placemark != null) {
      dart_blocks.Location _location = dart_blocks.Location();
      _location.country = _placemark.country ?? "";
      _location.countryCode = _placemark.isoCountryCode ?? "";
      _location.city = _placemark.locality ?? "";
      _token.loggedInFrom = _location;
    }
    req.token = _token;
    try {
      dart_blocks.UserResponse resp = await _grpcUserClient.login(req);
      if (resp.loginSession.loginStatus !=
          dart_blocks.LoginStatus.AUTHENTICATED) {
        return resp.loginSession;
      }
      if (resp.token.accessToken == "" || resp.token.refreshToken == "") {
        throw Exception("token is null. Contact info@nuntio.io");
      }
      if (resp.user.id == "") {
        throw Exception("user is null. Contact info@nuntio.io");
      }
      _setCurrentUser(resp.user);
      _setAccessToken(resp.token.accessToken);
      _setRefreshToken(resp.token.refreshToken);
    } catch (e) {
      if (debug == true) print("could not login user: " + e.toString());
      rethrow;
    }
    return dart_blocks.LoginSession()
      ..loginStatus = dart_blocks.LoginStatus.AUTHENTICATED;
  }

  Future<void> logout() async {
    if (await isAuthenticated() == false) {
      throw Exception("user is currently not logged in");
    }
    try {
      // block current access token
      dart_blocks.UserRequest req = dart_blocks.UserRequest();
      req.cloudToken = await _authorize.getAccessToken();
      req.tokenPointer = await getAccessToken();
      _grpcUserClient.blockToken(req);
      // block current refresh token
      req.tokenPointer = await _getRefreshToken();
      _grpcUserClient.blockToken(req);
      // remove from secure storage
      _secureStorage.delete(key: _accessTokenKey);
      _secureStorage.delete(key: _refreshTokenKey);
      _secureStorage.delete(key: _currentUserKey);
      _currentUser = dart_blocks.User();
      _accessToken = "";
      _refreshToken = "";
    } catch (e) {
      if (debug == true) print("could not logout user: " + e.toString());
      rethrow;
    }
  }

  Future<void> verifyEmailCode({
    String? userId,
    String? username,
    String? email,
    required String code,
  }) async {
    if (userId == null && username == null && email == null) {
      throw Exception(
          "missing one required identifier: userId, optionalId or email");
    } else if (code == "") {
      throw Exception("email verification code is empty");
    }
    String cloudToken = await _authorize.getAccessToken();
    dart_blocks.UserRequest req = dart_blocks.UserRequest();
    dart_blocks.User user = dart_blocks.User();
    user.id = userId ?? "";
    user.username = username ?? "";
    user.email = email ?? "";
    req.cloudToken = cloudToken;
    req.encryptionKey = _encryptionKey ?? "";
    req.user = user;
    req.emailVerificationCode = code;
    try {
      await _grpcUserClient.verifyEmail(req);
    } catch (e) {
      if (debug == true) print("could verify email with err: " + e.toString());
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    dart_blocks.User currentUser = await getCurrentUser();
    if (currentUser.id != "") {
      try {
        var accessToken = await getAccessToken();
        if (accessToken != "" &&
            JwtDecoder.getRemainingTime(accessToken).inMinutes > 2) {
          try {
            if (_jwtPublicKey == "") {
              throw Exception("empty jwt public key");
            }
            JWT.verify(accessToken, RSAPublicKey(_jwtPublicKey ?? ""));
            return true;
          } catch (e) {
            if (debug == true)
              print("could not verify token with err" + e.toString());
          }
        }
        // token is expired - refresh
        dart_blocks.UserRequest req = dart_blocks.UserRequest();
        req.cloudToken = await _authorize.getAccessToken();
        // set metadata for token
        dart_blocks.Token _token = dart_blocks.Token();
        _token.deviceInfo = await _getDeviceInfo();
        Placemark? _placemark = this._placemark ?? await _determinePlacemark();
        if (_placemark != null) {
          dart_blocks.Location _location = dart_blocks.Location();
          _location.country = _placemark.country ?? "";
          _location.countryCode = _placemark.isoCountryCode ?? "";
          _location.city = _placemark.locality ?? "";
          _token.loggedInFrom = _location;
        }
        _token.refreshToken = await _getRefreshToken();
        req.token = _token;
        dart_blocks.UserResponse refreshResp =
            await _grpcUserClient.refreshToken(req);
        _setAccessToken(refreshResp.token.accessToken);
        _setRefreshToken(refreshResp.token.refreshToken);
        return true;
      } catch (e) {
        if (debug == true)
          print("could not refresh token with err: " + e.toString());
        return false;
      }
    }
    return false;
  }

  Future<void> recordActiveMeasurement(
      int seconds, String activeId, String userId) async {
    if (seconds > 0 && activeId != "" && userId != "") {
      dart_blocks.UserRequest req = dart_blocks.UserRequest();
      dart_blocks.ActiveMeasurement _activeMeasurement =
          dart_blocks.ActiveMeasurement();
      _activeMeasurement.seconds = seconds;
      _activeMeasurement.id = activeId;
      _activeMeasurement.userId = userId;
      dart_blocks.Location _location = dart_blocks.Location();
      if (_placemark != null || await _determinePlacemark() != null) {
        _location.countryCode = _placemark!.isoCountryCode ?? "";
        _location.country = _placemark!.country ?? "";
        _location.city = _placemark!.locality ?? "";
        _activeMeasurement.from = _location;
      }
      req.activeMeasurement = _activeMeasurement;
      req.cloudToken = await _authorize.getAccessToken();
      if (debug == true) {
        print("sending previous user session with activeness: " +
            (seconds.toString()).toString() +
            "s");
      }
      req.encryptionKey = _encryptionKey ?? "";
      await _grpcUserClient.recordActiveMeasurement(req);
      if(debug == true){
        print("done sending data...");
      }
      return;
    }
  }

  Future<dart_blocks.Config> initializeApplication() async {
    dart_blocks.UserRequest req = dart_blocks.UserRequest();
    req.cloudToken = await _authorize.getAccessToken();
    req.encryptionKey = _encryptionKey ?? "";
    return (await _grpcUserClient.initializeApplication(req)).config;
  }

  /// Determine the name of the device.
  Future<String> _getDeviceInfo() async {
    try {
      if (kIsWeb) {
        return "Web";
      } else {
        if (WhichPlatform.Platform.isAndroid) {
          return (await _deviceInfoPlugin.androidInfo).host ?? "";
        } else if (WhichPlatform.Platform.isIOS) {
          return (await _deviceInfoPlugin.iosInfo).name ?? "";
        } else if (WhichPlatform.Platform.isLinux) {
          return (await _deviceInfoPlugin.linuxInfo).name;
        } else if (WhichPlatform.Platform.isMacOS) {
          return (await _deviceInfoPlugin.macOsInfo).computerName;
        } else if (WhichPlatform.Platform.isWindows) {
          return (await _deviceInfoPlugin.windowsInfo).computerName;
        }
      }
    } catch (e) {
      if (debug == true)
        print("could not get device info with err: " + e.toString());
    }
    return "";
  }

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Placemark?> _determinePlacemark() async {
    if (kIsWeb) {
      return null;
    }
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.unableToDetermine) {
        return null;
      } else if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return null;
      }
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      _placemark = placemarks.first;
      return placemarks.first;
    } catch (e) {
      if (debug == true)
        print("could not get location with err: " + e.toString());
      return null;
    }
  }
}
