class NotificationModel {
  String msg;
  String iconClass;
  String link;
  String? readAt;
  String createdAt;

  NotificationModel({
    required this.msg,
    required this.iconClass,
    required this.link,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      msg: json['msg'] as String,
      iconClass: json['icon_class'] as String,
      link: json['link'] as String,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String,
    );
  }
}
