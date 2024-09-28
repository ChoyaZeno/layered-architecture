import 'package:dartz/dartz.dart';

abstract class CoffeeHouseRepositoryContract {
  String get coffeeHouseName;

  Map<String, int> get inventory;
  set inventory(Map<String, int> value) {}

  Either<String, String> brew(String coffeeName);
}

class StarbucksChainRepository extends CoffeeHouseRepositoryContract {
  Map<String, int> _inventory = {
    'Nitro Cold Brew': 9,
    'Pumpkin Spice Latte': 7,
    'Pink Drink': 5,
  };

  @override
  String get coffeeHouseName => 'Starbucks';

  @override
  Map<String, int> get inventory => _inventory;
  @override
  set inventory(Map<String, int> value) {
    _inventory = value;
  }

  @override
  Either<String, String> brew(String coffeeName) {
    if (inventory[coffeeName] case int value when value % 2 == 0) {
      return const Left('Machine malfunction');
    }

    return Right('Starbucks Employer: $coffeeName is ready!');
  }
}

class TrainKioskRepository extends CoffeeHouseRepositoryContract {
  Map<String, int> _inventory = {
    'Coffee': 10,
    'Espresso': 8,
    'Cappucino': 5,
  };

  @override
  String get coffeeHouseName => 'Kiosk';

  @override
  Map<String, int> get inventory => _inventory;
  @override
  set inventory(Map<String, int> value) {
    _inventory = value;
  }

  @override
  Either<String, String> brew(String coffeeName) {
    return Right('Train Staff: Here is your $coffeeName');
  }
}
