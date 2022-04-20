import 'package:nuntio_cloud/cloud_project.pbgrpc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class Authorize {
  Future<String> getAccessToken();
}

class NuntioAuthorize implements Authorize {
  // _grpcProjectClient is an object to communicate with the dart_blocks
  late final ProjectServiceClient _grpcProjectClient;

  // _apiKey used to authorize requests
  String _apiKey = "";

  // _accessToken is used to connect clients to the api
  String _accessToken = "";

  NuntioAuthorize(
      {required ProjectServiceClient projectClient, required String apiKey}) {
    _grpcProjectClient = projectClient;
    _apiKey = apiKey;
  }

  @override
  Future<String> getAccessToken() async {
    // check if we have valid existing tokens
    if (_accessToken != "") {
      // validate tokens
      try {
        if (JwtDecoder.isExpired(_accessToken) == false) {
          return _accessToken;
        }
      } catch(e){
        print("could not validate expiration date of token");
      }
    }
    try {
      ProjectRequest req = ProjectRequest();
      req.privateKey = _apiKey;
      ProjectResponse resp = await _grpcProjectClient.generateAccessToken(req);
      _accessToken = resp.accessToken;
      return _accessToken;
    } catch (e) {
      print("could not get access token");
      rethrow;
    }
  }
}
