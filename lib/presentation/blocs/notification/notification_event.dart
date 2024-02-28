import 'package:equatable/equatable.dart';

sealed class NotificationEvent extends Equatable {}

class NotificationReceived implements NotificationEvent {
  const NotificationReceived({
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
