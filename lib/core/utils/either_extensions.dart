import 'package:dartz/dartz.dart';
import 'dart:async';

extension EitherWhenComplete<L, R> on Either<L, R> {
  FutureOr<Either<L, R>> foldWithCleanup(
    FutureOr<Either<L, R>> Function(L) ifLeft,
    FutureOr<Either<L, R>> Function(R) ifRight,
    FutureOr<void> Function() cleanup,
  ) async {
    try {
      return await fold(
        (left) async {
          final result = await ifLeft(left);
          return result;
        },
        (right) async {
          final result = await ifRight(right);
          return result;
        },
      );
    } finally {
      await cleanup();
    }
  }
}
