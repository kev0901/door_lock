import 'dart:convert';

import 'package:app/type/keycloak_token.dart';
import 'package:http/http.dart' as http;

String BackendServerUrl = 'http://127.0.0.1:3001';
String AuthServerUrl = 'http://192.168.35.191:5050';
String GetTokenUrl = 'realms/quickstart/protocol/openid-connect/token';

Uri getUri(String baseUrl, String cmd) {
  return Uri.parse('$baseUrl/$cmd');
}

Future<http.Response> getTokenWithUsernameAndPw(
    String userName, String password) async {
  return await http.post(
    getUri(AuthServerUrl, GetTokenUrl),
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    // encoding: Encoding.getByName('utf-8'),
    body: {
      "username": userName,
      "grant_type": "password",
      "password": password,
      "realmName": "quickstart", // todo: add quickstart to real realm name
      "client_id": "test-cli", // todo: real client
    },
  );
}

Future<http.Response> postToBackendServerWithAuth(
    String cmdUrl, keycloak_token token, Map<String, dynamic> data) async {
  return http.post(
    getUri(BackendServerUrl, cmdUrl),
    headers: {
      'Authorization': 'Bearer ${token.access_token}',
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );
}

Future<http.Response> postToBackendServer(
    String cmdUrl, Map<String, dynamic> data) async {
  return http.post(
    getUri(BackendServerUrl, cmdUrl),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );
}
