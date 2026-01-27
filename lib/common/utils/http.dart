import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;
// import 'package:get/get.dart' hide FormData;

import '../store/user.dart';
import 'loading.dart';

/*
  * http 操作类
  *
  * 手册
  * https://github.com/flutterchina/dio/blob/master/README-ZH.md
  *
  * 从 3 升级到 4
  * https://github.com/flutterchina/dio/blob/master/migration_to_4.x.md
*/
class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();

  HttpUtil._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
      // 请求基地址,可以包含子路径
      baseUrl: 'http://localhost:3000/web',

      // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );
    dio = Dio(options);
    // Cookie管理
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    // 添加拦截器
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options); //continue
        },
        onResponse: (response, handler) {
          final code = response.data?['code'];
          if (code != 0) {
            final message = response.data?['message'] ?? '请求错误';
            EasyLoading.showError(message);
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
                error: message,
              ),
            );
          }
          return handler.next(response); // continue
        },
        onError: (DioException e, handler) {
          Loading.dismiss();
          ErrorEntity eInfo = createErrorEntity(e);
          onError(eInfo);
          return handler.next(e); //continue
        },
      ),
    );
  }

  /*
   * error统一处理
   */

  // 错误处理
  void onError(ErrorEntity eInfo) {
    switch (eInfo.code) {
      case 400:
        EasyLoading.showError(eInfo.message);
      case 401:
        // UserStore.to.onLogout();
        EasyLoading.showError(eInfo.message);
        break;
      case -1:
        EasyLoading.showError(eInfo.message);
      default:
        EasyLoading.showError('未知错误');
        break;
    }
  }

  // 错误信息
  ErrorEntity createErrorEntity(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return ErrorEntity(code: -1, message: "请求取消");
      case DioExceptionType.connectionTimeout:
        return ErrorEntity(code: -1, message: "连接超时");
      case DioExceptionType.sendTimeout:
        return ErrorEntity(code: -1, message: "请求超时");
      case DioExceptionType.receiveTimeout:
        return ErrorEntity(code: -1, message: "响应超时");
      case DioExceptionType.badResponse:
        {
          try {
            int errCode = error.response != null
                ? error.response!.statusCode!
                : -1;

            final errMsg = error.response?.data?['message'];
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
                {
                  return ErrorEntity(code: errCode, message: '其他错误');
                }
            }
          } on Exception catch (_) {
            final errMsg = error.response?.data?['message'];
            return ErrorEntity(code: -1, message: errMsg);
          }
        }
      default:
        {
          return ErrorEntity(code: -1, message: error.message ?? '');
        }
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /// 读取本地配置
  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    }
    return headers;
  }

  /// restful get 操作
  /// refresh 是否下拉刷新 默认 false
  /// noCache 是否不缓存 默认 true
  /// list 是否列表 默认 false
  /// cacheKey 缓存key
  /// cacheDisk 是否磁盘缓存
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = true,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.extra ??= <String, dynamic>{};
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response.data?['data'];
  }

  /// restful post 操作
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data?['data'];
  }

  /// restful put 操作
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data?['data'];
  }

  /// restful patch 操作
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data?['data'];
  }

  /// restful delete 操作
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data?['data'];
  }

  /// restful post form 表单提交操作
  Future postForm(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data?['data'];
  }

  /// restful post Stream 流数据
  Future postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data?['data'];
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
