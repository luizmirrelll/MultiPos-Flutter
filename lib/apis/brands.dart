import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_final/api_end_points.dart';
import 'package:pos_final/helpers/api_handler/api_error_handler.dart';
import 'package:pos_final/helpers/api_handler/api_helper.dart';
import 'package:pos_final/helpers/api_handler/api_response.dart';
import 'package:pos_final/models/system.dart';

import 'api.dart';

class BrandsServices extends Api {
  //get Notifications for the user
  Future<ApiResponse> getBrands() async {
    String token = await System().getToken();
    try {
      final Response<dynamic> response = await DioServiceHelper.getData(
          endPoint:ApiEndPoints.allBrands,headers: this.getHeader(token));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      log("ERROR ${e.toString()}");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
