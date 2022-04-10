// Import the test package and Counter class
import 'package:dart_blocks/softcorp_credentials/softcorp_credentials.dart';
import 'package:test/test.dart';

void main() {
  test('Should return a valid x509 certificate', () async {
    final SoftcorpCredentials softcorpCredentials = SoftcorpCredentials(apiUrl: Uri.parse("https://stage.api.softcorp.io:443"));
    var credentials = await softcorpCredentials.getTransportCredentials();
    expect(credentials.isSecure, true);
  });
}