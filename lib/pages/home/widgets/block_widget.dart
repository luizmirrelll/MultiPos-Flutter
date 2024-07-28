import 'package:flutter/material.dart';
import 'package:pos_final/helpers/AppTheme.dart';
import 'package:pos_final/helpers/SizeConfig.dart';

class Block extends StatelessWidget {
  Block(
      {this.backgroundColor,
      this.subject,
      this.image,
      this.amount,
      required this.themeData});

  final Color? backgroundColor;
  final String? subject, image, amount;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySize.size8!),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Container(
          padding:
              EdgeInsets.only(bottom: MySize.size16!, left: MySize.size16!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                '$image',
                height: 40,
              ),
              Text(subject!,
                  style: AppTheme.getTextStyle(themeData.textTheme.titleMedium,
                      fontWeight: 600, color: Colors.white)),
              Text("$amount",
                  style: AppTheme.getTextStyle(themeData.textTheme.bodySmall,
                      fontWeight: 500, color: Colors.white, letterSpacing: 0)),
            ],
          ),
        ),
      ),
    );
  }
}
