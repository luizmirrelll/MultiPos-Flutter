import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';

import '../apis/profit_loss_report.dart';
import '../helpers/AppTheme.dart';
import '../locale/MyLocalizations.dart';
import '../models/profit_loss_report_model.dart';

class UnitsScreen extends StatefulWidget {
  static const String routeName = '/UnitsScreen';
  UnitsScreen({
    Key? key,
  }) : super(key: key);

  static int themeType = 1;

  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  TextStyle textStyle(
    BuildContext context,
  ) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width / 25,
      fontWeight: FontWeight.bold,
    );
  }

  ThemeData themeData = AppTheme.getThemeFromThemeMode(UnitsScreen.themeType);

  CustomAppTheme customAppTheme =
      AppTheme.getCustomAppTheme(UnitsScreen.themeType);

  List<Color> myColors = [
    Colors.white,
    Colors.blue[100] as Color,
    Colors.red[100] as Color,
    Colors.yellow[100] as Color,
    Colors.green[100] as Color,
    Colors.grey[100] as Color,
    Colors.purple[100] as Color,
  ];
  ProfitLossReportModel? profitLossReportModel;
  late bool loading;
  Map<String, dynamic>? mapData;
  List myReports = [];

  Future<void> _getProfitLossReport() async {
    dev.log("Start");

    loading = true;

    var result = await ProfitLossReportService().getProfitLossReport();
    if (result == null) {
      setState(() {
        loading = true;
      });
    } else {
      setState(() {
        profitLossReportModel = result;
        mapData = profitLossReportModel!.toJson();
        mapData!.forEach((key, value) {
          myReports.add({"title": key, "data": value});
        });
        dev.log("myReports ${myReports[0]}");
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _getProfitLossReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate('reports'),
            style: AppTheme.getTextStyle(themeData.textTheme.titleLarge,
                fontWeight: 600)),
      ),
      body: SizedBox(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    //  defaultColumnWidth: const FixedColumnWidth(120.0),
                    border: TableBorder.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1),
                    children: List.generate(
                        myReports.length,
                        (index) => myCellWidget(
                            title: AppLocalizations.of(context)
                                .translate(myReports[index]['title']),
                            data: myReports[index]['data'].toString(),
                            context: context))),
              ),
      ),
    );
  }

  TableRow myCellWidget({String? title, String? data, BuildContext? context}) {
    return TableRow(
        decoration: BoxDecoration(
          color: myColors[Random().nextInt(6)],
          border: Border.all(
            width: 1,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: textStyle(context!),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              data!,
              textAlign: TextAlign.center,
              style: textStyle(context),
            ),
          ),
        ]);
  }
}
