import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wallet_state.dart';
part 'wallet_event.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(const WalletPure()) {
    on<WalletUpdate>(
      _onWalletUpdate,
      transformer: debounceAndEmit(
        WalletBloc.debounce,
        WalletBloc.maxEmit,
      ),
    );
  }

  static const debounce = Duration(milliseconds: 200);
  static const maxEmit = Duration(milliseconds: 500);

  void _onWalletUpdate(
    WalletUpdate event,
    Emitter<WalletState> emit,
  ) {
    print('update!');
    emit(WalletDirty(
      amount: state.amount + 100,
    ));
  }

  EventTransformer<WalletEvent> debounceAndEmit<WalletEvent>(
    Duration debounceDuration,
    Duration maxEmitDuration,
  ) {
    return (events, mapper) {
      return restartable<WalletEvent>().call(
        events.transform(StreamTransformer.fromBind((stream) {
          late StreamController<WalletEvent> controller;
          Timer? debounceTimer;
          Timer? maxEmitTimer;
          WalletEvent? lastEvent;

          void emitEvent() {
            if (lastEvent case WalletEvent walletEvent) {
              controller.add(walletEvent);
              lastEvent = null;
              maxEmitTimer?.cancel();
              maxEmitTimer = null;
            }
          }

          controller = StreamController<WalletEvent>(
            onListen: () {
              stream.listen(
                (event) {
                  lastEvent = event;
                  debounceTimer?.cancel();
                  debounceTimer = Timer(debounceDuration, emitEvent);
                  maxEmitTimer ??= Timer(maxEmitDuration, emitEvent);
                },
                onError: controller.addError,
                onDone: controller.close,
              );
            },
            onCancel: () {
              debounceTimer?.cancel();
              maxEmitTimer?.cancel();
            },
          );

          return controller.stream;
        })),
        mapper,
      );
    };
  }
}
