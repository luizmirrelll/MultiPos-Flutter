import 'package:flutter/material.dart';
import 'package:pos_final/helpers/AppTheme.dart';
import 'package:pos_final/helpers/SizeConfig.dart';
import 'package:pos_final/locale/MyLocalizations.dart';

class GreetingWidget extends StatefulWidget implements PreferredSizeWidget{
  const GreetingWidget({
    super.key,
    required this.themeData, required this.userName,
  });

  final ThemeData themeData;
  final String userName;
  static const double _kTabHeight = 46.0;

  @override
  State<GreetingWidget> createState() => _GreetingWidgetState();

  @override
  Size get preferredSize =>Size.fromHeight(_kTabHeight);
}

class _GreetingWidgetState extends State<GreetingWidget>   with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1), // Adjust the duration as needed
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Card(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(MySize.size10!),
          child: Text(
              AppLocalizations.of(context).translate('welcome') +
                  ' ${widget.userName}',
              style: AppTheme.getTextStyle(
                  widget.themeData.textTheme.titleMedium,
                  fontWeight: 700,
                  letterSpacing: -0.2)),
        ),
      ),
    );
  }
}