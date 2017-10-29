import 'package:test/test.dart';
import 'package:recaptcha_verifier/recaptcha_verifier.dart';

main() async {
  test('invalid secret and response', () async {
    final String secret = 'invalid-secret';
    final String response = 'invalid-response';
    final verifier = new RecaptchaVerifier(secret);
    final result = await verifier.verify(response);
    expect(result.success, equals(false));
    expect(result.errorCodes, contains('invalid-input-secret'));
    expect(result.errorCodes, contains('invalid-input-response'));
  });
  //  You can set your valid secret and recaptcha response,
  //  uncomment the test and run it
  // test('valid secret and response', () async {
  //   final String secret = '';
  //   final String response = '';
  //   final verifier = new RecaptchaVerifier(secret);
  //   final result = await verifier.verify(response);
  //   expect(result.success, equals(true));
  // });
}