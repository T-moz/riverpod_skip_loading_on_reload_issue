import 'dart:math';

import 'package:riverpod/riverpod.dart';

final randomDoubleProvider = Provider<double>(
  (ref) => Random().nextDouble(),
);

final labelProvider = FutureProvider<String>(
  (ref) async {
    final randomDouble = ref.watch(randomDoubleProvider);
    await Future.delayed(Duration(milliseconds: 100));

    return 'double is $randomDouble';
  },
  dependencies: [randomDoubleProvider],
);

final randomDoubleStreamProvider = StreamProvider<double>(
  (ref) async* {
    for (var i = 0; i <= 2; i++) {
      await Future.delayed(Duration(milliseconds: 100));
      yield Random().nextDouble();
    }
  },
);

final labelStreamProvider = StreamProvider<String>(
  (ref) {
    final randomDoubleStream = ref.watch(randomDoubleStreamProvider.stream);
    return randomDoubleStream
        .asyncMap((randomDouble) => 'double is $randomDouble');
  },
  dependencies: [randomDoubleStreamProvider.stream],
);

final labelFutureProvider = FutureProvider<String>(
  (ref) async {
    final randomDouble = await ref.watch(randomDoubleStreamProvider.future);
    return 'double is $randomDouble';
  },
  dependencies: [randomDoubleStreamProvider.future],
);
