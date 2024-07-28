import 'package:flutter/material.dart';
import 'package:pos_final/helpers/AppTheme.dart';
import 'package:pos_final/pages/product_stock_report.dart';
import 'package:pos_final/pages/profit_loss_report.dart';

import '../locale/MyLocalizations.dart';

class ReportScreen extends StatelessWidget {
  static const String routeName = '/ReportScreen';
  ReportScreen({super.key});

  static int themeType = 1;
  ThemeData themeData = AppTheme.getThemeFromThemeMode(themeType);
  CustomAppTheme customAppTheme = AppTheme.getCustomAppTheme(themeType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate('reports'),
            style: AppTheme.getTextStyle(themeData.textTheme.titleLarge,
                fontWeight: 600)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                style: TextButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.7, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: themeData.primaryColor,
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                  shadowColor: Colors.red,
                  elevation: 1,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                      context, ProfitLossReportScreen.routeName);
                },
                child: Text(
                  AppLocalizations.of(context).translate('profit_and_loss'),
                  style: TextStyle(color: Colors.white),
                )),
            SizedBox(
              height: 20,
            ),
            TextButton(
                style: TextButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.7, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: themeData.primaryColor,
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                  shadowColor: Colors.red,
                  elevation: 1,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                      context, ProductStockReportScreen.routeName);
                },
                child: Text(
                  AppLocalizations.of(context).translate('products_stock'),
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
