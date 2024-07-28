import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/profit_loss_report_model.dart';
import '../models/system.dart';
import 'api.dart';

class ProfitLossReportService extends Api {
  Future<dynamic> getProfitLossReport() async {
    try {
      String url =this.baseUrl + this.apiUrl + '/profit-loss-report';
      var token = await System().getToken();

      var response =
          await http.get(Uri.parse(url), headers: this.getHeader('$token'));

      var profitLossReport = jsonDecode(response.body);

      log(profitLossReport.runtimeType.toString());
      ProfitLossReportModel myData =
          ProfitLossReportModel.fromJson(profitLossReport['data']);

      return myData;
    } catch (e) {
      log("ERROR ${e.toString()}");
      return null;
    }
  }
}
