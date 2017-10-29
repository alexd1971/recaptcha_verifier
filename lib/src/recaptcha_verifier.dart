import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RecaptchaVerifier {
  static const String _url = 'https://www.google.com/recaptcha/api/siteverify';
  final String _secret;
  
  RecaptchaVerifier(String secret) : _secret = secret;

  Future<VerificationResult> verify(String response, [String ip]) async {

    Map<String, String> requestBody = {
      'secret': _secret,
      'response': response
    };
    if(ip != null) requestBody['ip'] = ip;

    final httpClient = new http.Client();
    final httpResponse = await httpClient.post(
      _url,
      body: requestBody
    );
    if(httpResponse.statusCode == 200) {
      print(JSON.decode(httpResponse.body));
      return new VerificationResult.fromMap(JSON.decode(httpResponse.body));
    } else {
      throw new RecaptchaVerifierException('Could not get verification response: ${httpResponse.reasonPhrase}');
    }
  }
}

class VerificationResult {
  bool _success;
  DateTime _challengeTime;
  String _hostname;
  List<String> _errorCodes = [];
  
  VerificationResult.fromMap(Map<String, dynamic> results):
    _success = results['success'],
    _challengeTime = results['challenge_ts'] == null ? null : DateTime.parse(results['challenge_ts']),
    _hostname = results['hostname'],
    _errorCodes = results['error-codes'];
  
  bool get success => _success;
  DateTime get challengeTime => _challengeTime;
  String get hostname => _hostname;
  List<String> get errorCodes => _errorCodes;

}

class RecaptchaVerifierException implements Exception {
  final String message;
  RecaptchaVerifierException([this.message]);

  String toString() {
    if(message == null) return 'RecaptchaVerifierException';
    return 'RecaptchaVerifierException: $message';
  }
}