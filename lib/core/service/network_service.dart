// import '../app/app.locator.dart';
// import '../app/app.logger.dart';
// import '../exceptions/network_exceptions.dart';
// import '../pipeline/api_result.dart';
// import 'dio_service.dart';

// // abstract class NetworkService {
// //   Future<ApiResult<T>> post<T>({
// //     String? uri,
// //     Map<String, dynamic>? data,
// //     Map<String, dynamic>? queryParams,
// //     required Function converter,
// //   });
// //   Future<ApiResult<T>> get<T>({
// //     String? uri,
// //     Map<String, dynamic>? queryParams,
// //     required Function converter,
// //   });
// //   Future<ApiResult<T>> patch<T>({
// //     String? uri,
// //     Map<String, dynamic>? data,
// //     Map<String, dynamic>? queryParams,
// //     required Function converter,
// //   });
// //   Future<ApiResult<T>> put<T>({
// //     String? uri,
// //     Map<String, dynamic>? data,
// //     Map<String, dynamic>? queryParams,
// //     required Function converter,
// //   });
// //   Future<ApiResult<T>> delete<T>({
// //     String? uri,
// //     Map<String, dynamic>? data,
// //     Map<String, dynamic>? queryParams,
// //     required Function converter,
// //   });
// // }

// abstract class NetworkService {
//   final _dioService = locator<DioServiceImpl>();
//   final log = getLogger('NetworkService -');

//   Future<ApiResult<T>> get<T>({
//     String? uri,
//     Map<String, dynamic>? queryParams,
//     Function? converter,
//   }) async {
//     try {
//       final response = await _dioService.appGet(
//         uri!,
//         queryParameters: queryParams,
//       );
//       log.i(response);
//       return ApiResult.success(
//         data: converter == null ? response : converter(response),
//       );
//     } catch (e) {
//       log.e(e);
//       return ApiResult.failure(
//         error: NetworkExceptions.getDioExceptions(e),
//       );
//     }
//   }

//   Future<ApiResult<T>> delete<T>({
//     String? uri,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParams,
//     Function? converter,
//   }) async {
//     try {
//       final response = await _dioService.appDelete(
//         uri!,
//         queryParameters: queryParams,
//       );
//       log.i(response);
//       return ApiResult.success(
//         data: converter == null ? response : converter(response),
//       );
//     } catch (e) {
//       log.e(e);
//       return ApiResult.failure(
//         error: NetworkExceptions.getDioExceptions(e),
//       );
//     }
//   }

//   Future<ApiResult<T>> patch<T>({
//     String? uri,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParams,
//     Function? converter,
//   }) async {
//     try {
//       final response = await _dioService.appPatch(
//         uri!,
//         queryParameters: queryParams,
//       );
//       log.i(response);
//       return ApiResult.success(
//         data: converter == null ? response : converter(response),
//       );
//     } catch (e) {
//       log.e(e);
//       return ApiResult.failure(
//         error: NetworkExceptions.getDioExceptions(e),
//       );
//     }
//   }

//   Future<ApiResult<T>> post<T>({
//     String? uri,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParams,
//     Function? converter,
//   }) async {
//     try {
//       final response = await _dioService.appPost(
//         uri!,
//         data: data,
//         queryParameters: queryParams,
//       );
//       log.i(response);
//       return ApiResult.success(
//         data: converter == null ? response : converter(response),
//       );
//     } catch (e) {
//       print(e);
      
//       log.e(e.toString());
//       return ApiResult.failure(
        
//         error: NetworkExceptions.getDioExceptions(e),
//       );
//     }
//   }

//   Future<ApiResult<T>> put<T>({
//     String? uri,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? queryParams,
//     Function? converter,
//   }) async {
//     try {
//       final response = await _dioService.appPut(
//         uri!,
//         queryParameters: queryParams,
//       );
//       log.i(response);
//       return ApiResult.success(
//         data: converter == null ? response : converter(response),
//       );
//     } catch (e) {
//       log.e(e);
//       return ApiResult.failure(
//         error: NetworkExceptions.getDioExceptions(e),
//       );
//     }
//   }
// }
