import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_final/helpers/icons.dart';

import '../helpers/AppTheme.dart';
import '../helpers/SizeConfig.dart';
import '../helpers/style.dart' as style;
import '../locale/MyLocalizations.dart';

Widget posBottomBar(page, context, [call]) {
  ThemeData themeData = AppTheme.getThemeFromThemeMode(1);
  return Material(
    elevation: 0,
    child: Container(
      color: themeData.colorScheme.onPrimary,
      height: MySize.size56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          bottomBarMenu(
              context,
              '/home',
              AppLocalizations.of(context).translate('home'),
              page == "home",
              IconBroken.Home,
              true),
          bottomBarMenu(
              context,
              '/products',
              AppLocalizations.of(context).translate('products'),
              page == "products",
              MdiIcons.cart,
              true),
          bottomBarMenu(
              context,
              '/sale',
              AppLocalizations.of(context).translate('sales'),
              page == "sale",
              Icons.list,
              true),
        ],
      ),
    ),
  );
}

Widget bottomBarMenu(context, route, name, isSelected, [replace, arguments]) {
  replace = (replace == null) ? false : replace;
  return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () {
        if (replace)
          Navigator.pushReplacementNamed(context, route, arguments: arguments);
        else
          Navigator.pushNamed(context, route, arguments: arguments);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          (isSelected)
              ? Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    name,
                    style: AppTheme.getTextStyle(
                        Theme.of(context).textTheme.bodyText1,
                        color: Color(0xff3C6255)),
                  ),
                )
              : Container()
        ],
      ));
}

Widget cartBottomBar(route, name, context, [nextArguments]) {
  ThemeData themeData = AppTheme.getThemeFromThemeMode(1);
  //TODO: add some shadows.
  return Material(
    child: Container(
      color: Color(0xff3C6255),
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          bottomBarMenu(context, route, name, true, false, nextArguments),
        ],
      ),
    ),
  );
}

//syncAlert
syncing(time, context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 5),
            child: Text("Sync in progress...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: time), () {
        Navigator.of(context).pop(true);
      });
      return alert;
    },
  );
}
