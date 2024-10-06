import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layered_architecture/presentation/blocs/wallet/wallet_bloc.dart';

import 'logging_bloc.dart';

void main() {
  group('WalletBloc', () {
    late WalletBloc walletBloc;

    const debounceDuration = WalletBloc.debounce;
    const maxEmitDuration = WalletBloc.maxEmit;
    const delay100ms = Duration(milliseconds: 100);
    const delay150ms = Duration(milliseconds: 150);
    const delay300ms = Duration(milliseconds: 300);
    const delay400ms = Duration(milliseconds: 400);
    const delay500ms = Duration(milliseconds: 500);

    setUp(() {
      Bloc.observer = LoggingBlocObserver(
        logValues: (currentState, nextState) {
          final currentAmount =
              currentState is WalletState ? currentState.amount : 'unknown';
          final nextAmount =
              nextState is WalletState ? nextState.amount : 'unknown';
          return '$currentAmount => $nextAmount';
        },
      );

      walletBloc = WalletBloc();
      LoggingBlocObserver.startTime = DateTime.now().millisecondsSinceEpoch;
    });

    tearDown(() {
      walletBloc.close();
    });

    test('initial state is WalletPure', () {
      expect(walletBloc.state, equals(const WalletPure()));
    });

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with amount 100 after debounce duration',
      build: () => walletBloc,
      act: (bloc) => bloc.add(const WalletUpdate(amount: '')), // State emission at 200ms
      wait: debounceDuration,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with amount 200 after max emit duration with intermediate event',
      build: () => walletBloc,
      act: (bloc) async {
        bloc.add(const WalletUpdate(amount: '')); // State emission at 200ms
        await Future.delayed(delay300ms);
        bloc.add(const WalletUpdate(amount: '')); // State emission at 500ms
      },
      wait: maxEmitDuration + debounceDuration,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
        isA<WalletDirty>().having((state) => state.amount, 'amount', 200),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with amount 100 after multiple updates within max emit duration',
      build: () => walletBloc,
      act: (bloc) async {
        bloc.add(const WalletUpdate(amount: ''));
        await Future.delayed(delay100ms);
        bloc.add(const WalletUpdate(amount: ''));
        await Future.delayed(delay100ms);
        bloc.add(const WalletUpdate(amount: '')); // State emission at 400ms
      },
      wait: maxEmitDuration,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with amount 200 after events spaced 500ms apart',
      build: () => walletBloc,
      act: (bloc) async {
        bloc.add(const WalletUpdate(amount: '')); // State emission at 200ms
        await Future.delayed(delay500ms);
        bloc.add(const WalletUpdate(amount: '')); // State emission at 700ms
      },
      wait: maxEmitDuration + debounceDuration,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
        isA<WalletDirty>().having((state) => state.amount, 'amount', 200),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletDirty] with cumulative amounts after a complex sequence of events',
      build: () => walletBloc,
      act: (bloc) async {
        bloc.add(const WalletUpdate(amount: ''));
        await Future.delayed(delay100ms);
        bloc.add(const WalletUpdate(amount: ''));
        await Future.delayed(delay150ms);
        bloc.add(const WalletUpdate(amount: '')); // State emission at 450ms
        await Future.delayed(delay400ms);
        bloc.add(const WalletUpdate(amount: ''));
        await Future.delayed(delay100ms);
        bloc.add(const WalletUpdate(amount: '')); // State emission at 950ms
        await Future.delayed(delay300ms);
        bloc.add(const WalletUpdate(amount: '')); // State emission at 1250ms
      },
      wait: maxEmitDuration * 2 + debounceDuration,
      expect: () => [
        isA<WalletDirty>().having((state) => state.amount, 'amount', 100),
        isA<WalletDirty>().having((state) => state.amount, 'amount', 200),
        isA<WalletDirty>().having((state) => state.amount, 'amount', 300),
      ],
    );
  });
}
