//profit_loss_report_model.dart

class ProfitLossReportModel {
  String? totalPurchaseShippingCharge;
  String? totalSellShippingCharge;
  String? totalPurchaseAdditionalExpense;
  String? totalSellAdditionalExpense;
  String? totalTransferShippingCharges;
  String? openingStock;
  String? closingStock;
  String? totalPurchase;
  String? totalPurchaseDiscount;
  String? totalPurchaseReturn;
  String? totalSell;
  String? totalSellDiscount;
  String? totalSellReturn;
  String? totalSellRoundOff;
  int? totalExpense;
  String? totalAdjustment;
  String? totalRecovered;
  String? totalRewardAmount;
  double? netProfit;
  String? grossProfit;

  ProfitLossReportModel({
    this.totalPurchaseShippingCharge,
    this.totalSellShippingCharge,
    this.totalPurchaseAdditionalExpense,
    this.totalSellAdditionalExpense,
    this.totalTransferShippingCharges,
    this.openingStock,
    this.closingStock,
    this.totalPurchase,
    this.totalPurchaseDiscount,
    this.totalPurchaseReturn,
    this.totalSell,
    this.totalSellDiscount,
    this.totalSellReturn,
    this.totalSellRoundOff,
    this.totalExpense,
    this.totalAdjustment,
    this.totalRecovered,
    this.totalRewardAmount,
    this.netProfit,
    this.grossProfit,
  });

  ProfitLossReportModel.fromJson(Map<String, dynamic> json) {
    totalPurchaseShippingCharge = json['total_purchase_shipping_charge'].toString();
    totalSellShippingCharge = json['total_sell_shipping_charge'].toString();
    totalPurchaseAdditionalExpense = json['total_purchase_additional_expense'].toString();
    totalSellAdditionalExpense = json['total_sell_additional_expense'].toString();
    totalTransferShippingCharges = json['total_transfer_shipping_charges'].toString();
    openingStock = json['opening_stock'].toString();
    closingStock = json['closing_stock'].toString();
    totalPurchase = json['total_purchase'].toString();
    totalPurchaseDiscount = json['total_purchase_discount'].toString();
    totalPurchaseReturn = json['total_purchase_return'].toString();
    totalSell = json['total_sell'].toString();
    totalSellDiscount = json['total_sell_discount'].toString();
    totalSellReturn = json['total_sell_return'].toString();
    totalSellRoundOff = json['total_sell_round_off'].toString();
    totalExpense = json['total_expense'];
    totalAdjustment = json['total_adjustment'].toString();
    totalRecovered = json['total_recovered'].toString();
    totalRewardAmount = json['total_reward_amount'].toString();
    netProfit = json['net_profit'];
    grossProfit = json['gross_profit'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_purchase_shipping_charge'] = this.totalPurchaseShippingCharge;
    data['total_sell_shipping_charge'] = this.totalSellShippingCharge;
    data['total_purchase_additional_expense'] =
        this.totalPurchaseAdditionalExpense;
    data['total_transfer_shipping_charges'] = this.totalTransferShippingCharges;
    data['opening_stock'] = this.openingStock;
    data['closing_stock'] = this.closingStock;
    data['total_purchase'] = this.totalPurchase;
    data['total_purchase_discount'] = this.totalPurchaseDiscount;
    data['total_purchase_return'] = this.totalPurchaseReturn;
    data['total_sell'] = this.totalSell;
    data['total_sell_discount'] = this.totalSellDiscount;
    data['total_sell_return'] = this.totalSellReturn;
    data['total_sell_round_off'] = this.totalSellRoundOff;
    data['total_expense'] = this.totalExpense;
    data['total_adjustment'] = this.totalAdjustment;
    data['total_recovered'] = this.totalRecovered;
    data['total_reward_amount'] = this.totalRewardAmount;
    data['net_profit'] = this.netProfit;
    data['gross_profit'] = this.grossProfit;
    return data;
  }
}
