import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static final BaseCacheManager instance = CacheManager(
    Config(
      'customCatCache',
      stalePeriod: const Duration(days: 15),
      maxNrOfCacheObjects: 150,
    ),
  );
}
