import 'package:equatable/equatable.dart';

sealed class CoffeeHouseEvent extends Equatable {}

class CoffeeHouseOpenStore implements CoffeeHouseEvent {
  const CoffeeHouseOpenStore();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class CoffeeHouseBrewCoffee implements CoffeeHouseEvent {
  const CoffeeHouseBrewCoffee({
    required this.coffee,
  });

  final String coffee;

  @override
  List<Object?> get props => [
        coffee,
      ];

  @override
  bool? get stringify => false;
}
