import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_final/helpers/AppTheme.dart';

import 'package:pos_final/locale/MyLocalizations.dart';

import '../../apis/notification.dart';
import 'view_model_manger/notifications_cubit.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static int themeType = 1;
  static ThemeData themeData = AppTheme.getThemeFromThemeMode(themeType);

  @override
  void initState() {
    super.initState();
    NotificationService().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(AppLocalizations.of(context).translate('notifications'),
              style: AppTheme.getTextStyle(themeData.textTheme.titleLarge,
                  fontWeight: 600)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationGetDataFailure)
                return Center(
                  child: Text(state.errorMessage),
                );
              else if (state is NotificationGetDataSuccessful) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 8.0),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        color: Color(0xffedecf2),
                        elevation: 1.0,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            leading: Lottie.asset('assets/lottie/bell.json'),
                            title: Text(state.notifications[index].msg),
                            subtitle: Text(state.notifications[index].createdAt),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: state.notifications.length,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
