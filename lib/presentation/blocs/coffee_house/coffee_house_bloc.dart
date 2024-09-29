import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered_architecture/domain/repositories/coffee_house_repository_contract.dart';
import 'package:layered_architecture/domain/repositories/notification_repository.dart';
import 'package:layered_architecture/domain/usecases/coffee_house/brew_coffee/brew_coffee.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_event.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_state.dart';

class CoffeeHouseBloc extends Bloc<CoffeeHouseEvent, CoffeeHouseState> {
  CoffeeHouseBloc({
    required CoffeeHouseRepositoryContract coffeeHouseRepository,
    required NotificationRepository notificationRepository,
    required BrewCoffeeUseCase brewCoffeeUseCase,
  })  : _coffeeHouseRepository = coffeeHouseRepository,
        _notificationRepository = notificationRepository,
        _brewCoffeeUseCase = brewCoffeeUseCase,
        super(const CoffeeHouseInitial()) {
    on<CoffeeHouseOpenStore>(_onCoffeeHouseOpenStore);
    on<CoffeeHouseBrewCoffee>(_onCoffeeHouseBrewCoffee);
  }

  final CoffeeHouseRepositoryContract _coffeeHouseRepository;
  final NotificationRepository _notificationRepository;
  final BrewCoffeeUseCase _brewCoffeeUseCase;

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
  ) async {
    switch (state) {
      case CoffeeHouseInitial():
      case CoffeeHouseLoaded():
      case CoffeeHouseError():
        // emit OrderInProgress();

        final result = await _brewCoffeeUseCase.call(event.coffee);

        switch (result) {
          case BrewCoffeeSuccess():
            print('BrewCoffeeSuccess');
          case BrewCoffeeMissing():
            print('BrewCoffeeMissing');
          case BrewCoffeeStock():
            print('BrewCoffeeStock');
          case BrewCoffeeClosed():
            print('BrewCoffeeClosed');
            emit(const CoffeeHouseStoreClosed(message: '???'));
          case BrewCoffeeError(value: final error):
            print('error $error');
        }

      // emit OrderCompleted();
    }
  }
}
