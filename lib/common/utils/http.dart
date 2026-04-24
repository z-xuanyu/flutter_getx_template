import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../store/user.dart';
import 'loading.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/web';
  final http.Client _client = http.Client();

  HttpUtil._internal();

  /*
   * error统一处理
   */
  void onError(ErrorEntity eInfo) {
    switch (eInfo.code) {
      case 400:
        EasyLoading.showError(eInfo.message);
      case 401:
        EasyLoading.showError(eInfo.message);
        break;
      case -1:
        EasyLoading.showError(eInfo.message);
      default:
        EasyLoading.showError('未知错误');
        break;
    }
  }

  ErrorEntity createErrorEntity(http.Response? response) {
    if (response == null) {
      return ErrorEntity(code: -1, message: '网络请求失败');
    }

    try {
      final int errCode = response.statusCode;

      // 尝试解析 API 响应的错误信息
      Map<String, dynamic>? data;
      try {
        if (response.body.isNotEmpty) {
          data = jsonDecode(response.body);
        }
      } catch (_) {}

      final errMsg = data?['message'] ?? '请求错误';

      switch (errCode) {
        case 400:
          return ErrorEntity(code: errCode, message: errMsg);
        case 401:
          return ErrorEntity(code: errCode, message: "没有权限");
        case 403:
          return ErrorEntity(code: errCode, message: "服务器拒绝执行");
        case 404:
          return ErrorEntity(code: errCode, message: "无法连接服务器");
        case 405:
          return ErrorEntity(code: errCode, message: "请求方法被禁止");
        case 500:
          return ErrorEntity(code: errCode, message: "服务器内部错误");
        case 502:
          return ErrorEntity(code: errCode, message: "无效的请求");
        case 503:
          return ErrorEntity(code: errCode, message: "服务器挂了");
        case 505:
          return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
        default:
          return ErrorEntity(code: errCode, message: errMsg);
      }
    } on Exception catch (_) {
      return ErrorEntity(code: -1, message: response.body.isNotEmpty ? response.body : '请求失败');
    }
  }

  /// 读取本地配置
  Map<String, String>? getAuthorizationHeader() {
    var headers = <String, String>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    }
    return headers;
  }

  /// 通用请求方法
  Future<dynamic> _sendRequest(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$_baseUrl$path').replace(
      queryParameters: queryParameters,
    );

    final requestHeaders = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
      ...?headers,
      ...?getAuthorizationHeader(),
    };

    try {
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(url, headers: requestHeaders);
          break;
        case 'POST':
          response = await _client.post(
            url,
            headers: requestHeaders,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        case 'PUT':
          response = await _client.put(
            url,
            headers: requestHeaders,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        case 'PATCH':
          response = await _client.patch(
            url,
            headers: requestHeaders,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        case 'DELETE':
          response = await _client.delete(
            url,
            headers: requestHeaders,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        default:
          throw ErrorEntity(code: -1, message: '不支持的请求方法');
      }

      return _handleResponse(response);
    } catch (e) {
      Loading.dismiss();
      final error = ErrorEntity(code: -1, message: e.toString());
      onError(error);
      rethrow;
    }
  }

  /// 处理响应
  dynamic _handleResponse(http.Response response) {
    final code = response.statusCode;

    if (code < 200 || code >= 300) {
      Loading.dismiss();
      final error = createErrorEntity(response);
      onError(error);
      throw error;
    }

    try {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final int apiCode = data['code'] ?? 0;

      if (apiCode != 0) {
        Loading.dismiss();
        final String message = data['message'] ?? '请求错误';
        EasyLoading.showError(message);
        throw ErrorEntity(code: apiCode, message: message);
      }

      return data['data'];
    } catch (e) {
      Loading.dismiss();
      final error = ErrorEntity(code: -1, message: '解析响应失败');
      onError(error);
      throw error;
    }
  }

  /// restful get 操作
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return await _sendRequest(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  /// restful post 操作
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return await _sendRequest(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  /// restful put 操作
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return await _sendRequest(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  /// restful patch 操作
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return await _sendRequest(
      path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  /// restful delete 操作
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return await _sendRequest(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  /// restful post form 表单提交操作
  Future postForm(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$_baseUrl$path').replace(
      queryParameters: queryParameters,
    );

    final requestHeaders = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      ...?headers,
      ...?getAuthorizationHeader(),
    };

    try {
      final response = await _client.post(
        url,
        headers: requestHeaders,
        body: data,
      );

      return _handleResponse(response);
    } catch (e) {
      Loading.dismiss();
      final error = ErrorEntity(code: -1, message: e.toString());
      onError(error);
      rethrow;
    }
  }

  /// 关闭客户端
  void close() {
    _client.close();
  }
}

// 异常处理
class ErrorEntity implements Exception {
  int code = -1;
  String message = "";
  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}
