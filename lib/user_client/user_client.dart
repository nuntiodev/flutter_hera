import 'package:dart_blocks/softcorp_authorize/softcorp_authorize.dart';
import 'package:dart_softcorp_blocks/block_user.pbgrpc.dart';

class UserClient {
  // _grpcUserClient is an object to communicate with the server
  late final UserServiceClient _grpcUserClient;
  late final String _encryptionKey;
  late final Authorize _authorize;

  UserClient({
    required UserServiceClient grpcUserClient,
    required Authorize authorize,
    String? encryptionKey,
  }) {
    _grpcUserClient = grpcUserClient;
    _authorize = authorize;
    _encryptionKey = encryptionKey ?? "";
  }

  Future<User> create({
    String? userId,
    String? optionalId,
    String? email,
    String? image,
    String? password,
    bool? validatePassword,
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
    UserResponse resp  = await _grpcUserClient.create(req);
    return resp.user;
  }
}
