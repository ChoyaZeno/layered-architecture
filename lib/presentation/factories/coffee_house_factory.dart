import 'package:layered_architecture/data/datasources/coffee_house_data_source.dart';
import 'package:layered_architecture/data/repositories/coffee_house_repository.dart';
import 'package:layered_architecture/domain/repositories/notification_repository.dart';
import 'package:layered_architecture/domain/usecases/coffee_house/brew_coffee/brew_coffee.dart';
import 'package:layered_architecture/presentation/blocs/coffee_house/coffee_house_bloc.dart';

class CoffeeHouseFactory {
  final NotificationRepository notificationRepository;

  CoffeeHouseFactory({
    required this.notificationRepository,
  });

  CoffeeHouseBloc create() {
    // Map<String, int> _inventory = {
    //   'Coffee': 10,
    //   'Espresso': 8,
    //   'Cappucino': 5,
    // };

    final inventory = {
      'Nitro Cold Brew': 9,
      'Pumpkin Spice Latte': 7,
      'Pink Drink': 5,
    };

    final machines = {
      'Normal': 1,
    };

    final coffeeHouseDataSource = CoffeeHouseDataSource(inventory, machines);
    final coffeeHouseRepository =
        StarbucksChainRepository(coffeeHouseDataSource);

    return CoffeeHouseBloc(
      coffeeHouseRepository: coffeeHouseRepository,
      notificationRepository: notificationRepository,
      brewCoffeeUseCase: BrewCoffeeUseCase(
        coffeeHouseRepository: coffeeHouseRepository,
        notificationRepository: notificationRepository,
      ),
      // getStock: GetStock(repository),
      // buyCoffeeMachine: BuyCoffeeMachine(repository, machine),
      // fillCoffeeBeans: FillCoffeeBeans(repository),
    );
  }
}
