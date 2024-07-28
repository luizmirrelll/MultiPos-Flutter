import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_final/apis/api.dart';
import 'package:pos_final/apis/system.dart';
import 'package:pos_final/apis/user.dart';
import 'package:pos_final/config.dart';
import 'package:pos_final/helpers/AppTheme.dart';
import 'package:pos_final/helpers/otherHelpers.dart';
import 'package:pos_final/models/contact_model.dart';
import 'package:pos_final/models/database.dart';
import 'package:pos_final/models/sellDatabase.dart';
import 'package:pos_final/models/system.dart';
import 'package:pos_final/models/variations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  @override
  close() async {
    super.close();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  ///private variables
  static int _themeType = 1;
  ThemeData _themeData = AppTheme.getThemeFromThemeMode(_themeType);
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  IconData _passwordIcon = MdiIcons.eyeOffOutline;

  ///Getters
  ThemeData get themeData => _themeData;

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get usernameController => _usernameController;

  TextEditingController get passwordController => _passwordController;

  bool get isLoading => _isLoading;

  bool get passwordVisible => _passwordVisible;

  IconData get passwordIcon => _passwordIcon;

  ///Setters
  set isLoading(bool isLoading) => _isLoading = isLoading;

  set passwordVisible(bool passwordVisible) {
    _passwordVisible = passwordVisible;
    if (passwordVisible)
      _passwordIcon = MdiIcons.eyeOutline;
    else
      _passwordIcon = MdiIcons.eyeOffOutline;
    emit(LoginChangePasswordVisibility());
  }

  ///Methods
  Future<void> _showLoadingDialogue(BuildContext context) async {
    emit(LoginShowLoadingDialogue());
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Lottie.asset('assets/lottie/loading.json',
              width: 200, height: 200),
        );
      },
    );
  }

  Future<bool> _checkInternetConnectivity() async {
    return await Helper().checkConnectivity();
  }

  bool _validateOnData() {
    return _formKey.currentState!.validate() && !_isLoading;
  }

  Future<Map<dynamic, dynamic>?> _makeALogin() async {
    return await Api().login(usernameController.text, passwordController.text);
  }

  void navigateToHome(BuildContext context) {
    Navigator.of(context).pop();

    //Take to home page
    Navigator.of(context).pushReplacementNamed('/layout');
  }

  Future<void> _loadAllData(loginResponse, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map loggedInUser = await User().get(loginResponse['access_token']);

    Config.userId = loggedInUser['id'];

    //saving userId in disk
    prefs.setInt('userId', Config.userId!);
    DbProvider().initializeDatabase(loggedInUser['id']);

    String? lastSync = await System().getProductLastSync();
    final date2 = DateTime.now();

    //delete system table before saving data
    System().empty();
    //delete contact table
    Contact().emptyContact();
    //save user details
    await System().insertUserDetails(loggedInUser);
    //Insert token
    System().insertToken(loginResponse['access_token']);
    //save system data
    await SystemApi().store();
    await System().insertProductLastSyncDateTimeNow();
    //check previous userId
    if (prefs.getInt('prevUserId') == null ||
        prefs.getInt('prevUserId') != prefs.getInt('userId')) {
      SellDatabase().deleteSellTables();
      await Variations().refresh();
    } else {
      //save variations if last sync is greater than 10hrs
      if (lastSync == null ||
          (date2.difference(DateTime.parse(lastSync)).inHours > 10)) {
        if (await Helper().checkConnectivity()) {
          await Variations().refresh();
          await System().insertProductLastSyncDateTimeNow();
          SellDatabase().deleteSellTables();
        }
      }
    }
    //Take to home page
   // Navigator.of(context).pushReplacementNamed('/layout');
   // Navigator.of(context).pop();
  }

  Future<void> checkOnLogin(BuildContext context) async {
    if (await _checkInternetConnectivity()) {
      if (_validateOnData()) {
        var loginResponse = await _makeALogin();
        if (loginResponse?['success'] != null && loginResponse?['success']) {
          Helper().jobScheduler();
          //Get current logged in user details and save it.
          _showLoadingDialogue(context);
          await _loadAllData(loginResponse, context);
          emit(LoginSuccessfully());
        } else {
          emit(LoginFailed());
        }
      }
    }
  }

  Future<void> register() async {
    await launchUrl(Uri.parse('${Config.baseUrl}/business/register'));
  }
}
