import 'package:shared_preferences/shared_preferences.dart';

class HeartsService {
  static const int maxHearts = 20;
  static const int lessonCost = 5;
  static const int miniGameCost = 5;
  static const int examCost = 10;
  static const int learnCost = 1;
  static const int regenAmount = 5;
  static const Duration regenInterval = Duration(minutes: 20);

  static const _keyCount = 'hearts_count';
  static const _keyRegenTime = 'hearts_regen_time';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Mevcut kalp sayısı ve bir sonraki +5 zamanını döndürür.
  /// Geçmiş regen dönemleri varsa otomatik uygular.
  Future<({int count, DateTime? resetTime})> getState() async {
    final p = await _prefs;
    int count = p.getInt(_keyCount) ?? maxHearts;

    final regenStr = p.getString(_keyRegenTime);
    if (regenStr != null) {
      DateTime? regenTime = DateTime.tryParse(regenStr);
      // Geçmiş tüm 20-dakikalık dönemleri uygula
      while (regenTime != null && DateTime.now().isAfter(regenTime) && count < maxHearts) {
        count = (count + regenAmount).clamp(0, maxHearts);
        await p.setInt(_keyCount, count);
        if (count >= maxHearts) {
          await p.remove(_keyRegenTime);
          regenTime = null;
        } else {
          regenTime = regenTime.add(regenInterval);
          await p.setString(_keyRegenTime, regenTime.toIso8601String());
        }
      }
      if (count >= maxHearts) {
        return (count: count, resetTime: null);
      }
      return (count: count, resetTime: regenTime);
    }

    return (count: count, resetTime: null);
  }

  /// Yeterli kalp varsa düşer ve true döner, yoksa false.
  Future<bool> useHearts(int cost) async {
    final state = await getState();
    if (state.count < cost) return false;

    final p = await _prefs;
    final newCount = state.count - cost;
    await p.setInt(_keyCount, newCount);

    // Maks altında ve zamanlayıcı yoksa 20 dakika sonraya ayarla
    if (newCount < maxHearts && p.getString(_keyRegenTime) == null) {
      final regenTime = DateTime.now().add(regenInterval);
      await p.setString(_keyRegenTime, regenTime.toIso8601String());
    }

    return true;
  }

  Future<bool> hasEnough(int cost) async {
    final state = await getState();
    return state.count >= cost;
  }

  /// Kalplere [amount] ekler. Max [maxHearts]'ı geçemez.
  Future<void> addHearts(int amount) async {
    final state = await getState();
    final p = await _prefs;
    final newCount = (state.count + amount).clamp(0, maxHearts);
    await p.setInt(_keyCount, newCount);
    if (newCount >= maxHearts) {
      await p.remove(_keyRegenTime);
    }
  }
}
