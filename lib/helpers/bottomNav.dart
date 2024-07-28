import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_final/pages/category_screen.dart';
import 'package:pos_final/pages/home.dart';
import 'package:pos_final/pages/home/home_screen.dart';
import 'package:pos_final/pages/products.dart';
import 'package:pos_final/pages/sales.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../locale/MyLocalizations.dart';
import '../models/attendance.dart';
import '../models/paymentDatabase.dart';
import '../models/sellDatabase.dart';
import '../models/system.dart';
import '../pages/login.dart';
import 'AppTheme.dart';
import 'SizeConfig.dart';
import 'icons.dart';
import 'otherHelpers.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  var user,
      note = new TextEditingController(),
      clockInTime = DateTime.now(),
      selectedLanguage;
  LatLng? currentLoc;

  String businessSymbol = '',
      businessLogo = '',
      defaultImage = 'assets/images/default_product.png',
      businessName = '',
      userName = '';

  double totalSalesAmount = 0.00,
      totalReceivedAmount = 0.00,
      totalDueAmount = 0.00,
      byCash = 0.00,
      byCard = 0.00,
      byCheque = 0.00,
      byBankTransfer = 0.00,
      byOther = 0.00,
      byCustomPayment_1 = 0.00,
      byCustomPayment_2 = 0.00,
      byCustomPayment_3 = 0.00;

  bool accessExpenses = false,
      attendancePermission = false,
      notPermitted = false,
      syncPressed = false;
  bool? checkedIn;

  // List sells;
  Map<String, dynamic>? paymentMethods;
  int? totalSales;
  List<Map> method = [], payments = [];

  static int themeType = 1;
  ThemeData themeData = AppTheme.getThemeFromThemeMode(themeType);
  CustomAppTheme customAppTheme = AppTheme.getCustomAppTheme(themeType);

  int _selectedIndex = 0;
  List<Widget> pages_index = <Widget>[Home(),CategoryScreen(),Products(), Sales()];
  @override
  void initState() {
    super.initState();
    getPermission();
    homepageData();
    Helper().syncCallLogs();
  }

  checkIOButtonDisplay() async {
    await Attendance().getCheckInTime(Config.userId).then((value) {
      if (value != null) {
        clockInTime = DateTime.parse(value);
      }
    });
    //if someone has forget to check-in
    //check attendance status
    var activeSubscriptionDetails = await System().get('active-subscription');
    if (activeSubscriptionDetails.length > 0 &&
        activeSubscriptionDetails[0].containsKey('package_details')) {
      Map<String, dynamic> packageDetails =
          activeSubscriptionDetails[0]['package_details'];
      if (packageDetails.containsKey('essentials_module') &&
          packageDetails['essentials_module'].toString() == '1') {
        //get attendance status(check-In/check-Out)
        checkedIn = await Attendance().getAttendanceStatus(Config.userId);
        setState(() {});
      } else {
        setState(() {
          checkedIn = null;
        });
      }
    } else {
      setState(() {
        checkedIn = null;
      });
    }
  }

  homepageData() async {
    var prefs = await SharedPreferences.getInstance();
    user = await System().get('loggedInUser');
    userName = ((user['surname'] != null) ? user['surname'] : "") +
        ' ' +
        user['first_name'];
    await loadPaymentDetails();
    await Helper().getFormattedBusinessDetails().then((value) {
      businessSymbol = value['symbol'];
      businessLogo = value['logo'] ?? Config().defaultBusinessImage;
      businessName = value['name'];
      Config.quantityPrecision = value['quantityPrecision'] ?? 2;
      Config.currencyPrecision = value['currencyPrecision'] ?? 2;
    });
    selectedLanguage =
        prefs.getString('language_code') ?? Config().defaultLanguage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages_index.elementAt(_selectedIndex),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: _changePage,
        items: [
          FlashyTabBarItem(
            icon: Icon(IconBroken.Home),
            title: Text(AppLocalizations.of(context).translate('home')),
          ),
          FlashyTabBarItem(
            icon: Icon(IconBroken.Category),
            title: Text(AppLocalizations.of(context).translate('Categories')),
          ),
          FlashyTabBarItem(
            icon: Icon(IconBroken.Buy),
            title: Text(AppLocalizations.of(context).translate('products')),
          ),
          FlashyTabBarItem(
            icon: Icon(IconBroken.Chart),
            title: Text(AppLocalizations.of(context).translate('sales')),
          ),
        ],
      ),
    );
  }

  void _changePage(int value) {
    print(value);
    setState(() {
      _selectedIndex = value;
    });
  }

  Widget paymentDetails() {
    return Container(
      padding: EdgeInsets.all(MySize.size8!),
      margin: EdgeInsets.all(MySize.size16!),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
        color: customAppTheme.bgLayer1,
        border: Border.all(color: customAppTheme.bgLayer4, width: 1.2),
      ),
      child: Column(
        children: <Widget>[
          Text(AppLocalizations.of(context).translate('payment_details'),
              style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                  fontWeight: 700, letterSpacing: -0.2)),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(10),
              itemCount: method.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 30,
                                width: 2,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2)),
                              Text(method[index]['key']),
                            ],
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('$businessSymbol ' +
                                Helper().formatCurrency(method[index]['value']))
                          ])
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }

