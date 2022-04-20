import 'dart:io';
import 'package:dart_blocks/nuntio_credentials/nuntio_credentials.dart';
import "package:grpc/grpc.dart";
import 'dart:convert';

class NuntioNoCredentials implements TransportCredentials {

  @override
  Future<ChannelCredentials> getTransportCredentials() async {
    return ChannelCredentials.insecure();
  }
}
