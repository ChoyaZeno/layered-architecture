part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {}

class WalletUpdate implements WalletEvent {
  const WalletUpdate({
    required this.amount,
  });

  final String amount;

  @override
  List<Object?> get props => [amount];

  @override
  bool? get stringify => false;
}
