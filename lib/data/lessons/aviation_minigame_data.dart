/// Havacılık teknik terimleri — mini-game'ler için kullanılır.
class MiniGameTerm {
  final String term;        // İngilizce terim (büyük harf)
  final String definition;  // Türkçe tanım
  final String category;    // Kategori

  const MiniGameTerm({
    required this.term,
    required this.definition,
    required this.category,
  });
}

class AviationMiniGameData {
  AviationMiniGameData._();

  static const List<MiniGameTerm> all = [
    // ── Uçuş mekaniği ───────────────────────────────────────────────────────
    MiniGameTerm(term: 'THRUST',      definition: 'İtki — motorn öne doğru yarattığı kuvvet',         category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'DRAG',        definition: 'Sürtünme — uçuşa karşı koyulan hava direnci',       category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'LIFT',        definition: 'Kaldırma kuvveti — kanadın yukarı iten aerodinamik kuvveti', category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'STALL',       definition: 'Çıkış kaybolması — kritik hücum açısının aşılması', category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'PITCH',       definition: 'Yunuslama — uçağın burun yukarı/aşağı hareketi',   category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'ROLL',        definition: 'Yatış — uçağın boyuna eksen etrafında dönmesi',     category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'YAW',         definition: 'Sapma — uçağın düşey eksen etrafında dönmesi',      category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'BANK',        definition: 'Viraç açısı — dönüş sırasındaki kanat eğikliği',   category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'GLIDE',       definition: 'Süzülme — motor kestikten sonra planlı iniş',       category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'DIHEDRAL',    definition: 'Kanat dikliği — iki kanadın yatay açısı',           category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'INERTIA',     definition: 'Atalet — cismin hareket durumunu koruma eğilimi',   category: 'Uçuş Mekaniği'),
    MiniGameTerm(term: 'VORTEX',      definition: 'Girdap — kanat ucundan oluşan hava döngüsü',        category: 'Uçuş Mekaniği'),

    // ── Kontrol yüzeyleri ────────────────────────────────────────────────────
    MiniGameTerm(term: 'AILERON',     definition: 'Yatış kumanda yüzeyi — roll hareketini kontrol eder', category: 'Kontrol Yüzeyleri'),
    MiniGameTerm(term: 'RUDDER',      definition: 'Dümen — yaw hareketini kontrol eden dikey yüzey',   category: 'Kontrol Yüzeyleri'),
    MiniGameTerm(term: 'ELEVATOR',    definition: 'Yunuslama yüzeyi — pitch hareketini kontrol eder',  category: 'Kontrol Yüzeyleri'),
    MiniGameTerm(term: 'FLAP',        definition: 'Flap — kalkış ve inişte kaldırma artıran yüzey',    category: 'Kontrol Yüzeyleri'),
    MiniGameTerm(term: 'SLAT',        definition: 'Slat — kanadın ön kenar uzantısı, alçak hızda kullanılır', category: 'Kontrol Yüzeyleri'),
    MiniGameTerm(term: 'SPOILER',     definition: 'Spoiler — kaldırmayı azaltan ve fren görevi yapan yüzey', category: 'Kontrol Yüzeyleri'),
    MiniGameTerm(term: 'TRIM',        definition: 'Trim — sürekli kumanda baskısını sıfırlayan ayar',  category: 'Kontrol Yüzeyleri'),
    MiniGameTerm(term: 'STABILIZER',  definition: 'Yatay dengeleyici — kuyruk yatay sabit yüzeyi',    category: 'Kontrol Yüzeyleri'),

    // ── Yapı ─────────────────────────────────────────────────────────────────
    MiniGameTerm(term: 'FUSELAGE',    definition: 'Gövde — uçağın merkez bölümü, kabin ve kargo',     category: 'Yapı'),
    MiniGameTerm(term: 'NACELLE',     definition: 'Gondol — motor kılıfı ve destek yapısı',            category: 'Yapı'),
    MiniGameTerm(term: 'EMPENNAGE',   definition: 'Kuyruk grubu — dikey ve yatay kuyruk yüzeyleri',   category: 'Yapı'),
    MiniGameTerm(term: 'STRUT',       definition: 'İniş takımı bacağı — amortisör görevi yapan dikey eleman', category: 'Yapı'),
    MiniGameTerm(term: 'WINGLET',     definition: 'Kanat ucu — yakıt verimliliğini artıran kanat son bölümü', category: 'Yapı'),
    MiniGameTerm(term: 'RADOME',      definition: 'Radome — hava radar antenini koruyan kubbe kapak', category: 'Yapı'),
    MiniGameTerm(term: 'BULKHEAD',    definition: 'Bölme duvarı — gövde yapısal destek perdesi',      category: 'Yapı'),
    MiniGameTerm(term: 'LONGERON',    definition: 'Longeron — gövde boyunca uzanan ana yapısal kirişler', category: 'Yapı'),

    // ── Aletler ve sistemler ─────────────────────────────────────────────────
    MiniGameTerm(term: 'ALTIMETER',   definition: 'Yükseklik ölçer — barometrik basınca göre irtifa gösterir', category: 'Sistemler'),
    MiniGameTerm(term: 'PITOT',       definition: 'Pitot tüpü — hava hızı ölçümünde kullanılan tüp', category: 'Sistemler'),
    MiniGameTerm(term: 'TRANSPONDER', definition: 'Transponder — radar sorgusuna otomatik yanıt veren cihaz', category: 'Sistemler'),
    MiniGameTerm(term: 'THROTTLE',    definition: 'Gaz kolu — motor gücünü ayarlayan kumanda',         category: 'Sistemler'),
    MiniGameTerm(term: 'BEACON',      definition: 'İşaret lambası — dönen kırmızı/beyaz tanımlama ışığı', category: 'Sistemler'),
    MiniGameTerm(term: 'TCAS',        definition: 'Çarpışma önleme sistemi — trafiği tespit eder ve kaçınma tavsiyesi verir', category: 'Sistemler'),
    MiniGameTerm(term: 'APU',         definition: 'Yardımcı güç birimi — yerde motorlar çalışmadan enerji sağlar', category: 'Sistemler'),
    MiniGameTerm(term: 'FMC',         definition: 'Uçuş yönetim bilgisayarı — rota ve performans hesaplar', category: 'Sistemler'),
    MiniGameTerm(term: 'ACARS',       definition: 'Uçuş veri iletişim sistemi — ses dışı mesaj sistemi', category: 'Sistemler'),
    MiniGameTerm(term: 'SELCAL',      definition: 'Seçici çağrı sistemi — belirli bir uçağı seslendiren telsiz alarmı', category: 'Sistemler'),
    MiniGameTerm(term: 'GPWS',        definition: 'Yer yakınlık uyarı sistemi — yer çarpışmasını önler', category: 'Sistemler'),

    // ── Navigasyon ───────────────────────────────────────────────────────────
    MiniGameTerm(term: 'HEADING',     definition: 'Seyir açısı — uçağın manyetik kuzeyden ölçülen yönü', category: 'Navigasyon'),
    MiniGameTerm(term: 'BEARING',     definition: 'İstikameti — bir noktaya olan manyetik yön',         category: 'Navigasyon'),
    MiniGameTerm(term: 'VOR',         definition: 'VHF Yön Bulma Radyosu — yer istasyonu bazlı navigasyon', category: 'Navigasyon'),
    MiniGameTerm(term: 'ILS',         definition: 'Aletli İniş Sistemi — hassas yaklaşma kılavuz ışını', category: 'Navigasyon'),
    MiniGameTerm(term: 'DME',         definition: 'Mesafe Ölçüm Donanımı — yer istasyonuna uzaklık verir', category: 'Navigasyon'),
    MiniGameTerm(term: 'WAYPOINT',    definition: 'Ara nokta — navigasyon rotasındaki coğrafi koordinat', category: 'Navigasyon'),
    MiniGameTerm(term: 'LATITUDE',    definition: 'Enlem — kuzey/güney konumu derece cinsinden',        category: 'Navigasyon'),
    MiniGameTerm(term: 'LONGITUDE',   definition: 'Boylam — doğu/batı konumu derece cinsinden',         category: 'Navigasyon'),
    MiniGameTerm(term: 'RADIAL',      definition: 'Radyal — VOR istasyonundan manyetik olarak uzanan çizgi', category: 'Navigasyon'),

    // ── Hava trafiği ─────────────────────────────────────────────────────────
    MiniGameTerm(term: 'SQUAWK',      definition: 'Transponder kodu — ATC tarafından atanan 4 haneli kod', category: 'Hava Trafiği'),
    MiniGameTerm(term: 'ATIS',        definition: 'Otomatik Terminal Bilgi Servisi — sürekli yayın bilgi kaydı', category: 'Hava Trafiği'),
    MiniGameTerm(term: 'METAR',       definition: 'Meteoroloji raporu — belirli saatlerde yayımlanan hava durumu', category: 'Hava Trafiği'),
    MiniGameTerm(term: 'NOTAM',       definition: 'Havacılara duyuru — operasyonel öneme sahip bildirim', category: 'Hava Trafiği'),
    MiniGameTerm(term: 'MAYDAY',      definition: 'Uluslararası acil çağrı — can tehlikesi bildirimi',   category: 'Hava Trafiği'),
    MiniGameTerm(term: 'VECTOR',      definition: 'Radar yönlendirmesi — ATC tarafından verilen seyir açısı', category: 'Hava Trafiği'),
    MiniGameTerm(term: 'CLEARANCE',   definition: 'İzin — ATC tarafından verilen yetkilendirme',         category: 'Hava Trafiği'),
    MiniGameTerm(term: 'HANDOFF',     definition: 'Devre aktarımı — uçağı bir ATC sektöründen diğerine geçirme', category: 'Hava Trafiği'),

    // ── Havalimanı & operasyon ───────────────────────────────────────────────
    MiniGameTerm(term: 'RUNWAY',      definition: 'Pist — kalkış ve iniş yapılan hazırlanmış yüzey',    category: 'Operasyon'),
    MiniGameTerm(term: 'TAXIWAY',     definition: 'Taksi yolu — uçakların pist ile apron arasında hareket ettiği yol', category: 'Operasyon'),
    MiniGameTerm(term: 'APRON',       definition: 'Apron — park, yükleme ve bakım için düzenlenmiş alan', category: 'Operasyon'),
    MiniGameTerm(term: 'HANGAR',      definition: 'Hangar — uçakların kapalı bakım ve depo alanı',       category: 'Operasyon'),
    MiniGameTerm(term: 'RAMP',        definition: 'Rampa — apron ile bina arasındaki geçiş alanı',       category: 'Operasyon'),
    MiniGameTerm(term: 'PAYLOAD',     definition: 'Ticari yük — yolcu, bagaj ve kargo toplamı',          category: 'Operasyon'),
    MiniGameTerm(term: 'OVERRUN',     definition: 'Pist aşımı — iniş sırasında pist dışına çıkma',       category: 'Operasyon'),
    MiniGameTerm(term: 'PUSHBACK',    definition: 'Geri itme — uçağı geri hareket ettiren araç operasyonu', category: 'Operasyon'),

    // ── Meteoroloji ──────────────────────────────────────────────────────────
    MiniGameTerm(term: 'TURBULENCE',  definition: 'Türbülans — düzensiz hava hareketi nedeniyle uçaktaki sarsıntı', category: 'Meteoroloji'),
    MiniGameTerm(term: 'WINDSHEAR',   definition: 'Rüzgar kırılması — kısa mesafede ani hız veya yön değişimi', category: 'Meteoroloji'),
    MiniGameTerm(term: 'CEILING',     definition: 'Tavan — yer ile en alçak bulutuların yüksekliği',     category: 'Meteoroloji'),
    MiniGameTerm(term: 'ICING',       definition: 'Buzlanma — uçak yüzeylerinde buz oluşumu',            category: 'Meteoroloji'),
    MiniGameTerm(term: 'MICROBURST',  definition: 'Mikropatlama — yerden yukarıya baskı yapan ani şiddetli düşey rüzgar', category: 'Meteoroloji'),
    MiniGameTerm(term: 'TAILWIND',    definition: 'Kuyruk rüzgarı — uçuş yönünden arkadan esen rüzgar', category: 'Meteoroloji'),
    MiniGameTerm(term: 'HEADWIND',    definition: 'Baş rüzgarı — uçuş yönüne karşıdan esen rüzgar',     category: 'Meteoroloji'),
    MiniGameTerm(term: 'CROSSWIND',   definition: 'Yan rüzgar — pist eksenine dik açıdan esen rüzgar',  category: 'Meteoroloji'),
    MiniGameTerm(term: 'GUST',        definition: 'Ani rüzgar artışı — kısa süreli hız patlaması',       category: 'Meteoroloji'),
    MiniGameTerm(term: 'DENSITY',     definition: 'Yoğunluk yüksekliği — sıcaklık ve basınca göre hesaplanan efektif irtifa', category: 'Meteoroloji'),

    // ── Performans ───────────────────────────────────────────────────────────
    MiniGameTerm(term: 'KNOT',        definition: 'Deniz mili/saat — havacılıkta standart hız birimi',  category: 'Performans'),
    MiniGameTerm(term: 'MACH',        definition: 'Mach sayısı — sesin hızına oranla ölçülen sürat',    category: 'Performans'),
    MiniGameTerm(term: 'QNH',         definition: 'QNH — deniz seviyesi standart basıncına göre ayarlı irtifa ayarı', category: 'Performans'),
    MiniGameTerm(term: 'QFE',         definition: 'QFE — aerodrома basıncına göre ayarlanan irtifa ayarı', category: 'Performans'),
    MiniGameTerm(term: 'MARGIN',      definition: 'Güvenlik payı — minimum gereksinimle mevcut kapasite farkı', category: 'Performans'),
    MiniGameTerm(term: 'MIXTURE',     definition: 'Yakıt karışımı — yakıt/hava oranı ayarı',            category: 'Performans'),
    MiniGameTerm(term: 'SECTOR',      definition: 'Sektör — iki kalkış/iniş noktası arasındaki uçuş bölümü', category: 'Performans'),
  ];
}
