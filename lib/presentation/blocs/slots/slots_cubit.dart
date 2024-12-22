import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered_architecture/domain/usecases/slots/open_slot.dart';

part 'slots_state.dart';

class SlotsCubit extends Cubit<SlotsState> {
  SlotsCubit({
    required OpenSlotUseCase openSlotUseCase,
  })  : _openSlotUseCase = openSlotUseCase,
        super(const SlotsPure());

  final OpenSlotUseCase _openSlotUseCase;

  void openSlot() async {
    final result = await _openSlotUseCase.call();

    result.map((state) {
      emit(SlotsDirty(slots: state.slots));
    });

    // _slotManager.openSlot().map((_) {
    //   final state = _slotManager.getState();
    //   emit(SlotsDirty(slots: state.slots));
    // });
  }
}
