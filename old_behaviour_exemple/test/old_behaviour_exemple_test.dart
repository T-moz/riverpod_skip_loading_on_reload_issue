import 'package:old_behaviour_exemple/old_behaviour_exemple.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  /// The two providers are dependent like this:
  ///
  /// ┌────────────────────────┐
  /// │        Provider        │
  /// │                        │
  /// │                        │
  /// │      randomDouble      │
  /// │                        │
  /// └───────────┬────────────┘
  ///             │
  ///             │
  ///             │
  ///             │
  ///             │
  /// ┌───────────▼────────────┐
  /// │     FutureProvider     │
  /// │                        │
  /// │                        │
  /// │                        │
  /// │         label          │
  /// │                        │
  /// └────────────────────────┘
  ///
  /// * Refreshing is when the second provider is `refreshed`.
  /// * Reloading is when the first provider is `refreshed`.
  test('Refreshind and realoading behave the same', () async {
    // Instanciate two counters
    int asyncLoadingCountWhenRefresh = 0;
    int asyncLoadingCountWhenReload = 0;

    // Instanciate two containers
    final containerForRefresh = ProviderContainer();
    final containerForReload = ProviderContainer();

    containerForRefresh.listen(labelProvider, (previous, next) {
      if (next is AsyncLoading) asyncLoadingCountWhenRefresh += 1;
    }, fireImmediately: true);

    containerForReload.listen(labelProvider, (previous, next) {
      if (next is AsyncLoading) asyncLoadingCountWhenReload += 1;
    }, fireImmediately: true);

    // Read the future provider
    await containerForRefresh.read(labelProvider.future);
    await containerForReload.read(labelProvider.future);

    // Refresh
    containerForRefresh.refresh(labelProvider);
    // Reload
    containerForReload.refresh(randomDoubleProvider);

    // Read the future provider again
    await containerForRefresh.read(labelProvider.future);
    await containerForReload.read(labelProvider.future);

    // Expect behaviour (number of `AsyncLoading` emmited) to be the same
    expect(asyncLoadingCountWhenRefresh, asyncLoadingCountWhenReload);
  });

  /// The three providers are dependent like this:
  ///
  ///                ┌─────────────────────┐
  ///                │    StreamProvider   │
  ///                │                     │
  ///           ┌────┤                     ├───┐
  ///           │    │     randomDouble    │   │
  ///           │    │                     │   │
  ///           │    └─────────────────────┘   │
  ///           │                              │
  ///           │                              │
  ///           │                              │
  ///           │                              │
  ///           │                              │
  /// ┌─────────▼──────────┐        ┌──────────▼─────────┐
  /// │   FutureProvider   │        │   StreamProvider   │
  /// │                    │        │                    │
  /// │                    │        │                    │
  /// │                    │        │                    │
  /// │       label        │        │        label       │
  /// │                    │        │                    │
  /// └────────────────────┘        └────────────────────┘
  test('Stream and Future provider has same behaviour', () async {
    // Instanciate two counters
    int asyncLoadingCountFromStreamProvider = 0;
    int asyncLoadingCountFromFutureProvider = 0;

    // Instanciate the container
    final container = ProviderContainer();

    container.listen(labelStreamProvider, (previous, next) {
      if (next is AsyncLoading) asyncLoadingCountFromStreamProvider += 1;
    }, fireImmediately: true);
    container.listen(labelFutureProvider, (previous, next) {
      if (next is AsyncLoading) asyncLoadingCountFromFutureProvider += 1;
    }, fireImmediately: true);

    // Read the future and stream providers
    await container.read(labelStreamProvider.future);
    await container.read(labelFutureProvider.future);

    // Await for a new random number
    await Future.delayed(Duration(milliseconds: 150));

    // Read the future and stream providers again
    await container.read(labelStreamProvider.future);
    await container.read(labelFutureProvider.future);

    // Expect behaviour of stream and future providers (number of `AsyncLoading`
    // emmited) to be the same.
    expect(
      asyncLoadingCountFromStreamProvider,
      asyncLoadingCountFromFutureProvider,
    );
  });
}
