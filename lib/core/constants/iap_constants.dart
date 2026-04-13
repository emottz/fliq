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

  // ── Yıllık abonelikler ────────────────────────────────────────────────────
  static const String pilotAnnual       = 'fliq_pilot_annual';
  static const String cabinAnnual       = 'fliq_cabin_annual';
  static const String amtAnnual         = 'fliq_amt_annual';
  static const String studentAnnual     = 'fliq_student_annual';

  /// Rol + periyot → product ID
  static String productId({required String roleKey, required bool annual}) {
    return switch ('${roleKey}_${annual ? 'y' : 'm'}') {
      'pilot_y'       => pilotAnnual,
      'pilot_m'       => pilotMonthly,
      'cabin_crew_y'  => cabinAnnual,
      'cabin_crew_m'  => cabinMonthly,
      'amt_y'         => amtAnnual,
      'amt_m'         => amtMonthly,
      'student_y'     => studentAnnual,
      'student_m'     => studentMonthly,
      _               => studentMonthly,
    };
  }

  /// Tüm ürün ID seti — queryProductDetails için
  static Set<String> get allProductIds => {
    pilotMonthly, pilotAnnual,
    cabinMonthly, cabinAnnual,
    amtMonthly,   amtAnnual,
    studentMonthly, studentAnnual,
  };
}
