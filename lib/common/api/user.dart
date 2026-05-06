import '../index.dart';

/// 用户
class UserAPI {
  /// 登录
  static Future<UserLoginResponseEntity> login({
    UserLoginRequestEntity? params,
  }) async {
    final result = await HttpUtil.post('/api/login', params: params?.toJson());
    print('Login result: $result');
    if (result.success && result.data != null) {
      final entity = UserLoginResponseEntity.fromJson(result.data);
      if (entity.accessToken != null) {
        await UserStore.to.setToken(entity.accessToken!);
        await UserStore.to.saveProfile(entity);
      }
      return entity;
    }
    return UserLoginResponseEntity();
  }

  /// Profile
  static Future<UserLoginResponseEntity> profile() async {
    final result = await HttpUtil.get('/api/user/profile');
    if (result.success && result.data != null) {
      final entity = UserLoginResponseEntity.fromJson(result.data);
      await UserStore.to.saveProfile(entity);
      return entity;
    }
    return UserLoginResponseEntity();
  }

  /// Logout
  static Future logout() async {
    await HttpUtil.post('/api/logout', showLoading: false);
  }
}
