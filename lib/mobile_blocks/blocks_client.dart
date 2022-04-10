import 'package:dart_blocks/mobile_blocks/user_client/user_client.dart';
import 'package:dart_blocks/softcorp_authorize/softcorp_authorize.dart';
import 'package:dart_blocks/softcorp_credentials/softcorp_credentials.dart';
import 'package:dart_softcorp_cloud/cloud_project.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:dart_softcorp_blocks/block_user.pbgrpc.dart';

class BlocksClient {
  // _encryptionKey  is used to encrypt clients data under the given key
  static late String _encryptionKey;

  // _apiKey  is used to connect your application to Softcorp Cloud
  static late String _apiKey;

  // _apiUrl  is the URL the SDK will try to connect to (only edit this if you know what you are doing)
  static var _apiUrl = "https://api.softcorp.io:443";

  // _namespace defines what namespace you want to use with Softcorp Blocks (only edit this if you know what you are doing)
  static late String _namespace;

  // _grpcUserClient is an object to communicate with the mobile_blocks
  static late UserServiceClient _grpcUserClient;

  // _grpcUserClient is an object to communicate with the mobile_blocks
  static late ProjectServiceClient _grpcProjectClient;

  // userClient is used to make requests
  static UserClient? userClient;

  static Future<void> initialize(
      {required String apiKey,
      String? encryptionKey,
      String? apiUrl,
      String? namespace,
      TransportCredentials? transportCredentials}) async {
    // set values
    _encryptionKey = encryptionKey ?? "";
    _apiKey = apiKey;
    _namespace = namespace ?? "";
    _apiUrl = apiUrl ?? _apiUrl;
    // build uri
    Uri apiUri = Uri.parse(_apiUrl);
    // build channel
    transportCredentials ??= SoftcorpCredentials(
      apiUrl: apiUri,
    );
    ChannelCredentials channelCredentials =
        await transportCredentials.getTransportCredentials();
    ClientChannel apiChannel = ClientChannel(
      apiUri.host,
      port: apiUri.port,
      options: ChannelOptions(credentials: channelCredentials),
    );
    _grpcUserClient = UserServiceClient(apiChannel);
    _grpcProjectClient = ProjectServiceClient(apiChannel);
    // build authorize
    Authorize authorize =
        SoftcorpAuthorize(projectClient: _grpcProjectClient, apiKey: _apiKey);
    // get block user public key
    UserRequest publicKeysReq = UserRequest();
    publicKeysReq.cloudToken = await authorize.getAccessToken();
    UserResponse publicKeysResp =
        await _grpcUserClient.publicKeys(publicKeysReq);
    String? jwtPublicKey = publicKeysResp.publicKeys["public-jwt-key"];
    userClient = UserClient(
      grpcUserClient: _grpcUserClient,
      encryptionKey: _encryptionKey,
      jwtPublicKey: jwtPublicKey,
      authorize: authorize,
    );
  }
}