//get permission
  getPermission() async {
    List<PermissionStatus> status = [
      await Permission.location.status,
      await Permission.storage.status,
      await Permission.camera.status,
      // await Permission.phone.status,
    ];
    notPermitted = status.contains(PermissionStatus.denied);
    await Helper()
        .getPermission('essentials.allow_users_for_attendance_from_api')
        .then((value) {
      if (value == true) {
        checkIOButtonDisplay();
        setState(() {
          attendancePermission = true;
        });
      } else {
        setState(() {
          checkedIn = null;
        });
      }
    });

    if (await Helper().getPermission('all_expense.access') ||
        await Helper().getPermission('view_own_expense')) {
      setState(() {
        accessExpenses = true;
      });
    }
  }

//checkIn and checkOut button
  Widget checkIO() {
    if (checkedIn != null) {
      return Padding(
        padding: EdgeInsets.only(top: MySize.size10!),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: (!checkedIn!)
                    ? themeData.colorScheme.primary
                    : themeData.colorScheme.background,
              ),
              onPressed: () async {
                Helper().syncCallLogs();
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                            (!checkedIn!)
                                ? AppLocalizations.of(context)
                                    .translate('check_in_note')
                                : AppLocalizations.of(context)
                                    .translate('check_out_note'),
                            textAlign: TextAlign.center,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.headline6,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 600,
                                muted: true)),
                        content: TextFormField(
                            controller: note,
                            autofocus: true,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 600,
                                muted: true)),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: themeData.colorScheme.primary,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              if (await Helper().checkConnectivity()) {
                                try {
                                  await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high)
                                      .then((Position position) {
                                    // currentLoc = LatLng(position.latitude,
                                    //     position.longitude);
                                  });
                                } catch (e) {}
                                if (checkedIn == false) {
                                  //get ip address
                                  var ipAddress =
                                      IpAddress(type: RequestType.json);

                                  /// Get the IpAddress based on requestType.
                                  dynamic data = await ipAddress.getIpAddress();
                                  String iP = data.toString();

                                  //get current location
                                  try {
                                    await Geolocator.getCurrentPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high)
                                        .then((Position position) {
                                      currentLoc = LatLng(position.latitude,
                                          position.longitude);
                                    });
                                  } catch (e) {}

                                  var checkInMap = await Attendance().doCheckIn(
                                      checkInNote: note.text,
                                      iPAddress: iP,
                                      latitude: (currentLoc != null)
                                          ? currentLoc!.latitude
                                          : '',
                                      longitude: (currentLoc != null)
                                          ? currentLoc!.longitude
                                          : '');
                                  Fluttertoast.showToast(msg: checkInMap);
                                  note.clear();
                                } else {
                                  //get current location
                                  try {
                                    await Geolocator.getCurrentPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high)
                                        .then((Position position) {
                                      currentLoc = LatLng(position.latitude,
                                          position.longitude);
                                    });
                                  } catch (e) {}

                                  var checkOutMap = await Attendance()
                                      .doCheckOut(
                                          latitude: (currentLoc != null)
                                              ? currentLoc!.latitude
                                              : '',
                                          longitude: (currentLoc != null)
                                              ? currentLoc!.longitude
                                              : '',
                                          checkOutNote: note.text);
                                  Fluttertoast.showToast(msg: checkOutMap);
                                  note.clear();
                                }
                                checkedIn = await Attendance()
                                    .getAttendanceStatus(Config.userId);
                                await Attendance()
                                    .getCheckInTime(Config.userId)
                                    .then((value) {
                                  if (value != null) {
                                    clockInTime = DateTime.parse(value);
                                  }
                                });
                                setState(() {});
                              } else
                                Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)
                                        .translate('check_connectivity'));
                            },
                            child: Text(
                                AppLocalizations.of(context).translate('ok')),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)
                                .translate('cancel')),
                          )
                        ],
                      );
                    });
              },
              child: (!checkedIn!)
                  ? Text(AppLocalizations.of(context).translate('check_in'),
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.headline6,
                          color: themeData.colorScheme.background,
                          fontWeight: 600))
                  : Text(AppLocalizations.of(context).translate('check_out'),
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.headline6,
                          color: themeData.colorScheme.primary,
                          fontWeight: 600)),
            ),
            Text(
                (!checkedIn!)
                    ? ''
                    : DateTime.now().difference(clockInTime).toString(),
                style: AppTheme.getTextStyle(
                  themeData.textTheme.subtitle2,
                  color: themeData.colorScheme.onBackground,
                )),
          ],
        ),
      );
    } else
      return Container();
  }

