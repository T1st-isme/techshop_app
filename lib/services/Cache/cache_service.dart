import 'package:get/get.dart';

class CacheService extends GetxService {
  final _cache = <String, dynamic>{}.obs;

  T? get<T>(String key) {
    return _cache[key] as T?;
  }

  void set<T>(String key, T value) {
    _cache[key] = value;
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }
}
