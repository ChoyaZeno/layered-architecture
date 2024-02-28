import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered_architecture/domain/repositories/coffee_house_repository.dart';
import 'package:layered_architecture/domain/repositories/notification_repository.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_event.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_state.dart';

class CoffeeHouseBloc extends Bloc<CoffeeHouseEvent, CoffeeHouseState> {
  CoffeeHouseBloc({
    required CoffeeHouseRepositoryContract coffeeHouseRepository,
    required NotificationRepository notificationRepository,
  })  : _coffeeHouseRepository = coffeeHouseRepository,
        _notificationRepository = notificationRepository,
        super(const CoffeeHouseInitial()) {
    on<CoffeeHouseOpenStore>(_onCoffeeHouseOpenStore);
    on<CoffeeHouseBrewCoffee>(_onCoffeeHouseBrewCoffee);
  }

  final CoffeeHouseRepositoryContract _coffeeHouseRepository;
  final NotificationRepository _notificationRepository;

  get storeName => _coffeeHouseRepository.coffeeHouseName;

  void _onCoffeeHouseOpenStore(
    CoffeeHouseOpenStore event,
    Emitter<CoffeeHouseState> emit,
  ) {
    switch (state) {
      case CoffeeHouseInitial():
      case CoffeeHouseStoreClosed():
        emit(const CoffeeHouseLoaded(message: '???'));
        _notificationRepository
            .notify('Welcome to ${_coffeeHouseRepository.coffeeHouseName}!');
        return;
      case CoffeeHouseLoaded():
      case CoffeeHouseError():
        _notificationRepository.notify(
            '${_coffeeHouseRepository.coffeeHouseName} is already open.');
    }
  }

  void _onCoffeeHouseBrewCoffee(
    CoffeeHouseBrewCoffee event,
    Emitter<CoffeeHouseState> emit,
  ) {
    // Randomly close store
    if (Random().nextInt(3) + 1 > 2) {
      _notificationRepository.notify(
          '${_coffeeHouseRepository.coffeeHouseName} is closing, end of service!');
      emit(const CoffeeHouseStoreClosed(message: '???'));
      return;
    }

    switch (state) {
      case CoffeeHouseInitial():
      case CoffeeHouseLoaded():
      case CoffeeHouseError():
        _notificationRepository.notify(
          _coffeeHouseRepository.brew(event.coffee),
        );
    }
  }
}
