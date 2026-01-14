import '../../app.dart';

base class CustomProviderObservers extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    MyAppProviders.addProvider(context);
    super.didAddProvider(context, value);
  }
}

class MyAppProviders {
  MyAppProviders._();

  static final List _neglectProviders = [
    StateNotifierProvider<StateNotifier, State>
  ];
  static final List<ProviderObserverContext> _providers = [];

  static void addProvider(ProviderObserverContext context) {
    if (_neglectProviders.contains(context.provider.runtimeType)) return;
    _providers.add(context);
  }

  static Future<void> invalidateAllProviders(Ref ref) async {
    for (final provider in _providers) {
      ref.invalidate(provider.provider);
    }

    _providers.clear();
  }
}
