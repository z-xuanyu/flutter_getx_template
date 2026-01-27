// To parse this JSON data, do
//
//     final userLoginResponseEntity = userLoginResponseEntityFromJson(jsonString);

import 'dart:convert';

UserLoginResponseEntity userLoginResponseEntityFromJson(String str) =>
    UserLoginResponseEntity.fromJson(json.decode(str));

String userLoginResponseEntityToJson(UserLoginResponseEntity data) =>
    json.encode(data.toJson());

class UserLoginResponseEntity {
  String? accessToken;
  String? refreshToken;

  UserLoginResponseEntity({this.accessToken, this.refreshToken});

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
  };
}
