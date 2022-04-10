import 'package:dart_softcorp_cloud/cloud_project.pbgrpc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class Authorize {
  Future<String> getAccessToken();
}

class SoftcorpAuthorize implements Authorize {
  // _grpcProjectClient is an object to communicate with the server
  late final ProjectServiceClient _grpcProjectClient;
  // _apiKey used to authorize requests
  late final String _apiKey;
  // _accessToken is used to connect clients to the api
  late String _accessToken;

  SoftcorpAuthorize({required ProjectServiceClient projectClient, required String apiKey}) {
    _grpcProjectClient = projectClient;
    _apiKey = apiKey;
  }

  @override
  Future<String> getAccessToken() async {
    // check if we have valid existing tokens
    if(_accessToken != ""){
      // validate tokens
      if(!JwtDecoder.isExpired(_accessToken)){
        return _accessToken;
      }
    }
    if(!JwtDecoder.isExpired(_apiKey)){
      throw Exception("api key is expired or otherwise malformed");
    }
    ProjectRequest req = ProjectRequest();
    req.privateKey = _apiKey;
    ProjectResponse resp = await _grpcProjectClient.generateAccessToken(req);
    _accessToken = resp.accessToken;
    return _accessToken;
  }
}
