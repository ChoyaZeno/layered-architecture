import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered_architecture/domain/repositories/notification_repository.dart';

import 'package:layered_architecture/presentation/blocs/notification/notification_event.dart';
import 'package:layered_architecture/presentation/blocs/notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({
    required NotificationRepository notificationRepository,
  }) : super(const NotificationInitial()) {
    on<NotificationReceived>(_onNotificationReceived);
    _notificationRepositorySubscription = notificationRepository.stream.listen(
      (message) => add(NotificationReceived(message: message)),
    );
  }

  late final StreamSubscription _notificationRepositorySubscription;

  void _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationData(message: event.message));
  }

  @override
  Future<void> close() {
    _notificationRepositorySubscription.cancel();
    return super.close();
  }
}
