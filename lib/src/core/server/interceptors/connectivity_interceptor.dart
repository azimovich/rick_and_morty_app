import "dart:async";
import "dart:io";
import "package:dio/dio.dart";
import "../api/api_connection.dart";

class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor({
    required this.requestReceiver,
  });
  final Connection requestReceiver;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      handler.resolve(
        await requestReceiver.scheduleRequestRetry(err.requestOptions),
      );
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) =>
      err.type == DioExceptionType.connectionError &&
      err.error != null &&
      err.error is SocketException &&
      err.error is TimeoutException;
}
