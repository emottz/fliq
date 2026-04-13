/// Google Play Console'da tanımlanması gereken abonelik ürün ID'leri.
///
/// Google Play Console → Monetize → Subscriptions bölümünde bu ID'leri
/// aynen bu isimlerle oluşturmalısın.
class IapConstants {
  IapConstants._();

  // ── Aylık abonelikler ─────────────────────────────────────────────────────
  static const String pilotMonthly      = 'fliq_pilot_monthly';
  static const String cabinMonthly      = 'fliq_cabin_monthly';
  static const String amtMonthly        = 'fliq_amt_monthly';
  static const String studentMonthly    = 'fliq_student_monthly';

  // ── 4 Aylık abonelikler (%30 indirimli) ──────────────────────────────────
  static const String pilotQuarterly    = 'fliq_pilot_quarterly';
  static const String cabinQuarterly    = 'fliq_cabin_quarterly';
  static const String amtQuarterly      = 'fliq_amt_quarterly';
  static const String studentQuarterly  = 'fliq_student_quarterly';

  /// Rol + periyot → product ID
  /// [annual] parametresi burada "4 aylık" anlamına gelir (UI'dan geliyor)
  static String productId({required String roleKey, required bool annual}) {
    return switch ('${roleKey}_${annual ? 'q' : 'm'}') {
      'pilot_q'       => pilotQuarterly,
      'pilot_m'       => pilotMonthly,
      'cabin_crew_q'  => cabinQuarterly,
      'cabin_crew_m'  => cabinMonthly,
      'amt_q'         => amtQuarterly,
      'amt_m'         => amtMonthly,
      'student_q'     => studentQuarterly,
      'student_m'     => studentMonthly,
      _               => studentMonthly,
    };
  }

  /// Tüm ürün ID seti — queryProductDetails için
  static Set<String> get allProductIds => {
    pilotMonthly,   pilotQuarterly,
    cabinMonthly,   cabinQuarterly,
    amtMonthly,     amtQuarterly,
    studentMonthly, studentQuarterly,
  };
}
