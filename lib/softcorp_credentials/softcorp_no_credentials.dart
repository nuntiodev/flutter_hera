import 'dart:io';
import 'package:dart_blocks/softcorp_credentials/softcorp_credentials.dart';
import "package:grpc/grpc.dart";
import 'dart:convert';

class SoftcorpNoCredentials implements TransportCredentials {

  @override
  Future<ChannelCredentials> getTransportCredentials() async {
    return ChannelCredentials.insecure();
  }
}
