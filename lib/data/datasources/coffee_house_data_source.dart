import 'dart:async';
import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:layered_architecture/data/models/coffee_model.dart';
import 'package:synchronized/synchronized.dart';

abstract class CoffeeHouseDataSourceContract {
  Future<List<CoffeeModel>> getStock();
  Map<String, int> getProductStock();
  Either<String, Unit> updateProduct(String name, int quantity);
  Either<String, Unit> sellCoffee(String name);
  Either<String, Unit> restockCoffee(String name, int quantity);
  Future<Either<String, String>> getMachine();
  Either<String, Unit> releaseMachine(String machine);
}

class CoffeeHouseDataSource implements CoffeeHouseDataSourceContract {
  final Map<String, int> _stock;
  final Map<String, int> _machines;

  final Queue<String> _waitingForMachine = Queue<String>();
  final Queue<String> _freeMachines = Queue<String>();

  final StreamController<String> _releaseMachineStream =
      StreamController<String>.broadcast();

  final Lock _machineLock = Lock();

  CoffeeHouseDataSource(
    this._stock,
    this._machines,
  ) {
    _freeMachines.addAll(_machines.keys);
  }

  @override
  Future<List<CoffeeModel>> getStock() async {
    return _stock.entries
        .map((entry) => CoffeeModel(name: entry.key, quantity: entry.value))
        .toList();
  }

  @override
  Map<String, int> getProductStock() {
    return _stock;
  }

  @override
  Future<Either<String, String>> getMachine() async {
    if (_machines.keys.isEmpty) {
      return const Left('No machines');
    }

    final completer = Completer<Either<String, String>>();

    final id = UniqueKey().toString();

    StreamSubscription<String>? subscription;
    subscription = _releaseMachineStream.stream.listen(
      (key) {
        if (key == id) {
          final machine = _freeMachines.removeFirst();
          subscription?.cancel();
          completer.complete(Right(machine));
        }
      },
      onError: (error) {
        completer.complete(Left('Error: $error'));
      },
    );

    _waitingForMachine.add(id);
    unawaited(checkMachine());

    return completer.future;
  }

  @override
  Either<String, Unit> releaseMachine(String machine) {
    _freeMachines.add(machine);
    unawaited(checkMachine());
    return const Right(unit);
  }

  Future<void> checkMachine() async {
    await _machineLock.synchronized(() {
      if (_freeMachines.isNotEmpty && _waitingForMachine.isNotEmpty) {
        _releaseMachineStream.add(_waitingForMachine.removeFirst());
      }
    });
  }

  @override
  Either<String, Unit> updateProduct(String name, int quantity) {
    if (_stock.containsKey(name) && _stock[name]! - quantity > -1) {
      _stock[name] = _stock[name]! - quantity;
      return const Right(unit);
    }

    return const Left('Not enough product');
  }

  @override
  Either<String, Unit> sellCoffee(String name) {
    if (_stock.containsKey(name) && _stock[name]! > 0) {
      _stock[name] = _stock[name]! - 1;
    }

    return const Right(unit);
  }

  @override
  Either<String, Unit> restockCoffee(String name, int quantity) {
    _stock[name] = (_stock[name] ?? 0) + quantity;
    return const Right(unit);
  }
}