//load statistics
  Future<List> loadStatistics() async {
    List result = await SellDatabase().getSells();
    totalSales = result.length;
    setState(() {
      result.forEach((sell) async {
        List payment =
            await PaymentDatabase().get(sell['id'], allColumns: true);
        var paidAmount = 0.0;
        var returnAmount = 0.0;
        payment.forEach((element) {
          if (element['is_return'] == 0) {
            paidAmount += element['amount'];
            payments
                .add({'key': element['method'], 'value': element['amount']});
          } else {
            returnAmount += element['amount'];
          }
        });
        totalSalesAmount = (totalSalesAmount + sell['invoice_amount']);
        totalReceivedAmount =
            (totalReceivedAmount + (paidAmount - returnAmount));
        totalDueAmount = (totalDueAmount + sell['pending_amount']);
      });
    });
    return result;
  }

//load payment details
  loadPaymentDetails() async {
    var paymentMethod = [];
    //fetch different payment methods
    await System().get('payment_methods').then((value) {
      //Add all PaymentMethods into a List according to key value pair
      value.forEach((element) {
        element.forEach((k, v) {
          paymentMethod.add({'key': '$k', 'value': '$v'});
        });
      });
    });

    await loadStatistics().then((value) {
      Future.delayed(Duration(seconds: 1), () {
        payments.forEach((row) {
          if (row['key'] == 'cash') {
            byCash += row['value'];
          }

          if (row['key'] == 'card') {
            byCard += row['value'];
          }

          if (row['key'] == 'cheque') {
            byCheque += row['value'];
          }

          if (row['key'] == 'bank_transfer') {
            byBankTransfer += row['value'];
          }

          if (row['key'] == 'other') {
            byOther += row['value'];
          }

          if (row['key'] == 'custom_pay_1') {
            byCustomPayment_1 += row['value'];
          }

          if (row['key'] == 'custom_pay_2') {
            byCustomPayment_2 += row['value'];
          }
          if (row['key'] == 'custom_pay_3') {
            byCustomPayment_3 += row['value'];
          }
        });
        paymentMethod.forEach((row) {
          if (byCash > 0 && row['key'] == 'cash')
            method.add({'key': row['value'], 'value': byCash});
          if (byCard > 0 && row['key'] == 'card')
            method.add({'key': row['value'], 'value': byCard});
          if (byCheque > 0 && row['key'] == 'cheque')
            method.add({'key': row['value'], 'value': byCheque});
          if (byBankTransfer > 0 && row['key'] == 'bank_transfer')
            method.add({'key': row['value'], 'value': byBankTransfer});
          if (byOther > 0 && row['key'] == 'other')
            method.add({'key': row['value'], 'value': byOther});
          if (byCustomPayment_1 > 0 && row['key'] == 'custom_pay_1')
            method.add({'key': row['value'], 'value': byCustomPayment_1});
          if (byCustomPayment_2 > 0 && row['key'] == 'custom_pay_2')
            method.add({'key': row['value'], 'value': byCustomPayment_2});
          if (byCustomPayment_3 > 0 && row['key'] == 'custom_pay_3')
            method.add({'key': row['value'], 'value': byCustomPayment_3});
        });
        if (this.mounted) {
          setState(() {});
        }
      });
    });
  }
}
