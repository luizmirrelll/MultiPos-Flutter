import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:pos_final/api_end_points.dart';
import 'package:pos_final/helpers/api_handler/api_error_handler.dart';
import 'package:pos_final/helpers/api_handler/api_helper.dart';
import 'package:pos_final/helpers/api_handler/api_response.dart';
import '../models/system.dart';
import 'api.dart';

class NotificationService extends Api {
  //get Notifications for the user
  Future<ApiResponse> getNotifications() async {
    String token = await System().getToken();
    try {
      final Response<dynamic> response = await DioServiceHelper.getData(
          endPoint:ApiEndPoints.allNotifications,headers: this.getHeader(token));
          /* final Response<dynamic> responsev = await DioServiceHelper.getData(
          endPoint:'/show-notification/c3e85c21-9f28-420e-91c1-b158cefabad9',headers: this.getHeader(token));*/
      return ApiResponse.withSuccess(response);
    } catch (e) {
      log("ERROR ${e.toString()}");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
