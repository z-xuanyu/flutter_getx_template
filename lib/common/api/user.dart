import '../index.dart';

/// 用户
class UserAPI {
  /// 登录
  static Future<UserLoginResponseEntity> login({
    UserLoginRequestEntity? params,
  }) async {
    var response = await HttpUtil().post('/auth/login', data: params?.toJson());
    return UserLoginResponseEntity.fromJson(response);
  }

  /// Profile
  static Future<UserLoginResponseEntity> profile() async {
    var response = await HttpUtil().post('/auth/profile');
    return UserLoginResponseEntity.fromJson(response);
  }

  /// Logout
  static Future logout() async {
    return await HttpUtil().post('/auth/logout');
  }
}
