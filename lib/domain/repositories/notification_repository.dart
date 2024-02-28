import 'dart:async';

class NotificationRepository {
  NotificationRepository();

  final _controller = StreamController<String>();

  Stream<String> get stream async* {
    yield* _controller.stream;
  }

  void notify(String message) {
    _controller.sink.add(message);
  }
}
