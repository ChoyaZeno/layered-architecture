import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:layered_architecture/domain/repositories/coffee_house_repository.dart';
import 'package:layered_architecture/domain/repositories/notification_repository.dart';

part 'brew_coffee_errors.dart';
part 'brew_coffee_types.dart';

class BrewCoffeeUseCase {
  BrewCoffeeUseCase({
    required CoffeeHouseRepositoryContract coffeeHouseRepository,
    required NotificationRepository notificationRepository,
  })  : _coffeeHouseRepository = coffeeHouseRepository,
        _notificationRepository = notificationRepository;

  final CoffeeHouseRepositoryContract _coffeeHouseRepository;
  final NotificationRepository _notificationRepository;

  Future<BrewCoffeeResult> call(final String coffee) async {
    // Randomly close store
    if (Random().nextInt(3) + 1 > 2) {
      _notificationRepository.notify(
          '${_coffeeHouseRepository.coffeeHouseName} is closing, end of service!');
      // emit(const CoffeeHouseStoreClosed(message: '???'));
      return BrewCoffeeClosed();
    }

    final inventory = _coffeeHouseRepository.inventory;

    if (inventory.containsKey(coffee) == false) {
      return BrewCoffeeMissing();
    }

    final coffeeStock = inventory[coffee];

    if (coffeeStock case int value when value > 0 == false) {
      return BrewCoffeeStock();
    }

    final result = _coffeeHouseRepository.brew(coffee);

    return result.fold(Left.new, (brewResult) {
      _notificationRepository.notify(
        brewResult,
      );

      inventory[coffee] = (coffeeStock as int) - 1;
      _coffeeHouseRepository.inventory = inventory;

      return const Right(unit);
    });
  }
}
