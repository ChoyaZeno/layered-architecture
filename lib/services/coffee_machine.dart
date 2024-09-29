class CoffeeMachine {
  int _dispenseCount = 0;
  final int _maxDispenses = 20;

  Future<bool> dispense(String flavor) async {
    if (_dispenseCount >= _maxDispenses) {
      print('Machine needs to be refilled.');
      return false;
    }
    // Simulate the dispensing process
    print('Dispensing $flavor coffee...');
    await Future.delayed(const Duration(seconds: 1));
    _dispenseCount++;
    print(
        '$flavor coffee dispensed. Dispenses left: ${_maxDispenses - _dispenseCount}');
    return true;
  }

  void refill() {
    _dispenseCount = 0;
    print('Machine refilled.');
  }
}
