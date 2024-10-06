import 'package:flutter_bloc/flutter_bloc.dart';

class LoggingBlocObserver extends BlocObserver {
  static int startTime = DateTime.now().millisecondsSinceEpoch;
  final String Function(dynamic currentState, dynamic nextState) logValues;

  LoggingBlocObserver({required this.logValues});

  @override
  void onChange(BlocBase bloc, Change change) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final elapsedTime = currentTime - startTime;
    final logMessage = logValues(change.currentState, change.nextState);

    print('State changed at $elapsedTime ms: ${change.currentState.runtimeType} => ${change.nextState.runtimeType}');
    print(logMessage);

    // startTime = currentTime; // Reset the start time after logging
    super.onChange(bloc, change);
  }
}
