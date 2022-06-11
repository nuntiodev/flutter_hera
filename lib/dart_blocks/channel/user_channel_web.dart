import 'package:grpc/grpc_web.dart';
import 'package:nuntio_blocks/block_user.pbgrpc.dart';
import 'package:nuntio_cloud/cloud.pbgrpc.dart';

class NuntioChannel {
  static UserServiceClient userServiceClient(String url) {
    var uri = Uri.parse(url);
    return UserServiceClient(GrpcWebClientChannel.xhr(uri));
  }
  static CloudServiceClient cloudServiceClient(String url) {
    var uri = Uri.parse(url);
    return CloudServiceClient(GrpcWebClientChannel.xhr(uri));
  }
}
