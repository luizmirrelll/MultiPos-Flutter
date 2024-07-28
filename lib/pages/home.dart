import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_final/pages/home/widgets/greeting_widget.dart';
import 'package:pos_final/pages/home/widgets/statistics_widget.dart';
import 'package:pos_final/pages/notifications/view_model_manger/notifications_cubit.dart';
import 'package:pos_final/pages/report.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../helpers/AppTheme.dart';
import '../helpers/SizeConfig.dart';
import '../helpers/icons.dart';
import '../helpers/otherHelpers.dart';
import '../locale/MyLocalizations.dart';
import '../models/attendance.dart';
import '../models/paymentDatabase.dart';
import '../models/sell.dart';
import '../models/sellDatabase.dart';
import '../models/system.dart';
import '../models/variations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  @override
  void initState() {
    super.initState();
    getPermission();
    homepageData();
    Helper().syncCallLogs();
  }

  //function to set homepage details
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

  //permission for displaying Attendance Button
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: homePageDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('home'),
            style: AppTheme.getTextStyle(themeData.textTheme.titleLarge,
                fontWeight: 600)),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                (await Helper().checkConnectivity())
                    ? await sync()
                    : Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)
                            .translate('check_connectivity'));
              },
              icon: Icon(
                MdiIcons.syncIcon,
                color: Colors.orange,
              )),
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await SellDatabase().getNotSyncedSells().then((value) {
                  if (value.isEmpty) {
                    //saving userId in disk
                    prefs.setInt('prevUserId', Config.userId!);
                    prefs.remove('userId');
                    Navigator.pushReplacementNamed(context, '/login');
                  } else {
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)
                            .translate('sync_all_sales_before_logout'));
                  }
                });
              },
              icon: Icon(IconBroken.Logout)),
        ],
        leading: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Icon(Icons.list),
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                )),
            SizedBox(
              width: 10,
            ),
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return Badge.count(
                    smallSize: 10,
                    largeSize: 15,
                    alignment: AlignmentDirectional.topEnd,
                    count: NotificationsCubit.get(context).notificationsCount,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notify');
                        },
                        child: Icon(
                          IconBroken.Notification,
                          color: Color(0xff4c53a5),
                        )));
              },
            )
          ],
        ),
        leadingWidth: 75,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GreetingWidget(themeData: themeData,userName: userName),
            Statistics(
              themeData: themeData,
              businessSymbol: businessSymbol,
              totalDueAmount: totalDueAmount,
              totalReceivedAmount: totalReceivedAmount,
              totalSales: totalSales,
              totalSalesAmount: totalSalesAmount,
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              //TODO Make this if client choose to i hope he dose not
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color(0xffedecf2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Close'))
                                    ],
                                    title: Text(
                                      AppLocalizations.of(context)
                                          .translate('language'),
                                    ),
                                    content: changeAppLanguage(),
                                  ));
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('language'),
                                style: TextStyle(color: Color(0xff4c53a5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color(0xffedecf2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () async {
                          if (await Helper().checkConnectivity()) {
                            Navigator.pushNamed(context, '/expense');
                          } else {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)
                                    .translate('check_connectivity'));
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('expenses'),
                                style: TextStyle(color: Color(0xff4c53a5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color(0xffedecf2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () async {
                          if (await Helper().checkConnectivity()) {
                            Navigator.pushNamed(context, '/contactPayment');
                          } else {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)
                                    .translate('check_connectivity'));
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('contact_payment'),
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xff4c53a5)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color(0xffedecf2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () async {
                          if (await Helper().checkConnectivity()) {
                            Navigator.pushNamed(context, '/leads');
                            // await CallLog.get().then(
                            //         (value) =>
                            //         Navigator.pushNamed(context, '/leads'));
                          } else {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)
                                    .translate('check_connectivity'));
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('follow_ups'),
                                  style: TextStyle(
                                      color: Color(0xff4c53a5), fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color(0xffedecf2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () async {
                          if (await Helper().checkConnectivity()) {
                            Navigator.pushNamed(context, '/leads');
                            // await CallLog.get().then(
                            //         (value) =>
                            //         Navigator.push(context, '/leads'));
                          } else {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)
                                    .translate('check_connectivity'));
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('suppliersC'),
                                style: TextStyle(
                                    color: Color(0xff4c53a5), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color(0xffedecf2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/shipment');
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('shipment'),
                                style: TextStyle(color: Color(0xff4c53a5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color(0xffedecf2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/sale');
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('payments'),
                                style: TextStyle(
                                    color: Color(0xff4c53a5), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color(0xffedecf2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ReportScreen.routeName);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('reports'),
                                style: TextStyle(color: Color(0xff4c53a5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color(0xffedecf2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('settings'),
                                style: TextStyle(color: Color(0xff4c53a5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ), //T
            paymentDetails(),
          ],
        ),
      ),
    );
  }

//homepage drawer
  Widget homePageDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: MySize.scaleFactorHeight! * 70,
            ),
            Expanded(
              flex: 9,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: themeData.colorScheme.onBackground,
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'))
                                ],
                                title: Text(
                                  AppLocalizations.of(context)
                                      .translate('language'),
                                ),
                                content: changeAppLanguage(),
                              ));
                    },
                    title: Text(
                        AppLocalizations.of(context).translate('language')),
                  ),
                  Visibility(
                    visible: accessExpenses,
                    child: ListTile(
                      leading: Image.asset(
                        'assets/images/money.png',
                        color: Color(0xff42855B),
                        width: 30,
                      ),
                      onTap: () async {
                        if (await Helper().checkConnectivity()) {
                          Navigator.pushNamed(context, '/expense');
                        } else {
                          Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)
                                  .translate('check_connectivity'));
                        }
                      },
                      title: Text(
                        AppLocalizations.of(context).translate('expenses'),
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.titleSmall,
                            fontWeight: 600),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/payed_money.png',
                      color: Color(0xff820000),
                      width: 30,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate('contact_payment'),
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.titleSmall,
                          fontWeight: 600),
                    ),
                    onTap: () async {
                      if (await Helper().checkConnectivity()) {
                        Navigator.pushNamed(context, '/contactPayment');
                      } else {
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)
                                .translate('check_connectivity'));
                      }
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/support.png',
                      color: Color(0xff301E67),
                      width: 30,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate('follow_ups'),
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.titleSmall,
                          fontWeight: 600),
                    ),
                    onTap: () async {
                      if (await Helper().checkConnectivity()) {
                        Navigator.pushNamed(context, '/followUp');
                        // await CallLog.get().then((value) =>
                        //     Navigator.push(context, '/followUp'));
                      } else {
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)
                                .translate('check_connectivity'));
                      }
                    },
                  ),
                  Visibility(
                    visible: Config().showFieldForce,
                    child: ListTile(
                      leading: Icon(
                        MdiIcons.humanMale,
                        color: themeData.colorScheme.onBackground,
                      ),
                      onTap: () async {
                        if (await Helper().checkConnectivity()) {
                          Navigator.pushNamed(context, '/fieldForce');
                        } else {
                          Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)
                                  .translate('check_connectivity'));
                        }
                      },
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('field_force_visits'),
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.titleSmall,
                            fontWeight: 600),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/contact.png',
                      color: Color(0xff0064e5),
                      width: 30,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate('contacts'),
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.titleSmall,
                          fontWeight: 600),
                    ),
                    onTap: () async {
                      if (await Helper().checkConnectivity()) {
                        Navigator.pushNamed(context, '/leads');
                        // await CallLog.get().then(
                        //         (value) =>
                        //         Navigator.push(context, '/leads'));
                      } else {
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)
                                .translate('check_connectivity'));
                      }
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/delivery.png',
                      color: Color(0xffF2921D),
                      width: 30,
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate('shipment'),
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.titleSmall,
                          fontWeight: 600),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/shipment');
                    },
                  ),
                  /*ListTile(
                    leading: Image.asset(
                      'assets/images/money.png',
                      color: Color(0xff42855B),
                      width: 30,
                    ),
                    onTap: () async {
                      if (await Helper().checkConnectivity()) {
                        Navigator.pushNamed(context, '/purchases');
                      } else {
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)
                                .translate('check_connectivity'));
                      }
                    },
                    title: Text(
                      AppLocalizations.of(context).translate('purchases'),
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.titleSmall,
                          fontWeight: 600),
                    ),
                  )*/
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.all(10),
                    child: Text(
                        AppLocalizations.of(context).translate('version'))))
          ],
        ),
      ),
    );
  }

  //multi language option
  Widget changeAppLanguage() {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Container(
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
        dropdownColor: themeData.colorScheme.onPrimary,
        onChanged: (String? newValue) {
          appLanguage.changeLanguage(Locale(newValue!), newValue);
          selectedLanguage = newValue;
          Navigator.pop(context);
        },
        value: selectedLanguage,
        items: Config().lang.map<DropdownMenuItem<String>>((Map locale) {
          return DropdownMenuItem<String>(
            value: locale['languageCode'],
            child: Text(
              locale['name'],
              style: AppTheme.getTextStyle(themeData.textTheme.titleSmall,
                  fontWeight: 600),
            ),
          );
        }).toList(),
      )),
    );
  }

  //on sync
  sync() async {
    if (!syncPressed) {
      syncPressed = true;
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(AppLocalizations.of(context)
                        .translate('sync_in_progress'))),
              ],
            ),
          );
        },
      );
      await Sell().createApiSell(syncAll: true).then((value) async {
        await Variations().refresh().then((value) {
          Navigator.pop(context);
        });
      });
    }
  }

  //widget for payment details
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
              style: AppTheme.getTextStyle(
                themeData.textTheme.titleMedium,
                fontWeight: 700,
              )),
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




