abstract class CoffeeHouseRepositoryContract {
  get coffeeHouseName;

  String brew(String coffeeName);
}

class StarbucksChainRepository extends CoffeeHouseRepositoryContract {
  @override
  get coffeeHouseName => 'Starbucks';

  @override
  String brew(String coffeeName) {
    return 'Starbucks Employer: $coffeeName is ready!';
  }
}

class TrainKioskRepository extends CoffeeHouseRepositoryContract {
  @override
  get coffeeHouseName => 'Kiosk';

  @override
  String brew(String coffeeName) {
    return 'Train Staff: Here is your $coffeeName';
  }
}
