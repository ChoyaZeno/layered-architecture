import 'package:equatable/equatable.dart';

sealed class NotificationState extends Equatable {}

class NotificationInitial implements NotificationState {
  const NotificationInitial();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class NotificationData implements NotificationState {
  const NotificationData({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => false;
}
