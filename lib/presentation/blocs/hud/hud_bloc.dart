import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered_architecture/services/resource_manager.dart';

part 'hud_state.dart';
part 'hud_event.dart';

// Papers, please game
class HudBloc extends Bloc<HudEvent, HudState> {
  HudBloc({required ResourceManager resourceManager})
      : _resourceManager = resourceManager,
        super(const HudPure()) {
    on<HudUpdateEvent>(
      _onWalletUpdate,
      transformer: debounceAndEmit(
        HudBloc.debounce,
        HudBloc.maxEmit,
      ),
    );
  }

  final ResourceManager _resourceManager;

  static const debounce = Duration(milliseconds: 200);
  static const maxEmit = Duration(milliseconds: 500);

  void _onWalletUpdate(
    HudUpdateEvent event,
    Emitter<HudState> emit,
  ) {
    final resources = _resourceManager.getState();

    emit(HudDirty(
      resources: resources.resources,
      guests: resources.guests,
      money: resources.money,
    ));
  }

  EventTransformer<HudEvent> debounceAndEmit<HudEvent>(
    Duration debounceDuration,
    Duration maxEmitDuration,
  ) {
    return (events, mapper) {
      return restartable<HudEvent>().call(
        events.transform(StreamTransformer.fromBind((stream) {
          late StreamController<HudEvent> controller;
          Timer? debounceTimer;
          Timer? maxEmitTimer;
          HudEvent? lastEvent;

          void emitEvent() {
            if (lastEvent case HudEvent walletEvent) {
              controller.add(walletEvent);
              lastEvent = null;
              maxEmitTimer?.cancel();
              maxEmitTimer = null;
            }
          }

          controller = StreamController<HudEvent>(
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
