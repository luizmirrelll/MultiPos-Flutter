import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_final/apis/notification.dart';
import 'package:pos_final/models/notification_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  static NotificationsCubit get(context)=>BlocProvider.of(context);

  int notificationsCount=0;
  Future<void> getNotification() async {
    emit(const NotificationGetDataLoading());
    final data = await NotificationService().getNotifications();
    if (data.error == null) {
      List<NotificationModel> notifications = [];
      for (Map<String, dynamic> json in data.response!.data['data']) {
        notifications.add(NotificationModel.fromJson(json));
      }
      notificationsCount = notifications.length;
      emit(NotificationGetDataSuccessful(notifications));
    } else {
      emit(NotificationGetDataFailure(data.error));
    }
  }


}
