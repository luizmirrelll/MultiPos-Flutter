import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/system.dart';
import 'api.dart';

class UnitService extends Api {
  Future<dynamic> getUnits() async {
    try {
      String url = this.baseUrl + this.apiUrl + '/unit';
      var token = await System().getToken();

      var response =
          await http.get(Uri.parse(url), headers: this.getHeader('$token'));
      log(" getUnits getUnits \n  === \n    " + response.body);
      var units = jsonDecode(response.body);

      log(units.runtimeType.toString());

      /* ProfitLossReportModel mydata =
          ProfitLossReportModel.fromJson(productStockReport['data']);*/

      //  log("mydata${mydata.totalSellDiscount}");

      return "mydata";
    } catch (e) {
      log("ERROR ${e.toString()}");
      return null;
    }
  }
}
