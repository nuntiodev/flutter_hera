import 'package:grpc/grpc.dart';
import 'package:nuntio_blocks/block_user.pbgrpc.dart';
import 'package:nuntio_cloud/cloud.pbgrpc.dart';

import '../../nuntio_credentials/nuntio_credentials.dart';

class NuntioChannel {
  static Future<UserServiceClient> userServiceClient(String url) async {
    Uri apiUri = Uri.parse(url);
    TransportCredentials transportCredentials = NuntioCredentials(
      apiUrl: apiUri,
    );
    ChannelCredentials channelCredentials =
        await transportCredentials.getTransportCredentials();
    return UserServiceClient(ClientChannel(apiUri.host, port: apiUri.port, options: ChannelOptions(credentials: channelCredentials)));
  }

  static Future<CloudServiceClient> cloudServiceClient(String url) async {
    Uri apiUri = Uri.parse(url);
    TransportCredentials transportCredentials = NuntioCredentials(
      apiUrl: apiUri,
    );
    ChannelCredentials channelCredentials =
    await transportCredentials.getTransportCredentials();
    return CloudServiceClient(ClientChannel(apiUri.host, port: apiUri.port, options: ChannelOptions(credentials: channelCredentials)));
  }
}
