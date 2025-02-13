// import "dart:developer";
import "dart:io";
import "dart:async";
import "dart:convert";
import "package:l/l.dart";
import "package:dio/io.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:connectivity_plus/connectivity_plus.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

import "api_constants.dart";
import "api_connection.dart";
import "../../storage/app_storage.dart";
import "../interceptors/connectivity_interceptor.dart";
import "../../../data/model/response/api_response.dart";

@immutable
class ApiService {
  const ApiService._();

  static Future<Dio> initDio() async {
    /// Dio
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConst.baseUrl,
        headers: await ApiService.getHeaders(),
        connectTimeout: ApiConst.connectionTimeout,
        receiveTimeout: ApiConst.sendTimeout,
        sendTimeout: ApiConst.sendTimeout,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.addAll(
      [
        ConnectivityInterceptor(
          requestReceiver: Connection(
            dio: dio,
            connectivity: Connectivity(),
          ),
        ),
        PrettyDioLogger()
      ],
    );

    // Deprecated bo'lgan onHttpClientCreate o'rniga createHttpClient'dan foydalanamiz
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    return dio;
  }

  static Future<Map<String, String>> getHeaders({bool isUpload = false}) async {
    final headers = <String, String>{
      "Content-type": isUpload ? "multipart/form-data" : "application/json; charset=UTF-8",
      // "Accept": isUpload ? "multipart/form-data" : "application/json; charset=UTF-8",
    };

    final token = await AppStorage.$read(key: StorageKey.accessToken) ?? "";

    if (token.isNotEmpty) {
      headers.putIfAbsent("Authorization", () => "Bearer $token");
    }

    return headers;
  }

  static Future<String?> get(String api, Map<String, dynamic> params) async {
    try {
      final response = await (await initDio()).get<dynamic>(api, queryParameters: params);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonEncode(response.data);
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      l.e("The connection has timed out, Please try again!");
      rethrow;
    } on DioException catch (e) {
      l.e(e.response.toString());
      rethrow;
    } on Object catch (e) {
      l.e(e.toString());
      rethrow;
    }
  }

  static Future<ApiResponse> post(String api, Map<String, dynamic> data, [Map<String, dynamic> params = const <String, dynamic>{}]) async {
    try {
      final response = await (await initDio()).post<dynamic>(api, data: jsonEncode(data), queryParameters: params);

      return ApiResponse(statusCode: response.statusCode ?? 500, data: response.data);
    } on DioException catch (e) {
      return ApiResponse(statusCode: e.response?.statusCode ?? 500, data: e.response?.data ?? {"message": e.message});
    } catch (e) {
      return ApiResponse(statusCode: 500, data: {"message": e.toString()});
    }
  }

  static Future<ApiResponse> multipart(String api, Map<String, dynamic> body, List<String> filePaths) async {
    try {
      final formData = FormData();

      // Add files to form data
      if (filePaths.isNotEmpty) {
        for (var i = 0; i < filePaths.length; i++) {
          formData.files.add(MapEntry("images[$i][images]", await MultipartFile.fromFile(filePaths[i])));
        }
      }

      // Add all other fields from body to form data
      body.forEach((key, value) {
        if (value != null) {
          // Handle nested objects like coordinates and investments
          if (value is List &&
              (key == 'coordinates' || key == 'investments' || key == 'trellises' || key == "reservoirs" || key == "subsidies")) {
            for (var i = 0; i < value.length; i++) {
              value[i].forEach((nestedKey, nestedValue) {
                formData.fields.add(
                  MapEntry('$key[$i][$nestedKey]', nestedValue.toString()),
                );
              });
            }
          } else {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        }
      });

      final response = await (await initDio()).post<dynamic>(
        api,
        data: formData,
        options: Options(
          // headers: {
          //   'Content-Type': 'multipart/form-data',
          // },

          headers: await ApiService.getHeaders(isUpload: true),
        ),
      );

      return ApiResponse(statusCode: response.statusCode ?? 500, data: response.data);

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return jsonEncode(response.data);
      // } else {
      //   log("Respone statuscode : ${response.statusCode}");
      //   return null;
      // }
    } on TimeoutException catch (_) {
      l.e("The connection has timed out, Please try again!");
      rethrow;
    } on DioException catch (e) {
      l.e(e.response.toString());
      rethrow;
    } on Object catch (e) {
      l.e(e.toString());
      rethrow;
    }
  }

  static Future<String?> uploadImages(String api, List<String> filePaths) async {
    try {
      List<MultipartFile> files = [];

      for (var filePath in filePaths) {
        files.add(await MultipartFile.fromFile(filePath));
      }

      final formData = FormData.fromMap({
        'images': files,
      });

      final response = await (await initDio()).patch<dynamic>(
        api,
        data: formData,
        options: Options(
          headers: await ApiService.getHeaders(isUpload: true),
        ),
      );

      return jsonEncode(response.data);
    } on TimeoutException catch (_) {
      l.e("The connection has timed out, Please try again!");
      rethrow;
    } on DioException catch (e) {
      l.e(e.response.toString());
      rethrow;
    } on Object catch (e) {
      l.e(e.toString());
      rethrow;
    }
  }

  static Future<String?> put(String api, Map<String, dynamic> data) async {
    try {
      final response = await (await initDio()).put<dynamic>(api, data: data);

      return jsonEncode(response.data);
    } on TimeoutException catch (_) {
      l.e("The connection has timed out, Please try again!");
      rethrow;
    } on DioException catch (e) {
      l.e(e.response.toString());
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }

  static Future<Response?> patch(String api, Map<String, dynamic> data) async {
    try {
      final response = await (await initDio()).patch<dynamic>(api, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }
      return null;
    } on TimeoutException catch (_) {
      l.e("The connection has timed out, Please try again!");
      rethrow;
    } on DioException catch (e) {
      l.e(e.response.toString());
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }

  /// [Delete Method]
  // static Future<String?> delete(String api, Map<String, dynamic> params) async {
  //   try {
  //     final _ = await (await initDio()).delete<dynamic>(api, queryParameters: params);
  //     return "success";
  //   } on TimeoutException catch (_) {
  //     l.e("The connection has timed out, Please try again!");
  //     rethrow;
  //   } on DioException catch (e) {
  //     l.e(e.response.toString());
  //     rethrow;
  //   } on Object catch (_) {
  //     rethrow;
  //   }
  // }
}

// extension ListFileToFormData on List<File> {
//   Future<FormData> mappedFormData({required bool isPickedFile}) async => FormData.fromMap(
//         <String, MultipartFile>{
//           for (var v in this) ...{
//             DateTime.now().toString(): MultipartFile.fromBytes(
//               isPickedFile ? v.readAsBytesSync() : (await rootBundle.load(v.path)).buffer.asUint8List(),
//               filename: v.path.substring(v.path.lastIndexOf("/")),
//             ),
//           },
//         },
//       );
// }
