import 'package:equatable/equatable.dart';

sealed class CoffeeHouseState extends Equatable {}

class CoffeeHouseInitial implements CoffeeHouseState {
  const CoffeeHouseInitial();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class CoffeeHouseLoaded implements CoffeeHouseState {
  const CoffeeHouseLoaded({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => false;
}

sealed class CoffeeHouseError implements CoffeeHouseState {}

class CoffeeHouseBeansDepleted implements CoffeeHouseError {
  const CoffeeHouseBeansDepleted({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => false;
}

class CoffeeHouseStoreClosed implements CoffeeHouseError {
  const CoffeeHouseStoreClosed({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
      ];

  @override
  bool? get stringify => false;
}
