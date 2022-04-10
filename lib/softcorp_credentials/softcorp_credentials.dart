import 'dart:io';
import "package:grpc/grpc.dart";
import 'dart:convert';

abstract class TransportCredentials {
  Future<ChannelCredentials> getTransportCredentials();
}

class SoftcorpCredentials implements TransportCredentials {
  static late Uri _apiUrl;

  SoftcorpCredentials({required apiUrl}) {
    if (apiUrl == "") {
      throw Exception("api url is empty");
    }
    _apiUrl = apiUrl;
  }

  bool onBadCertificate(cert, comment) {
    throw Exception("bad certificate");
  }

  @override
  Future<ChannelCredentials> getTransportCredentials() async {
    RawSecureSocket socket =
        await RawSecureSocket.connect(_apiUrl.host, _apiUrl.port);
    if (socket.peerCertificate == null) {
      throw Exception("peer certificate is null. Contact info@softcorp.io");
    }
    X509Certificate x509certificate = socket.peerCertificate!;
    return ChannelCredentials.secure(
      certificates: utf8.encode(x509certificate.pem),
      onBadCertificate: onBadCertificate,
      authority: _apiUrl.host,
    );
  }
}
