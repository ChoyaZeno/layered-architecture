part of 'hud_bloc.dart';

sealed class HudState extends Equatable {
  const HudState();

  int get resources => 0;
  int get guests => 0;
  int get money => 0;

  @override
  List<Object?> get props => [
        resources,
        guests,
        money,
      ];

  @override
  bool? get stringify => false;
}

class HudPure implements HudState {
  const HudPure({
    this.resources = 0,
    this.guests = 0,
    this.money = 0,
  });

  @override
  final int resources;

  @override
  final int guests;

  @override
  final int money;

  @override
  List<Object?> get props => [
        resources,
        guests,
        money,
      ];

  @override
  bool? get stringify => false;
}

class HudDirty extends HudPure {
  const HudDirty({
    required super.resources,
    required super.guests,
    required super.money,
  });

  @override
  List<Object?> get props => [
        resources,
        guests,
        money,
      ];

  @override
  bool? get stringify => false;
}
