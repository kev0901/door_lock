class keycloak_token {
  late String access_token;
  late String refresh_token;

  keycloak_token.fromJson(Map<String, dynamic> json) {
    access_token = json['access_token'];
    refresh_token = json['access_token'];
  }
}
