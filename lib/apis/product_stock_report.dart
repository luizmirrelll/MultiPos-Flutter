import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/product_stock_report_model.dart';
import '../models/system.dart';
import 'api.dart';

class ProductStockReportService extends Api {
  Future<dynamic> getProductStockReport() async {
    try {
      String url = this.baseUrl + this.apiUrl + '/product-stock-report';
      var token = await System().getToken();
      var response =
          await http.get(Uri.parse(url), headers: this.getHeader('$token'));

      Map<String, dynamic> productStockReport = jsonDecode(response.body);
      List myListData = productStockReport['data'];
      List<ProductStockReportModel> myData =
          myListData.map((e) => ProductStockReportModel.fromJson(e)).toList();

      return myData;
    } catch (e) {
      log("ERROR ${e.toString()}");
      return null;
    }
  }
}
