import 'package:dartz/dartz.dart';
import 'dart:async';

extension EitherWhenComplete<L, R> on Either<L, R> {
  FutureOr<Either<L, R>> foldWithCleanup(
    FutureOr<Either<L, R>> Function(L) ifLeft,
    FutureOr<Either<L, R>> Function(R) ifRight,
    FutureOr<void> Function() cleanup,
  ) async {
    try {
      // return await fold(ifLeft, ifRight);
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

// typedef Concat2<L, R> = Either<L, Tuple2<Either<L, R>, Either<L, R>>>;

// extension EitherConcatenate2<L, R> on Concat2<L, R> {
//   Either<L, R> selectFirst() {
//     return fold(
//       left,
//       (tuple) => tuple.value1,
//     );
//   }

//   Either<L, R> selectSecond() {
//     return fold(
//       left,
//       (tuple) => tuple.value2,
//     );
//   }
// }

// extension EitherConcatenate<L, R> on Either<L, R> {
//   Concat2<L, R> concat(Either<L, R> other) {
//     return right(tuple2(this, other));
//   }
// }
