import 'dart:convert';

class LoginResponseModel {
  String? accessToken;
  String? refreshToken;

  LoginResponseModel({
    this.accessToken,
    this.refreshToken,
  });

  factory LoginResponseModel.fromJson(String str) =>
      LoginResponseModel.fromMap(json.decode(str));

  String get getAccessToken => accessToken ?? '';

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromMap(Map<String, dynamic> json) =>
      LoginResponseModel(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toMap() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };

  @override
  String toString() =>
      'LoginResponseModel(accessToken: $accessToken, refreshToken: $refreshToken)';
}
