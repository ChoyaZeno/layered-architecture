import 'package:dartz/dartz.dart';
import 'package:layered_architecture/data/datasources/coffee_house_data_source.dart';
import 'package:layered_architecture/domain/repositories/coffee_house_repository_contract.dart';

class StarbucksChainRepository extends CoffeeHouseRepositoryContract {
  final CoffeeHouseDataSource dataSource;

  StarbucksChainRepository(this.dataSource);

  @override
  String get coffeeHouseName => 'Starbucks';

  @override
  Map<String, int> get inventory => dataSource.getProductStock();

  @override
  Either<String, Unit> releaseMachine(String machine) {
    return dataSource.releaseMachine(machine);
  }

  @override
  Future<Either<String, String>> findMachine() async {
    final machine = await dataSource.getMachine();
    return machine.bind((machine) {
      return Right(machine);
    });
  }

  @override
  Either<String, String> brew(String coffeeName) {
    return Right('Starbucks Employer: $coffeeName is ready!');
  }

  @override
  Either<String, Unit> updateProduct(String name, int quantity) {
    return dataSource.updateProduct(name, quantity);
  }

  @override
  Either<String, Unit> restock(String name, int quantity) {
    return dataSource.restockCoffee(name, quantity);
  }
}

class TrainKioskRepository extends CoffeeHouseRepositoryContract {
  final CoffeeHouseDataSource dataSource;

  TrainKioskRepository(this.dataSource);

  @override
  String get coffeeHouseName => 'Kiosk';

  @override
  Map<String, int> get inventory => dataSource.getProductStock();

  @override
  Either<String, Unit> releaseMachine(String machine) {
    return dataSource.releaseMachine(machine);
  }

  @override
  Future<Either<String, String>> findMachine() async {
    final machine = await dataSource.getMachine();
    return machine.fold(Left.new, (machine) {
      return Right(machine);
    });
  }

  @override
  Either<String, String> brew(String coffeeName) {
    return Right('Train Staff: Here is your $coffeeName');
  }

  @override
  Either<String, Unit> updateProduct(String name, int quantity) {
    return dataSource.updateProduct(name, quantity);
  }

  @override
  Either<String, Unit> restock(String name, int quantity) {
    return dataSource.restockCoffee(name, quantity);
  }
}
