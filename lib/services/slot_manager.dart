import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

typedef SlotMapping = ({List<int> slots});

class SlotManager {
  final List<int> _slots = [];

  List<int> get slots => _slots;

  SlotManager();

  Either<String, Unit> openSlot() {
    _slots.add(UniqueKey().hashCode);
    return const Right(unit);
  }

  SlotMapping getState() {
    return (slots: _slots);
  }
}
