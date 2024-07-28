import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Customcache extends CacheManager {
  static const key = "customCache";

  static Customcache? _instance;

  factory Customcache() {
    if (_instance == null) {
      _instance ??= Customcache._();
    }
    return _instance!;
  }

  Customcache._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 100,
        ));
}
