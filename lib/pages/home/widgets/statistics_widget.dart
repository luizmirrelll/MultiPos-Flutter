import 'package:flutter/material.dart';
import 'package:pos_final/helpers/SizeConfig.dart';
import 'package:pos_final/helpers/otherHelpers.dart';
import 'package:pos_final/locale/MyLocalizations.dart';

import 'block_widget.dart';

class Statistics extends StatelessWidget {
  Statistics({
    this.businessSymbol = '',
    this.totalSales,
    this.totalSalesAmount = 0,
    this.totalReceivedAmount = 0,
    this.totalDueAmount = 0,
    required this.themeData,
  });

  final String businessSymbol;
  final int? totalSales;
  final double totalSalesAmount, totalReceivedAmount, totalDueAmount;
  final ThemeData themeData;
  static const List<Color> blocksColor = [
    Color(0xffFF9F29),
    Color(0xff3C6255),
    Color(0xffF55050),
    Color(0xff205295)
  ];
  static const List<String> blocksName = [
    'number_of_sales',
    'sales_amount',
    'paid_amount',
    'due_amount'
  ];
  static const List<String> blocksImagesPath = [
    'assets/images/sales.png',
    'assets/images/total_sales.png',
    'assets/images/payed_money.png',
    'assets/images/recived_money.png'
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: MySize.size16!,
          childAspectRatio: 4 / 3,
          crossAxisSpacing: MySize.size16!,
        ),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: 4,
        padding: EdgeInsets.only(
            left: MySize.size16!, right: MySize.size16!, top: MySize.size16!),
        itemBuilder: (context, index) => AnimatedBlock(
              themeData: themeData,
              blockColor: blocksColor[index],
              index: index,
              image: blocksImagesPath[index],
              subject: blocksName[index],
              amount: (index == 0)
                  ? Helper().formatQuantity(totalSales ?? 0)
                  : (index == 1)
                      ? '${businessSymbol} ' +
                          Helper().formatCurrency(totalSalesAmount)
                      : (index == 2)
                          ? '${businessSymbol} ' +
                              Helper().formatCurrency(totalReceivedAmount)
                          : '${businessSymbol} ' +
                              Helper().formatCurrency(totalDueAmount),
            ));
  }
}

class AnimatedBlock extends StatefulWidget {
  const AnimatedBlock(
      {super.key,
      required this.blockColor,
      required this.index,
      required this.themeData,
      this.subject,
      this.amount,
      this.image});

  final Color blockColor;
  final int index;
  final ThemeData themeData;
  final String? subject, amount, image;

  @override
  State<AnimatedBlock> createState() => _AnimatedBlockState();
}

class _AnimatedBlockState extends State<AnimatedBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    // Decide the direction based on the index
    final direction = widget.index.isEven ? 1.0 : -1.0;
    _offsetAnimation = Tween<Offset>(
      begin: Offset(direction, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
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
      child: Block(
          themeData: widget.themeData,
          amount: widget.amount,
          subject: AppLocalizations.of(context).translate(widget.subject!),
          backgroundColor: widget.blockColor,
          image: widget.image),
    );
  }
}
