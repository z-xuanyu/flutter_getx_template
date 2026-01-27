// To parse this JSON data, do
//
//     final userLoginRequestEntity = userLoginRequestEntityFromJson(jsonString);

import 'dart:convert';

UserLoginRequestEntity userLoginRequestEntityFromJson(String str) => UserLoginRequestEntity.fromJson(json.decode(str));

String userLoginRequestEntityToJson(UserLoginRequestEntity data) => json.encode(data.toJson());

class UserLoginRequestEntity {
    String phone;
    String password;

    UserLoginRequestEntity({
        required this.phone,
        required this.password,
    });

    factory UserLoginRequestEntity.fromJson(Map<String, dynamic> json) => UserLoginRequestEntity(
        phone: json["phone"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "phone": phone,
        "password": password,
    };
}
