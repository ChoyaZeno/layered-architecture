import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layered_architecture/presentation/blocs/wallet/wallet_bloc.dart';

void main() {
  group('WalletBloc', () {
    late WalletBloc walletBloc;

    setUp(() {
      walletBloc = WalletBloc();
    });

    tearDown(() {
      walletBloc.close();
    });

    test('initial state is WalletPure', () {
      expect(walletBloc.state, equals(const WalletPure()));
    });

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with updated amount after debounce duration',
      build: () => walletBloc,
      act: (bloc) {
        bloc.add(const WalletUpdate(amount: ''));
      },
      wait: WalletBloc.debounce,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with updated amount after max emit duration',
      build: () => walletBloc,
      act: (bloc) {
        bloc.add(const WalletUpdate(amount: ''));
        Future.delayed(const Duration(milliseconds: 300), () {
          bloc.add(const WalletUpdate(amount: ''));
        });
      },
      wait: WalletBloc.maxEmit + WalletBloc.debounce,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
        isA<WalletDirty>().having((state) => state.amount, 'amount', 200),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with cumulative amount after multiple updates within max emit duration',
      build: () => walletBloc,
      act: (bloc) {
        bloc.add(const WalletUpdate(amount: ''));
        Future.delayed(const Duration(milliseconds: 100), () {
          bloc.add(const WalletUpdate(amount: ''));
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          bloc.add(const WalletUpdate(amount: ''));
        });
      },
      wait: WalletBloc.maxEmit,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with cumulative amount after events spaced 500ms apart',
      build: () => walletBloc,
      act: (bloc) {
        bloc.add(const WalletUpdate(amount: ''));
        Future.delayed(const Duration(milliseconds: 500), () {
          bloc.add(const WalletUpdate(amount: ''));
        });
      },
      wait: WalletBloc.maxEmit + WalletBloc.maxEmit,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
        isA<WalletDirty>().having((state) => state.amount, 'amount', 200),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with cumulative amounts after a complex sequence of events',
      build: () => walletBloc,
      act: (bloc) {
        bloc.add(const WalletUpdate(amount: ''));
        Future.delayed(
          const Duration(milliseconds: 100),
          () => bloc.add(const WalletUpdate(amount: '')),
        );
        Future.delayed(
          const Duration(milliseconds: 250),
          () => bloc.add(const WalletUpdate(amount: '')),
        );
        // State should emit at 500ms due to debounce
        Future.delayed(
          const Duration(milliseconds: 600),
          () => bloc.add(const WalletUpdate(amount: '')),
        );
        Future.delayed(
          const Duration(milliseconds: 700),
          () => bloc.add(const WalletUpdate(amount: '')),
        );
        // State should emit at 900ms due to debounce
        Future.delayed(
          const Duration(milliseconds: 1000),
          () => bloc.add(const WalletUpdate(amount: '')),
        );
        // State should emit at 1200ms due to debounce
      },
      wait: WalletBloc.maxEmit * 2 + WalletBloc.debounce,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
        isA<WalletDirty>().having((state) => state.amount, 'amount', 200),
        isA<WalletDirty>().having((state) => state.amount, 'amount', 300),
      ],
    );
  });
}
