import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../index.dart';

enum HttpMethod { get, post, put, patch, delete }

class HttpResult {
  final bool success;
  final int code;
  final dynamic data;
  final String? message;
  final int? statusCode;

  HttpResult({
    required this.success,
    this.code = 0,
    this.data,
    this.message,
    this.statusCode,
  });
}

class HttpUtil {
  static const String _defaultBaseUrl = 'http://localhost:3000/web';
  static const Duration _defaultTimeout = Duration(seconds: 30);

  static String baseUrl = _defaultBaseUrl;
  static Duration timeout = _defaultTimeout;
  static Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<HttpResult> request(
    String path, {
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Duration? timeout,
    bool showLoading = true,
    bool showError = true,
  }) async {
    if (showLoading) {
      Loading.show();
    }

    try {
      final uri = Uri.parse('$baseUrl$path');
      final requestHeaders = <String, String>{...defaultHeaders};
      if (headers != null) {
        requestHeaders.addAll(headers);
      }

      final token = UserStore.to.token;
      if (token.isNotEmpty) {
        requestHeaders['Authorization'] = 'Bearer $token';
      }

      final effectiveTimeout = timeout ?? HttpUtil.timeout;
      final client = http.Client();

      try {
        http.Response response;

        switch (method) {
          case HttpMethod.get:
            final getParams = params?.map((k, v) => MapEntry(k, v.toString())) ?? {};
            final getUri = uri.replace(queryParameters: getParams.isNotEmpty ? getParams : null);
            response = await client
                .get(getUri, headers: requestHeaders)
                .timeout(effectiveTimeout);
            break;
          case HttpMethod.post:
            response = await client
                .post(uri, headers: requestHeaders, body: jsonEncode(params))
                .timeout(effectiveTimeout);
            break;
          case HttpMethod.put:
            response = await client
                .put(uri, headers: requestHeaders, body: jsonEncode(params))
                .timeout(effectiveTimeout);
            break;
          case HttpMethod.patch:
            response = await client
                .patch(uri, headers: requestHeaders, body: jsonEncode(params))
                .timeout(effectiveTimeout);
            break;
          case HttpMethod.delete:
            response = await client
                .delete(uri, headers: requestHeaders, body: jsonEncode(params))
                .timeout(effectiveTimeout);
            break;
        }

        return _handleResponse(response, showError);
      } finally {
        client.close();
      }
    } on SocketException {
      return HttpResult(
        success: false,
        message: '请检查网络连接',
      );
    } on TimeoutException {
      return HttpResult(
        success: false,
        message: '请求超时，请稍后重试',
      );
    } on FormatException {
      return HttpResult(
        success: false,
        message: '数据格式错误',
      );
    } catch (e) {
      Logger.write('Http请求异常: $e', isError: true);
      return HttpResult(
        success: false,
        message: '网络异常，请稍后重试',
      );
    } finally {
if (showLoading) {
      Loading.dismiss();
    }
    }
  }

  static HttpResult _handleResponse(http.Response response, bool showError) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return HttpResult(success: true, statusCode: statusCode);
      }
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData is! Map<String, dynamic>) {
          return HttpResult(
            success: true,
            data: jsonData,
            statusCode: statusCode,
          );
        }

        final code = jsonData['code'] as int? ?? 0;
        final message = jsonData['message'] as String?;
        final data = jsonData['data'];

        if (code == 0) {
          return HttpResult(
            success: true,
            code: code,
            data: data,
            message: message,
            statusCode: statusCode,
          );
        }

        final errorMsg = message ?? _getCodeMessage(code);
        if (showError) {
          Loading.toast(errorMsg);
        }

        if (code == 401) {
          _handleUnauthorized();
        }

        return HttpResult(
          success: false,
          code: code,
          data: data,
          message: errorMsg,
          statusCode: statusCode,
        );
      } catch (e) {
        return HttpResult(
          success: true,
          data: response.body,
          statusCode: statusCode,
        );
      }
    }

    String message;
    switch (statusCode) {
      case 400:
        message = '请求参数错误';
        break;
      case 401:
        message = '登录已过期，请重新登录';
        _handleUnauthorized();
        break;
      case 403:
        message = '无权限操作';
        break;
      case 404:
        message = '请求资源不存在';
        break;
      case 500:
        message = '服务器内部错误';
        break;
      case 502:
        message = '服务器网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      default:
        message = '网络异常，请稍后重试';
    }

    if (showError) {
      Loading.toast(message);
    }

    return HttpResult(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  static String _getCodeMessage(int code) {
    switch (code) {
      case 400:
        return '请求参数错误';
      case 401:
        return '登录已过期，请重新登录';
      case 403:
        return '无权限操作';
      case 404:
        return '请求资源不存在';
      case 500:
        return '服务器内部错误';
      case 501:
        return '功能未实现';
      case 502:
        return '服务器网关错误';
      case 503:
        return '服务不可用';
      default:
        return '网络异常，请稍后重试';
    }
  }

  static void _handleUnauthorized() {
    if (UserStore.to.isLogin) {
      UserStore.to.onLogout();
    }
    Get.offAllNamed(RouteNames.signIn);
  }

  static Future<HttpResult> get(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Duration? timeout,
    bool showLoading = true,
    bool showError = true,
  }) {
    return request(
      path,
      method: HttpMethod.get,
      params: params,
      headers: headers,
      timeout: timeout,
      showLoading: showLoading,
      showError: showError,
    );
  }

  static Future<HttpResult> post(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Duration? timeout,
    bool showLoading = true,
    bool showError = true,
  }) {
    return request(
      path,
      method: HttpMethod.post,
      params: params,
      headers: headers,
      timeout: timeout,
      showLoading: showLoading,
      showError: showError,
    );
  }

  static Future<HttpResult> put(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Duration? timeout,
    bool showLoading = true,
    bool showError = true,
  }) {
    return request(
      path,
      method: HttpMethod.put,
      params: params,
      headers: headers,
      timeout: timeout,
      showLoading: showLoading,
      showError: showError,
    );
  }

  static Future<HttpResult> patch(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Duration? timeout,
    bool showLoading = true,
    bool showError = true,
  }) {
    return request(
      path,
      method: HttpMethod.patch,
      params: params,
      headers: headers,
      timeout: timeout,
      showLoading: showLoading,
      showError: showError,
    );
  }

  static Future<HttpResult> delete(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Duration? timeout,
    bool showLoading = true,
    bool showError = true,
  }) {
    return request(
      path,
      method: HttpMethod.delete,
      params: params,
      headers: headers,
      timeout: timeout,
      showLoading: showLoading,
      showError: showError,
    );
  }

  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  static void setTimeout(Duration duration) {
    timeout = duration;
  }

  static void setDefaultHeader(String key, String value) {
    defaultHeaders[key] = value;
  }

  static void removeDefaultHeader(String key) {
    defaultHeaders.remove(key);
  }
}