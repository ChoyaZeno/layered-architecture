import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:synchronized/synchronized.dart';

typedef HudMapping = ({int resources, int guests, int money});

class ResourceManager {
  int _resources = 0;
  int _guests = 0;
  int _money = 0;

  final Lock _resourcesLock = Lock();
  final Lock _guestsLock = Lock();
  final Lock _moneyLock = Lock();

  final Random _random = Random();

  ResourceManager() {
    Stream.periodic(const Duration(seconds: 2), (_) async {
      await _addResources(_randomValue(_resources, 20));
      await _addGuests(_randomValue(_guests, 5));
      await _addMoney(_randomValue(_money, 200));
    }).listen((_) {});
  }

  Future<void> _addResources(int amount) async {
    await _resourcesLock.synchronized(() {
      _resources += amount;
    });
  }

  Future<void> _addGuests(int amount) async {
    await _guestsLock.synchronized(() {
      _guests += amount;
    });
  }

  Future<void> _addMoney(int amount) async {
    await _moneyLock.synchronized(() {
      _money += amount;
    });
  }

  Future<Either<String, Unit>> takeMoney(int amount) async {
    return await _moneyLock.synchronized(() async {
      final updatedMoney = _money - amount;

      if (updatedMoney < 0) {
        return const Left('No');
      }

      _money = updatedMoney;
      return const Right(unit);
    });
  }

  int _randomValue(int currentValue, int maxIncrease) {
    // Increase by up to maxIncrease
    int increase = _random.nextInt(maxIncrease + 1);
    // Decrease by up to half of maxIncrease
    int decrease = _random.nextInt((maxIncrease / 2).round() + 1);

    // Randomly choose whether to increase or decrease
    int change = _random.nextBool() ? increase : -decrease;

    return change < 0 ? 0 : change;
  }

  HudMapping getState() {
    return (resources: _resources, guests: _guests, money: _money);
  }
}
