import 'package:dartz/dartz.dart';

abstract class CoffeeHouseRepositoryContract {
  String get coffeeHouseName;

  Map<String, int> get inventory;

  Either<String, String> brew(String coffeeName);
  Future<Either<String, String>> findMachine();
  Either<String, Unit> releaseMachine(String machine);
  Either<String, Unit> restock(String name, int quantity);
  Either<String, Unit> updateProduct(String name, int quantity);
}
