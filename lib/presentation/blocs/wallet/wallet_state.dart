part of 'wallet_bloc.dart';

sealed class WalletState extends Equatable {
  get amount => 0;

  @override
  List<Object?> get props => [
        amount,
      ];

  @override
  bool? get stringify => false;
}

class WalletPure implements WalletState {
  const WalletPure({
    this.amount = 0,
  });

  @override
  final int amount;

  @override
  List<Object?> get props => [
        amount,
      ];

  @override
  bool? get stringify => false;
}

class WalletDirty implements WalletPure {
  const WalletDirty({
    required this.amount,
  });

  @override
  final int amount;

  @override
  List<Object?> get props => [
        amount,
      ];

  @override
  bool? get stringify => false;
}
