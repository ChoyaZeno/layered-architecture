import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:layered_architecture/domain/repositories/coffee_house_repository_contract.dart';
import 'package:layered_architecture/domain/repositories/notification_repository.dart';
import 'package:layered_architecture/domain/usecases/coffee_house/take_product_while/take_product_while.dart';
import 'package:layered_architecture/core/utils/either_extensions.dart';

part 'brew_coffee_errors.dart';
part 'brew_coffee_types.dart';

class BrewCoffeeUseCase {
  BrewCoffeeUseCase({
    required CoffeeHouseRepositoryContract coffeeHouseRepository,
    required NotificationRepository notificationRepository,
  })  : _coffeeHouseRepository = coffeeHouseRepository,
        _notificationRepository = notificationRepository;

  final CoffeeHouseRepositoryContract _coffeeHouseRepository;
  final NotificationRepository _notificationRepository;

  Future<BrewCoffeeResult> call(final String coffeeName) async {
    // Randomly close store
    // if (Random().nextInt(3) + 1 > 2) {
    //   _notificationRepository.notify(
    //       '${_coffeeHouseRepository.coffeeHouseName} is closing, end of service!');
    //   // emit(const CoffeeHouseStoreClosed(message: '???'));
    //   return BrewCoffeeClosed();
    // }

    final result = await _coffeeHouseRepository.findMachine();

    return result.fold(Left.new, (machine) {
      final takeProductWhile = TakeProductWhileUseCase(
        coffeeHouseRepository: _coffeeHouseRepository,
      );

      return takeProductWhile
          .call(() => _coffeeHouseRepository.brew(coffeeName), coffeeName, 1)
          .foldWithCleanup(
        Left.new,
        (_) async {
          await Future.delayed(const Duration(seconds: 3));

          _notificationRepository.notify(
            'You were served 1 $coffeeName at ${_coffeeHouseRepository.coffeeHouseName}',
          );

          return const Right(unit);
        },
        () {
          _coffeeHouseRepository.releaseMachine(machine);
        },
      );
    });
  }
}
