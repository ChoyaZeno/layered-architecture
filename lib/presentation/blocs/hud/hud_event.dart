part of 'hud_bloc.dart';

sealed class HudEvent extends Equatable {}

class HudUpdateEvent implements HudEvent {
  const HudUpdateEvent();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}
