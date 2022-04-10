import 'package:dart_blocks/softcorp_authorize/softcorp_authorize.dart';
import 'package:dart_blocks/softcorp_credentials/softcorp_credentials.dart';
import 'package:dart_blocks/user_client/user_client.dart';
import 'package:dart_softcorp_cloud/cloud_project.pbgrpc.dart';
import 'package:grpc/grpc_web.dart';
import 'package:grpc/grpc.dart';
import 'package:dart_softcorp_blocks/block_user.pbgrpc.dart';
import 'dart:html';

class SoftcorpClient {
  // _encryptionKey  is used to encrypt clients data under the given key
  static late String _encryptionKey;

  // _apiKey  is used to connect your application to Softcorp Cloud
  static late String _apiKey;

  // _apiUrl  is the URL the SDK will try to connect to (only edit this if you know what you are doing)
  static var _apiUrl = "api.softcorp.io:443";

  // _namespace defines what namespace you want to use with Softcorp Blocks (only edit this if you know what you are doing)
  static late String _namespace;

  // _grpcUserClient is an object to communicate with the server
  static late UserServiceClient _grpcUserClient;

  // _grpcUserClient is an object to communicate with the server
  static late ProjectServiceClient _grpcProjectClient;

  // userClient is used to make requests
  static UserClient? userClient;

  SoftcorpClient({required apiKey, encryptionKey, apiUrl, namespace}) {
    _encryptionKey = encryptionKey;
    _apiKey = apiKey;
    if (apiUrl != "") {
      _apiUrl = apiUrl;
    }
    _namespace = namespace;
  }

  static Future<void> initialize(
      {web = false, TransportCredentials? transportCredentials}) async {
    // build channel
    transportCredentials ??= SoftcorpCredentials(
        apiUrl: Uri.parse("https://stage.api.softcorp.io:443"));
    ChannelCredentials channelCredentials =
        await transportCredentials.getTransportCredentials();
    if (web) {
      GrpcWebClientChannel apiWebChannel =
          GrpcWebClientChannel.xhr(Uri.parse(_apiUrl));
      _grpcUserClient = UserServiceClient(apiWebChannel);
      _grpcProjectClient = ProjectServiceClient(apiWebChannel);
    } else {
      ClientChannel apiChannel = ClientChannel(
        Uri.parse(_apiUrl),
        options: ChannelOptions(credentials: channelCredentials),
      );
      _grpcUserClient = UserServiceClient(apiChannel);
      _grpcProjectClient = ProjectServiceClient(apiChannel);
    }
    // build authorize
    SoftcorpAuthorize authorize =
        SoftcorpAuthorize(projectClient: _grpcProjectClient, apiKey: _apiKey);
    userClient = UserClient(
      grpcUserClient: _grpcUserClient,
      encryptionKey: _encryptionKey,
      authorize: authorize,
    );
  }
}
