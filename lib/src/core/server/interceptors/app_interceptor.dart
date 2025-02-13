// import "dart:developer";

// import "package:dio/dio.dart";
// import "package:flutter/foundation.dart";

// class AppInterceptor extends Interceptor {
//   AppInterceptor._();

//   static final AppInterceptor instance = AppInterceptor._();

//   @override
//   Future<void> onRequest(
//       RequestOptions options, RequestInterceptorHandler handler) async {
//     if (kDebugMode) {
//       log(
//         "---------[Interceptor]---------ON_REQUEST(${options.method})------------------\n\n"
//         "URL: ${options.uri}\n"
//         "Data: ${options.data}\n"
//         "Headers: ${options.headers}\n"
//         "---------------------------------------------------------------------------\n\n",
//       );
//     }
//     super.onRequest(options, handler);
//   }

//   @override
//   void onResponse(
//       Response<dynamic> response, ResponseInterceptorHandler handler) {
//     if (kDebugMode) {
//       log(
//         "---------[Interceptor]---------ON_RESPONSE(${response.statusCode})------------------\n\n"
//         "URL: ${response.realUri}\n"
//         "Data: ${response.data}\n"
//         "---------------------------------------------------------------------------\n\n",
//       );
//     }
//     super.onResponse(response, handler);
//   }

//   @override
//   Future<void> onError(
//       DioException err, ErrorInterceptorHandler handler) async {
//     if (kDebugMode) {
//       log(
//         "---------[Interceptor]---------ON_ERROR(${err.response?.statusCode})------------------\n\n"
//         "URL: ${err.response?.realUri.path}\n"
//         "TYPE: ${err.type}\n"
//         "Data: ${err.response?.data}\n"
//         "Message: ${err.message}\n"
//         "---------------------------------------------------------------------------\n\n",
//       );
//     }
//   }
// }
