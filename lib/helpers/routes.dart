import 'package:pos_final/helpers/bottomNav.dart';
import 'package:pos_final/pages/brands/brands.dart';
import 'package:pos_final/pages/category_screen.dart';
import 'package:pos_final/pages/home/home_screen.dart';
import 'package:pos_final/pages/login/login_screen.dart';
import 'package:pos_final/pages/notifications/notify.dart';
import 'package:pos_final/pages/on_boarding/on_boarding.dart';
import 'package:pos_final/pages/product_stock_report.dart';
import 'package:pos_final/pages/profit_loss_report.dart';
import 'package:pos_final/pages/purchases/view/purchases_screen.dart';
import 'package:pos_final/pages/units.dart';

import '../pages/cart.dart';
import '../pages/checkout.dart';
import '../pages/contact_payment.dart';
import '../pages/contacts.dart';
import '../pages/customer.dart';
import '../pages/expenses.dart';
import '../pages/field_force.dart';
import '../pages/follow_up.dart';
import '../pages/home.dart';
import '../pages/login.dart';
import '../pages/products.dart';
import '../pages/report.dart';
import '../pages/sales.dart';
import '../pages/shipment.dart';
import '../pages/splash.dart';

class Routes {
  static generateRoute() {
    return {
      '/splash': (context) => Splash(),
      '/onBoarding': (context) => OnBoardingScreen(),
     // '/login': (context) => Login(),
      '/login': (context) => LoginScreen(),
      //'/home': (context) => Home(),
      '/home': (context) => HomeScreen(),
      '/products': (context) => Products(),
      '/layout': (context) => Layout(),
      '/Categories':(context)=>CategoryScreen(),
      '/BrandsScreen':(context)=>BrandsScreen(),
      '/notify': (context) => NotificationScreen(),
      '/sale': (context) => Sales(),
      '/cart': (context) => Cart(),
      '/customer': (context) => Customer(),
      '/checkout': (context) => CheckOut(),
      '/expense': (context) => Expense(),
      '/contactPayment': (context) => ContactPayment(),
      '/shipment': (context) => Shipment(),
      '/leads': (context) => Contacts(),
      '/followUp': (context) => FollowUp(),
      '/fieldForce': (context) => FieldForce(),
      '/purchases':(context) => PurchasesScreen(),
      ReportScreen.routeName: (context) => ReportScreen(),
      ProfitLossReportScreen.routeName: (context) => ProfitLossReportScreen(),
      ProductStockReportScreen.routeName: (context) =>
          ProductStockReportScreen(),
      UnitsScreen.routeName: (context) => UnitsScreen(),
    };
  }
}
