import 'package:dio/dio.dart';
import 'package:pos_final/api_end_points.dart';

abstract final class DioServiceHelper {
  static Future<Response<dynamic>> getData({
    required String endPoint,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? headers,
  }) async {
    Dio dio = Dio(BaseOptions(
      baseUrl: ApiEndPoints.baseUrl,
      headers: headers,
      receiveDataWhenStatusError: true,
    ));
    var result = await dio.get(endPoint, queryParameters: query);
    return result;
  }
}
