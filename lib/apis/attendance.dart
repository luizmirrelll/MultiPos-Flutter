import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:pos_final/api_end_points.dart';
import 'package:pos_final/helpers/api_handler/api_helper.dart';

import '../apis/api.dart';
import '../models/system.dart';

class AttendanceApi extends Api {
  //check-In/Out through api
  Future<Map<String, dynamic>?> checkIO(data, bool check) async {
    try {
      String url = (check) ? ApiEndPoints.checkIn : ApiEndPoints.checkOut;
      var token = await System().getToken();
      var response = await http.post(Uri.parse(url),
          headers: this.getHeader('$token'), body: jsonEncode(data));
      var info = jsonDecode(response.body);
      return info;
    } catch (e) {
      return null;
    }
  }

  //get user attendance
  getAttendanceDetails(int userId) async {
    try {
      String url = '${ApiEndPoints.getAttendance}$userId';
      var token = await System().getToken();
      var response =
          await http.get(Uri.parse(url), headers: this.getHeader('$token'));
      var info = jsonDecode(response.body);
      var result = info['data'];
      return result;
    } catch (e) {
      return null;
    }
  }
}
