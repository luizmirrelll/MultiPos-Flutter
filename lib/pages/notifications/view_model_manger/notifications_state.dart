part of 'notifications_cubit.dart';


abstract class NotificationsState {
  const NotificationsState();
}

class NotificationsInitial extends NotificationsState {}
class NotificationGetDataLoading extends NotificationsState {
  const NotificationGetDataLoading();
}
class NotificationGetDataSuccessful extends NotificationsState {
  final List<NotificationModel> notifications;
  const NotificationGetDataSuccessful(this.notifications);
}
class NotificationGetDataFailure extends NotificationsState {
  final String errorMessage;
  const NotificationGetDataFailure(this.errorMessage);
}