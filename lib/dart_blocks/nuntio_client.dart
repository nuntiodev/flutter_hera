import 'package:dart_blocks/dart_blocks/user_block/user_block.dart';
import 'package:dart_blocks/nuntio_authorize/nuntio_authorize.dart';
import 'package:dart_blocks/nuntio_credentials/nuntio_credentials.dart';
import 'package:nuntio_cloud/cloud_project.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:nuntio_blocks/block_user.pbgrpc.dart';

class NuntioClient {
  // _encryptionKey  is used to encrypt clients data under the given key
  static late String _encryptionKey;

  // _apiKey  is used to connect your application to Nuntio Cloud
  static late String _apiKey;

  // _apiUrl  is the URL the SDK will try to connect to (only edit this if you know what you are doing)
  static var _apiUrl = "https://api.nuntio.io:443";

  // _namespace defines what namespace you want to use with Nuntio Blocks (only edit this if you know what you are doing)
  static late String _namespace;

  // _grpcUserClient is an object to communicate with the dart_blocks
  static late UserServiceClient _grpcUserClient;

  // _grpcUserClient is an object to communicate with the dart_blocks
  static late ProjectServiceClient _grpcProjectClient;

  // userClient is used to make requests
  static late UserBlock userBlock;

  static Future<void> initialize({
    String? apiKey,
    String? encryptionKey,
    String? apiUrl,
    String? namespace,
    TransportCredentials? transportCredentials,
  }) async {
    // set values
    _encryptionKey = encryptionKey ?? "";
    _apiKey = apiKey ?? "";
    _namespace = namespace ?? "";
    _apiUrl = apiUrl ?? _apiUrl;
    // build uri
    Uri apiUri = Uri.parse(_apiUrl);
    // build channel
    transportCredentials ??= NuntioCredentials(
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
        NuntioAuthorize(projectClient: _grpcProjectClient, apiKey: _apiKey);
    // get block user public key
    UserRequest publicKeysReq = UserRequest();
    publicKeysReq.cloudToken = await authorize.getAccessToken();
    UserResponse publicKeysResp =
        await _grpcUserClient.publicKeys(publicKeysReq);
    //todo: find out why this is empty
    String? jwtPublicKey = publicKeysResp.publicKeys["public-jwt-key"];
    userBlock = UserBlock(
      grpcUserClient: _grpcUserClient,
      encryptionKey: _encryptionKey,
      jwtPublicKey: jwtPublicKey,
      authorize: authorize,
    );
  }
}
