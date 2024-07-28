// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lottie/lottie.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../apis/api.dart';
// import '../apis/system.dart';
// import '../apis/user.dart';
// import '../config.dart';
// import '../helpers/AppTheme.dart';
// import '../helpers/SizeConfig.dart';
// import '../helpers/otherHelpers.dart';
// import '../locale/MyLocalizations.dart';
// import '../models/contact_model.dart';
// import '../models/database.dart';
// import '../models/sellDatabase.dart';
// import '../models/system.dart';
// import '../models/variations.dart';
//
// // ignore: non_constant_identifier_names
//
//
// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   static int themeType = 1;
//   ThemeData themeData = AppTheme.getThemeFromThemeMode(themeType);
//
//   final _formKey = GlobalKey<FormState>();
//   Timer? timer;
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   bool isLoading = false;
//   bool _passwordVisible = false;
//
//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     timer!.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     themeData = Theme.of(context);
//     return Scaffold(
//       backgroundColor: Color(0xff3d63ff),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Center(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Lottie.asset('assets/lottie/welcome.json'),
//                   Container(
//                     alignment: Alignment.center,
//                     height: 400,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50.0),
//                       color: Colors.white,
//                     ),
//                     margin: EdgeInsets.only(
//                         left: MySize.size16!,
//                         right: MySize.size16!,
//                         top: MySize.size16!),
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: TextFormField(
//                           style: AppTheme.getTextStyle(
//                               themeData.textTheme.bodyLarge,
//                               letterSpacing: 0.1,
//                               color: themeData.colorScheme.onBackground,
//                               fontWeight: 500),
//                           decoration: InputDecoration(
//                             hintText: AppLocalizations.of(context)
//                                 .translate('username'),
//                             hintStyle: AppTheme.getTextStyle(
//                                 themeData.textTheme.titleSmall,
//                                 letterSpacing: 0.1,
//                                 color: themeData.colorScheme.onBackground,
//                                 fontWeight: 500),
//                             filled: true,
//                             fillColor: usernameController.text.isEmpty
//                                 ? const Color.fromRGBO(248, 247, 251, 1)
//                                 : Colors.transparent,
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                                 borderSide: BorderSide(
//                                   color: usernameController.text.isEmpty
//                                       ? Colors.transparent
//                                       : const Color(0xff3d63ff),
//                                 )),
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                                 borderSide: const BorderSide(
//                                   color: Color(0xff3d63ff),
//                                 )),
//                             suffixIcon: Icon(MdiIcons.faceMan),
//                           ),
//                           controller: usernameController,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return AppLocalizations.of(context)
//                                   .translate('please_enter_username');
//                             }
//                             return null;
//                           },
//                           autofocus: true,
//                         ),
//                       ),
//                       SizedBox(height: 15,),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//
//                         child: TextFormField(
//                           keyboardType: TextInputType.visiblePassword,
//                           style: AppTheme.getTextStyle(
//                               themeData.textTheme.bodyLarge,
//                               letterSpacing: 0.1,
//                               color: themeData.colorScheme.onBackground,
//                               fontWeight: 500),
//                           decoration: InputDecoration(
//                             hintText: AppLocalizations.of(context)
//                                 .translate('password'),
//                             hintStyle: AppTheme.getTextStyle(
//                                 themeData.textTheme.titleSmall,
//                                 letterSpacing: 0.1,
//                                 color: themeData.colorScheme.onBackground,
//                                 fontWeight: 500),
//                             filled: true,
//                             fillColor: passwordController.text.isEmpty
//                                 ? const Color.fromRGBO(248, 247, 251, 1)
//                                 : Colors.transparent,
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                                 borderSide: BorderSide(
//                                   color: passwordController.text.isEmpty
//                                       ? Colors.transparent
//                                       : const Color.fromRGBO(44, 185, 176, 1),
//                                 )),
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                                 borderSide: const BorderSide(
//                                   color: Color(0xff3d63ff),
//                                 )),
//                             suffixIcon: IconButton(
//                               color: passwordController.text.isEmpty
//                                   ? const Color(0xff3d63ff)
//                                   : const Color.fromRGBO(44, 185, 176, 1),
//                               icon: Icon(_passwordVisible
//                                   ? MdiIcons.eyeOutline
//                                   : MdiIcons.eyeOffOutline),
//                               onPressed: () {
//                                 setState(() {
//                                   _passwordVisible = !_passwordVisible;
//                                 });
//                               },
//                             ),
//                           ),
//                           obscureText: !_passwordVisible,
//                           controller: passwordController,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return AppLocalizations.of(context)
//                                   .translate('please_enter_password');
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 40,),
//                       Container(
//                         alignment: Alignment.center,
//                         width: 200,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50.0),
//                           color: const Color(0xff3d63ff),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF4C2E84).withOpacity(0.2),
//                               offset: const Offset(0, 15.0),
//                               blurRadius: 60.0,
//                             ),
//                           ],
//                         ),
//                         child: TextButton(
//                             child: isLoading ? CircularProgressIndicator():
//                             Text(
//                                 AppLocalizations.of(context)
//                                 .translate('login'),
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white),),
//                             onPressed: () async {
//                               if (await Helper().checkConnectivity()) {
//                                 if (_formKey.currentState!.validate() &&
//                                     !isLoading) {
//                                   setState(() {
//                                     isLoading = true;
//                                   });
//
//                                   Map? loginResponse = await Api().login(
//                                       usernameController.text,
//                                       passwordController.text);
//
//                                   if (loginResponse!['success']) {
//                                     //schedule job for syncing callLogs
//                                     Helper().jobScheduler();
//                                     //Get current logged in user details and save it.
//
//                                     showLoadingDialogue();
//                                     await loadAllData(loginResponse, context);
//                                     Navigator.of(context).pop();
//
//                                     //Take to home page
//                                     Navigator.of(context).pushNamed('/layout');
//                                   }
//                                   else {
//                                     setState(() {
//                                       isLoading = false;
//                                     });
//
//                                     Fluttertoast.showToast(
//                                       fontSize: 18,
//                                       backgroundColor: Colors.red,
//                                         msg: AppLocalizations.of(context)
//                                             .translate('invalid_credentials'));
//                                   }
//                                 }
//                               }
//                             }),
//                       ),
//                     ]),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   loadAllData(loginResponse,context) async {
//     timer = Timer.periodic(Duration(seconds: 30), (Timer t) {
//       (context != null)
//           ? Fluttertoast.showToast(
//               msg: AppLocalizations.of(context)
//                   .translate('It_may_take_some_more_time_to_load'))
//           : t.cancel();
//       t.cancel();
//     });
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Map loggedInUser = await User().get(loginResponse['access_token']);
//
//     ConfiguserId = loggedInUser['id'];
//     Config.userId = ConfiguserId;
//     //saving userId in disk
//     prefs.setInt('userId', ConfiguserId!);
//     DbProvider().initializeDatabase(loggedInUser['id']);
//
//     String? lastSync = await System().getProductLastSync();
//     final date2 = DateTime.now();
//
//     //delete system table before saving data
//     System().empty();
//     //delete contact table
//     Contact().emptyContact();
//     //save user details
//     await System().insertUserDetails(loggedInUser);
//     //Insert token
//     System().insertToken(loginResponse['access_token']);
//     //save system data
//     await SystemApi().store();
//     await System().insertProductLastSyncDateTimeNow();
//     //check previous userId
//     if (prefs.getInt('prevUserId') == null ||
//         prefs.getInt('prevUserId') != prefs.getInt('userId')) {
//       SellDatabase().deleteSellTables();
//       await Variations().refresh();
//     } else {
//       //save variations if last sync is greater than 10hrs
//       if (lastSync == null ||
//           (date2.difference(DateTime.parse(lastSync)).inHours > 10)) {
//         if (await Helper().checkConnectivity()) {
//           await Variations().refresh();
//           await System().insertProductLastSyncDateTimeNow();
//           SellDatabase().deleteSellTables();
//         }
//       }
//     }
//     //Take to home page
//     Navigator.of(context).pushReplacementNamed('/layout');
//     Navigator.of(context).pop();
//   }
//
//   Future<void> showLoadingDialogue() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content:  Lottie.asset('assets/lottie/loading.json',width: 200,height: 200),
//         );
//       },
//     );
//   }
// }
