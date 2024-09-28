part of 'brew_coffee.dart';

sealed class BrewCoffeeErrors extends BrewCoffeeError implements Equatable {
  BrewCoffeeErrors() : super('');
}

class BrewCoffeeMissing extends BrewCoffeeErrors {
  BrewCoffeeMissing();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class BrewCoffeeStock extends BrewCoffeeErrors {
  BrewCoffeeStock();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class BrewCoffeeClosed extends BrewCoffeeErrors {
  BrewCoffeeClosed();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}
