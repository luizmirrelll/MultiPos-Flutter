
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../helpers/AppTheme.dart';
import '../helpers/SizeConfig.dart';
import '../helpers/otherHelpers.dart';
import '../locale/MyLocalizations.dart';
import '../pages/login.dart';

// ignore: must_be_immutable
class Splash extends StatefulWidget {
  static int themeType = 1;

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  ThemeData themeData = AppTheme.getThemeFromThemeMode(Splash.themeType);

  CustomAppTheme customAppTheme = AppTheme.getCustomAppTheme(Splash.themeType);
  @override
  void initState() {
   changeLanguage();
    super.initState();
  }
  var selectedLanguage;
  void changeLanguage ()
  async{
    var prefs = await SharedPreferences.getInstance();
    selectedLanguage =
        prefs.getString('language_code') ?? Config().defaultLanguage;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return Scaffold(
      backgroundColor: Color(0xff3d63ff),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/welcome.json', width: 500,),
              Text(AppLocalizations.of(context).translate('welcome'),
                  style: AppTheme.getTextStyle(
                      themeData.textTheme.headlineMedium,
                      color: Colors.white)),
              SizedBox(height: 15,),
              ElevatedButton(
                onPressed: ()  {
                  showDialog(context: context,
                      builder: (context)=>AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'))

                        ],
                        title: Text(AppLocalizations.of(context)
                            .translate('language'),
                        ),
                        content: changeAppLanguage(),
                      ));
                },


                style: ElevatedButton.styleFrom(
                    primary: themeData.colorScheme.onPrimary,
                    shadowColor: themeData.colorScheme.primary),
                child: Text(AppLocalizations.of(context).translate('language'),
                    style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                        color: themeData.colorScheme.primary, fontWeight: 600)),
              ),
              SizedBox(height: 15,),
              ElevatedButton(
                onPressed: () async {
                  await Helper().requestAppPermission();
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  if (prefs.getInt('userId') != null) {
                    Config.userId = prefs.getInt('userId');
                    Config.userId = Config.userId;
                    Helper().jobScheduler();
                    //Take to home page
                    Navigator.of(context).pushReplacementNamed('/layout');
                  } else
                    Navigator.of(context).pushReplacementNamed('/login');
                },


                style: ElevatedButton.styleFrom(
                    primary: themeData.colorScheme.onPrimary,
                    shadowColor: themeData.colorScheme.primary),
                child: Text(AppLocalizations.of(context).translate('login'),
                    style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                        color: themeData.colorScheme.primary, fontWeight: 600)),
              ),
              Visibility(
                visible: Config().showRegister,
                child: Padding(
                  padding: EdgeInsets.all(MySize.size10!),
                  child: GestureDetector(
                    child: Text(
                        AppLocalizations.of(context).translate('register'),
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.bodyLarge,
                            color: Colors.white,
                            fontWeight: 600)),
                    onTap: () async {
                      await launch('${Config.baseUrl}/business/register');
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

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
                  style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,
                      fontWeight: 600),
                ),
              );
            }).toList(),
          )),
    );
  }
}