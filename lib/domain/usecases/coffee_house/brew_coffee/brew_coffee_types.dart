part of 'brew_coffee.dart';

typedef BrewCoffeeSuccess = Right<String, Unit>;
typedef BrewCoffeeError = Left<String, Unit>;

typedef BrewCoffeeResult = Either<String, Unit>;

extension on BrewCoffeeResult {
  // void get run => fold((_) {}, (_) {});
}
