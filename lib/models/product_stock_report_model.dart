class ProductStockReportModel {
  String? totalSold;
  String? stockPrice;
  String? stock;
  String? product;
  String? sku;
  String? type;
  String? locationName;
  String? alertQuantity;
  String? categoryName;
  int? productId;
  String? unit;
  int? enableStock;
  String? unitPrice;

  ProductStockReportModel(
      {this.totalSold,
      this.stockPrice,
      this.stock,
      this.unit,
      this.categoryName,
      this.product,
      this.locationName,
      this.sku,
      this.type,
      this.alertQuantity,
      this.productId,
      this.enableStock,
      this.unitPrice});

  ProductStockReportModel.fromJson(Map<String, dynamic> json) {
    totalSold = json['total_sold'] ?? "....";
    stockPrice = json['stock_price'] ?? "....";
    stock = json['stock'] ?? "....";
    unit = json['unit'] ?? "....";
    product = json['product'] ?? "....";
    categoryName = json['category_name'] ?? "....";
    locationName = json['location_name'] ?? "....";
    sku = json['sku'] ?? "....";
    type = json['type'] ?? "....";
    alertQuantity = json['alert_quantity'] ?? "....";
    productId = json['product_id'] ?? "....";
    enableStock = json['enable_stock'] ?? "....";
    unitPrice = json['unit_price'] ?? "....";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_sold'] = this.totalSold;
    data['stock_price'] = this.stockPrice;
    data['stock'] = this.stock;
    data['unit'] = this.unit;
    data['product'] = this.product;
    data['category_name'] = this.categoryName;
    data['location_name'] = this.locationName;
    data['sku'] = this.sku;
    data['type'] = this.type;
    data['alert_quantity'] = this.alertQuantity;
    data['product_id'] = this.productId;
    data['enable_stock'] = this.enableStock;
    data['unit_price'] = this.unitPrice;
    return data;
  }
}
