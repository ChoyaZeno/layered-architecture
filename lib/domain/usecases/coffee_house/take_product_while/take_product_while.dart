import 'package:dartz/dartz.dart';
import 'package:layered_architecture/domain/repositories/coffee_house_repository_contract.dart';

class TakeProductWhileUseCase {
  TakeProductWhileUseCase({
    required CoffeeHouseRepositoryContract coffeeHouseRepository,
  }) : _coffeeHouseRepository = coffeeHouseRepository;

  final CoffeeHouseRepositoryContract _coffeeHouseRepository;

  Either<String, Unit> call<T>(final Either<String, T> Function() act,
      final productName, final int amount) {
    if (_coffeeHouseRepository.inventory.containsKey(productName) == false) {
      return const Left('This product does not exist');
      // return BrewCoffeeMissing();
    }

    for (var i = 0; i < amount; i++) {
      final inventory = _coffeeHouseRepository.inventory;

      final productStock = inventory[productName];

      if (productStock case int value when value > 0 == false) {
        return const Left('This product has no stock');
        // return BrewCoffeeStock();
      }

      final result = act().bind(
        // (productStock as int) - 1
        (_) => _coffeeHouseRepository.updateProduct(productName, 1),
      );

      if (result case Left(:final value)) {
        return Left(value);
      }
    }

    return const Right(unit);
  }
}
