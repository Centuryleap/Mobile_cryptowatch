import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:likeplay/core/repositories/hive_repository.dart';
import 'package:likeplay/core/services/api_error_response.dart';
import 'package:likeplay/core/services/api_response.dart';
import 'package:likeplay/core/services/connection_service.dart';
import 'package:likeplay/core/util/app_string.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import 'secure_storage_service.dart';

// abstract class DioService {
//   Future appDelete(
//     String uri, {
//     data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//   });
//   Future appGet(
//     String uri, {
//     Map<String, dynamic>? queryParameters,
//     CancelToken? cancelToken,
//     ProgressCallback? onReceiveProgress,
//   });

//   Future appPost(
//     String uri, {
//     data,
//     Map<String, dynamic>? queryParameters,
//     CancelToken? cancelToken,
//     ProgressCallback? onSendProgress,
//     ProgressCallback? onReceiveProgress,
//   });

//   Future appPatch(
//     String uri, {
//     data,
//     Map<String, dynamic>? queryParameters,
//     CancelToken? cancelToken,
//     ProgressCallback? onSendProgress,
//     ProgressCallback? onReceiveProgress,
//   });

//   Future appPut(
//     String uri, {
//     data,
//     Map<String, dynamic>? queryParameters,
//     CancelToken? cancelToken,
//     ProgressCallback? onSendProgress,
//     ProgressCallback? onReceiveProgress,
//   });
// }

abstract class ApiService {
  final _storageService = locator<SecureStorageService>();
 // final log = getLogger('DioService -');
  late Dio dio;
//Production 
  ApiService() {
    final options = BaseOptions(
      baseUrl: "https://api.likeplaylikeplay.net",
      receiveDataWhenStatusError: true,
      connectTimeout: 60 * 1000, // 60 seconds
      receiveTimeout: 60 * 1000, // 60 seconds
    );

    dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (
        options,
        handler,
      ) async {
        //no internet? reject request
        if (!await ConnectionStatus.isConnected()) {
          handler.reject(
            DioError(
              requestOptions: options,
              error:
                  "Oops! Looks like you're not connected to the internet. Check your internet connection and try again.",
            ),
          );
        }

        handler.next(options);
      }, onResponse: (response, handler) async {
        if (response.statusCode == 403) {
          dio.interceptors.requestLock.lock();

          dio.interceptors.requestLock.unlock();

          final token = await _storageService.getToken();

          options.headers["Authorization"] = "Bearer $token";

          handler.resolve(
            Response(
                requestOptions: response.requestOptions,
                statusCode: 403,
                data: {
                  'message': "Session timed out. Try again",
                }),
          );
        } else {
          handler.next(response);
        }
      }, onError: (error, handler) async {
        if (error.response?.statusCode == 403) {
          dio.interceptors.requestLock.lock();

          dio.interceptors.requestLock.unlock();

          final token = await _storageService.getToken();

          options.headers["Authorization"] = "Bearer $token";

          handler.resolve(
            Response(
                requestOptions: error.requestOptions,
                statusCode: 403,
                data: {
                  'message': "Session timed out. Try again",
                }),
          );
        } else {
          handler.next(error);
        }
      }),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _getDioHeader([bool useToken = false]) async {
    if (useToken) {
      final token = await locator<HiveRepository>()
          .get(key: AppString.token, name: AppString.token);
      return {
        "Content-Type": 'application/json',
        "Authorization": "Bearer " + token!.toString(),
      };
    }
    return {
      "Content-Type": 'application/json',
    };
  }

  Future<Either<Failure, Success>> makeRequest(Future<Response> future) async {
    try {
      var req = await future;

      var data = req.data;

     // log.e(data);

      if ("${req.statusCode}".startsWith('2')) {
        //CHECK THAT STATUS IS NOT FALSE
        if ((data["status"].toString()) != "false") {
          return Right(Success(data));
        } else {
          return Left(
            Failure(
              ApiErrorResponse(
                message: data["message"],
                // type: ParserUtil.parseApiErrorCode(data),
                data: data,
              ),
            ),
          );
        }
      } else {
        // if ("${req.statusCode}".startsWith('5')) {
        //   return Left(
        //     Failure(
        //       const ApiErrorResponse(
        //         message: "Oops. An error occured, please try again.",
        //         errorCode: 500,
        //       ),
        //     ),
        //   );
        // }
      }

      return Left(Failure.fromMap(data));
    } on DioError catch (e) {
      if ("${e.response?.statusCode}".startsWith('5')) {
        ///TODO show error dialog
        return Left(
          Failure(
            const ApiErrorResponse(
              message: "Oops. An error occured, please try again.",
              errorCode: 500,
            ),
          ),
        );
      }

      if (e.type == DioErrorType.connectTimeout) {
        return Left(
          Failure(
            const ApiErrorResponse(
              message: "Oops. Connection timeout, please try again.",
            ),
          ),
        );
      }

      if (e.type == DioErrorType.other) {
        return Left(
          Failure(
            const ApiErrorResponse(
              shouldDisplayError: false,
              message: "Oops. Check your internet connection and try again.",
            ),
          ),
        );
      }

      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          return Left(
            Failure(
              const ApiErrorResponse(
                message: "Resource not found",
              ),
            ),
          );
        }

        if (e.response?.data != null && e.response!.data is Map) {
          return Left(Failure.fromMap(e.response!.data));
        }

        return Left(
          Failure(
            ApiErrorResponse(message: e.message),
          ),
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        return Left(Failure(
          ApiErrorResponse(message: e.message),
        ));
      }
    }
  }

  Future<Either<Failure, Success>> delete(
    String uri, {
    bool useToken = false,
    Map<String, dynamic>? data,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return makeRequest(
        dio.delete(
          "/$uri",
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: await _getDioHeader(useToken)),
          cancelToken: cancelToken,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<Failure, Success>> get(
    String uri, {
    bool useToken = false,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return makeRequest(
        dio.request(
          "/$uri",
          data: data,
          options:
              Options(method: "GET", headers: await _getDioHeader(useToken)),
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<Failure, Success>> patch(
    String uri, {
    bool useToken = false,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return makeRequest(
        dio.patch(
          "/$uri",
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: await _getDioHeader(useToken)),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<Failure, Success>> post(
    String uri, {
    bool useToken = false,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return makeRequest(
        dio.post(
          "/$uri",
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: await _getDioHeader(useToken)),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
      );
    } catch (e) {
      //log.e(e);
      rethrow;
    }
  }

  Future<Either<Failure, Success>> put(
    String uri, {
    bool useToken = false,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return makeRequest(
        dio.put(
          "/$uri",
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: await _getDioHeader(useToken)),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
