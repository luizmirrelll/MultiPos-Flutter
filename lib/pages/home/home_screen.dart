import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_final/config.dart';
import 'package:pos_final/helpers/AppTheme.dart';
import 'package:pos_final/helpers/icons.dart';
import 'package:pos_final/locale/MyLocalizations.dart';
import 'package:pos_final/models/sellDatabase.dart';
import 'package:pos_final/pages/home/widgets/greeting_widget.dart';
import 'package:pos_final/pages/notifications/view_model_manger/notifications_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/statistics_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static ThemeData themeData = AppTheme.getThemeFromThemeMode(1);
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('home'),
            style: AppTheme.getTextStyle(themeData.textTheme.titleLarge,
                fontWeight: 600)),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                /*     (await Helper().checkConnectivity())
                    ? await sync()
                    : Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)
                        .translate('check_connectivity'));*/
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
                          //    Navigator.pushNamed(context, '/notify');
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
        bottom: GreetingWidget(themeData: themeData, userName: 'Shehab'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Statistics(themeData:themeData,totalSales: 0,totalReceivedAmount: 0,totalDueAmount: 0,totalSalesAmount: 0,)
          ],
        ),
      ),
    );
  }
}
