part of 'slots_cubit.dart';

sealed class SlotsState extends Equatable {
  const SlotsState();

  List<int> get slots => [];

  @override
  List<Object?> get props => [
        slots,
      ];

  @override
  bool? get stringify => false;
}

class SlotsPure implements SlotsState {
  const SlotsPure();

  @override
  List<int> get slots => [];

  @override
  List<Object?> get props => [
        slots,
      ];

  @override
  bool? get stringify => false;
}

class SlotsDirty extends SlotsPure {
  SlotsDirty({
    required this.slots,
  });

  @override
  final List<int> slots;

  @override
  List<Object?> get props => [
        slots,
      ];

  @override
  bool? get stringify => false;
}
