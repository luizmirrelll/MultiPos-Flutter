class BusinessBrands {
  int id;
  int businessId;
  String name;
  String? description;
  int createdBy;
  DateTime? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  BusinessBrands({
    required this.id,
    required this.businessId,
    required this.name,
    this.description,
    required this.createdBy,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessBrands.fromJson(Map<String, dynamic> json) {
    return BusinessBrands(
      id: json['id'] as int,
      businessId: json['business_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdBy: json['created_by'] as int,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
