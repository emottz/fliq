import 'package:shared_preferences/shared_preferences.dart';

class HeartsService {
  static const int maxHearts = 20;
  static const int lessonCost = 5;
  static const int examCost = 10;

  static const _keyCount = 'hearts_count';
  static const _keyResetTime = 'hearts_reset_time';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Mevcut kalp sayısı ve dolum zamanını döndürür.
  /// Dolum zamanı geçmişse otomatik 20'ye tamamlar.
  Future<({int count, DateTime? resetTime})> getState() async {
    final p = await _prefs;

    final resetStr = p.getString(_keyResetTime);
    if (resetStr != null) {
      final resetTime = DateTime.tryParse(resetStr);
      if (resetTime != null && DateTime.now().isAfter(resetTime)) {
        await p.setInt(_keyCount, maxHearts);
        await p.remove(_keyResetTime);
        return (count: maxHearts, resetTime: null);
      }
      final count = p.getInt(_keyCount) ?? maxHearts;
      return (count: count, resetTime: resetTime);
    }

    final count = p.getInt(_keyCount) ?? maxHearts;
    return (count: count, resetTime: null);
  }

  /// Yeterli kalp varsa düşer ve true döner, yoksa false.
  Future<bool> useHearts(int cost) async {
    final state = await getState();
    if (state.count < cost) return false;

    final p = await _prefs;
    final newCount = state.count - cost;
    await p.setInt(_keyCount, newCount);

    // Kalpler bittiyse 24 saat sonra dolum zamanını ayarla
    if (newCount <= 0 && p.getString(_keyResetTime) == null) {
      final resetTime = DateTime.now().add(const Duration(hours: 24));
      await p.setString(_keyResetTime, resetTime.toIso8601String());
    }

    return true;
  }

  Future<bool> hasEnough(int cost) async {
    final state = await getState();
    return state.count >= cost;
  }

  /// Kalplere [amount] ekler. Max [maxHearts]'ı geçemez.
  /// Eğer dolu olursa dolum zamanını temizler.
  Future<void> addHearts(int amount) async {
    final state = await getState();
    final p = await _prefs;
    final newCount = (state.count + amount).clamp(0, maxHearts);
    await p.setInt(_keyCount, newCount);
    if (newCount >= maxHearts) {
      await p.remove(_keyResetTime);
    }
  }
}
