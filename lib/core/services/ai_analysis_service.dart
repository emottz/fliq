import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_analysis_result.dart';

// Çalıştırma: flutter run --dart-define=GEMINI_KEY=YOUR_KEY
// Build:       flutter build web --dart-define=GEMINI_KEY=YOUR_KEY
const _geminiApiKey = String.fromEnvironment('GEMINI_KEY');

const _model = 'gemini-1.5-flash';
const _baseUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

class AiAnalysisService {
  Future<AiAnalysisResult> analyze({
    required String role,
    required String level,
    required int totalCorrect,
    required int totalQuestions,
    required Map<String, Map<String, int>> categoryResults,
  }) async {
    if (_geminiApiKey.isEmpty) {
      // API key yok — kural tabanlı fallback
      return _fallback(
        role: role,
        level: level,
        totalCorrect: totalCorrect,
        totalQuestions: totalQuestions,
        categoryResults: categoryResults,
      );
    }

    try {
      final prompt = _buildPrompt(
        role: role,
        level: level,
        totalCorrect: totalCorrect,
        totalQuestions: totalQuestions,
        categoryResults: categoryResults,
      );

      final response = await http
          .post(
            Uri.parse('$_baseUrl?key=$_geminiApiKey'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt}
                  ]
                }
              ],
              'generationConfig': {
                'responseMimeType': 'application/json',
                'temperature': 0.4,
              },
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final text = body['candidates'][0]['content']['parts'][0]['text'] as String;
        final json = jsonDecode(text) as Map<String, dynamic>;
        return AiAnalysisResult.fromJson(json);
      }
    } catch (_) {
      // Fall through to rule-based fallback
    }

    return _fallback(
      role: role,
      level: level,
      totalCorrect: totalCorrect,
      totalQuestions: totalQuestions,
      categoryResults: categoryResults,
    );
  }

  String _buildPrompt({
    required String role,
    required String level,
    required int totalCorrect,
    required int totalQuestions,
    required Map<String, Map<String, int>> categoryResults,
  }) {
    final roleLabel = {
      'pilot': 'Ticari Pilot',
      'atc': 'Uçuş Kontrol Memuru',
      'cabin_crew': 'Kabin Ekibi Üyesi',
      'student': 'Havacılık Öğrencisi',
    }[role] ?? 'Havacılık Uzmanı';

    final categoryLines = categoryResults.entries.map((e) {
      final c = e.value['correct'] ?? 0;
      final t = e.value['total'] ?? 0;
      final pct = t > 0 ? (c / t * 100).round() : 0;
      return '- ${e.key.replaceAll('_', ' ')}: $c/$t ($pct%)';
    }).join('\n');

    return '''
You are an expert ICAO aviation English coach. Analyze this student's assessment results and provide personalized coaching.

STUDENT PROFILE:
- Role: $roleLabel
- Determined Level: $level
- Overall Score: $totalCorrect/$totalQuestions

CATEGORY SCORES:
$categoryLines

Respond ONLY with valid JSON matching this exact schema:
{
  "summary": "2-3 cümlelik kişiselleştirilmiş performans özeti; rolünü ve spesifik gözlemleri içermeli",
  "focus_areas": [
    {
      "title": "Kısa teknik konu başlığı (örn: İzinlerde Modal Fiiller)",
      "description": "Eksikliği ve bu rolde neden önemli olduğunu açıklayan 1-2 cümle",
      "priority": "high"
    }
  ],
  "study_tips": [
    "Role ve zayıf alanlara özgü somut çalışma tavsiyesi"
  ]
}

Kurallar:
- focus_areas: 2-4 madde, önceliğe göre sıralı. Yalnızca zayıf kategorileri (yüzde 70 altı) dahil et.
- study_tips: tam olarak 3 madde, pratik ve role özgü
- Tüm metin TÜRKÇE olmalı
- ICAO standartları, havacılık terminolojisi ve role özgü olmalı
- Tüm kategoriler güçlüyse (yüzde 80 üstü), focus_areas mükemmelliği korumaya dair 1 madde içermeli
''';
  }

  AiAnalysisResult _fallback({
    required String role,
    required String level,
    required int totalCorrect,
    required int totalQuestions,
    required Map<String, Map<String, int>> categoryResults,
  }) {
    final weakCats = categoryResults.entries.where((e) {
      final t = e.value['total'] ?? 0;
      final c = e.value['correct'] ?? 0;
      return t > 0 && c / t < 0.7;
    }).map((e) => e.key).toList();

    final roleLabel = {
      'pilot': 'pilot',
      'atc': 'uçuş kontrol memuru',
      'cabin_crew': 'kabin ekibi üyesi',
      'student': 'havacılık öğrencisi',
    }[role] ?? 'havacılık uzmanı';

    final pct = totalQuestions > 0 ? (totalCorrect / totalQuestions * 100).round() : 0;
    String summary;
    if (pct >= 80) {
      summary =
          'Güçlü performans — $level seviyesinde bir $roleLabel için ortalamanın çok üzerindesiniz. '
          'Sonuçlarınız ICAO İngilizce alanlarının büyük çoğunluğuna hakimiyetinizi gösteriyor. '
          'Birkaç spesifik alanda hedefli çalışma sizi sınav hazır duruma getirecektir.';
    } else if (pct >= 50) {
      summary =
          '$level sonucunuz, geliştirilmesi gereken net alanlarla birlikte bir $roleLabel olarak güçlü bir temel gösteriyor. '
          '$totalQuestions sorudan $totalCorrect tanesini doğru yanıtladınız; '
          'bazı kategoriler sınavdan önce odaklanmış dikkat gerektiriyor.';
    } else {
      summary =
          'Bir $roleLabel olarak havacılık İngilizcesi yolculuğunuzun başındasınız. '
          '$totalQuestions sorudan $totalCorrect doğru ile gelişme için önemli bir alan var. '
          'Yapılandırılmış günlük bir çalışma planı sizi sınav hazır seviyeye ilerletecektir.';
    }

    final focusAreas = _buildFallbackFocusAreas(weakCats, role);
    final studyTips = _buildFallbackTips(role, weakCats);

    return AiAnalysisResult(
      summary: summary,
      focusAreas: focusAreas,
      studyTips: studyTips,
    );
  }

  List<AiFocusArea> _buildFallbackFocusAreas(List<String> weakCats, String role) {
    const insights = {
      'grammar': {
        'pilot': (
          'Modal Fiiller & Koşullu Yapılar',
          'Gramer eksiklikleri, takas onaylarını (clearance readback) ve PIREP doğruluğunu doğrudan etkiler. shall/must/should ve operasyonel bağlamlarda if-cümleciklerine odaklan.'
        ),
        'atc': (
          'Talimatlarında Zaman Tutarlılığı',
          'Tutarsız zaman kullanımı, trafik bilgisinde belirsizliğe yol açar. ATC koordinasyon cümlelerinde edilgen çatı ve gelecek zamana odaklan.'
        ),
        'cabin_crew': (
          'Emir Kipi & Modal Yapılar',
          'Güvenlik anonsları kesin emir kipi ve modal gramer gerektirir. Yolcular acil durumlarda net talimatlar almalıdır.'
        ),
        'student': (
          'Temel Havacılık Gramer Kalıpları',
          'Modal fiiller, edilgen yapılar ve koşullu cümleler — ICAO standart havacılık İngilizcesinin üç temel direğini öğren.'
        ),
      },
      'vocabulary': {
        'pilot': (
          'METAR/TAF & NOTAM Terminolojisi',
          'Hava durumu ve NOTAM kelime bilgisi, uçuş öncesi planlama ve uçuş içi karar verme için kritiktir. METAR kısaltmalarını çözme hızını geliştir.'
        ),
        'atc': (
          'SID/STAR & Holding Fraseolojisi',
          'Kalkış ve iniş prosedürlerine ait kesin kelime bilgisi, yoğun trafik ortamlarında yanlış anlaşılmaları önler. ICAO Doc 4444 fraseolojisine odaklan.'
        ),
        'cabin_crew': (
          'Emniyet Ekipmanı Terminolojisi',
          'Emniyet ekipmanı ve prosedürlerinin doğru adları, ICAO uyumu ve yolcu güvenliği yönetimi için vazgeçilmezdir.'
        ),
        'student': (
          'ICAO Temel Havacılık Kelime Bilgisi',
          'ATC fraseolojisi, uçak sistemleri kelime bilgisi ve tüm havacılık rollerinde kullanılan standart ICAO terminolojisiyle temelini oluştur.'
        ),
      },
      'reading': {
        'pilot': (
          'Operasyonel Belge Anlama',
          'Zaman baskısı altında NOTAM ve OFP okumak, sınavlarda yaygın başarısızlık noktasıdır. Yoğun havacılık metinlerinden anahtar verileri 90 saniye içinde çıkarma pratiği yap.'
        ),
        'atc': (
          'Uçuş Planı & Strip Okuma Hızı',
          'ATC strip\'leri ve uçuş planı formatları hızla işlenmesi gereken yoğun bilgi içerir. ICAO uçuş planı formatlarında okuma hızı antrenmanı yap.'
        ),
        'cabin_crew': (
          'Emniyet Prosedürü El Kitapları',
          'İngilizce şirket operasyon el kitapları ve ICAO emniyet belgelerini anlamak, tüm kabin ekibi rolleri için zorunludur. Prosedürel dil kalıplarına odaklan.'
        ),
        'student': (
          'Havacılık Metni Anlama',
          'ICAO İngilizce sınavları yoğun operasyonel metinler içerir. NOTAM, METAR ve AIP alıntılarını okuyarak pratik yap — anahtar bilgiyi hızlı tespit etmeye odaklan.'
        ),
      },
      'translation': {
        'pilot': (
          'Operasyonel Anlam Yorumlama',
          'ATC talimatlarının amacını doğru yorumlamak ve kavramları İngilizce ile çalışma dilin arasında çevirmek, tehlikeli yanlış anlaşılmaları önler.'
        ),
        'atc': (
          'Takas Teyidi & Müsaade Kesinliği',
          'Clearance readback\'teki çeviri hataları, pist ihlallerinin önde gelen nedenidir. Kritik değerleri yorumlamadan her iki yönde de kesinlik pratiği yap.'
        ),
        'student': (
          'Bağlama Dayalı Dil Aktarımı',
          'Kelimesi kelimesine çeviri yerine havacılık metinlerini bağlamda anlamaya odaklan. ICAO dili kalıp tabanlıdır — kalıpları öğren.'
        ),
        'cabin_crew': (
          'Emniyet İletişiminde Doğruluk',
          'Emniyet talimatlarını doğru çevirmek yolcu uyumunu sağlar. Serbest çeviri yerine resmi ICAO emniyet terminolojisine odaklan.'
        ),
      },
      'fill_blanks': {
        'pilot': (
          'Havacılık Kollokasyonları & Sabit İfadeler',
          'ATC iletişimlerinin çoğu sabit kollokasyon kullanır (ör. "cleared for", "report passing"). Bu kalıpların tanınması boşluk doldurma sorularında doğrudan sınanır.'
        ),
        'atc': (
          'Standart Fraseoloji Kalıpları',
          'Boşluk doldurma soruları ICAO Doc 4444 standart ifadelerini sınar. Yaygın müsaade ve talimatların tam söylemini ezberle.'
        ),
        'student': (
          'Havacılık Kollokasyon Kalıpları',
          'Havacılık İngilizcesi, genel İngilizce kurallarına uymayan belirli sözcük birleşimleri kullanır. ICAO eğitim materyallerinden kollokasyonları sistematik biçimde çalış.'
        ),
        'cabin_crew': (
          'Emniyet Anonsu Şablonları',
          'Standart emniyet anonsları sabit şablonlar izler. Her anons türünün tam ifadesini öğren — bunlar boşluk doldurma sınavlarında sıkça çıkar.'
        ),
      },
      'sentence_completion': {
        'pilot': (
          'ATC İletişiminde Söylem Akışı',
          'ATC/pilot alışverişlerinin nasıl yapılandırıldığını anlamak, cümlelerin nasıl tamamlandığını tahmin etmeye yardımcı olur. Standart iletişim dizilerinin mantıksal akışını çalış.'
        ),
        'atc': (
          'Müsaadelerde Mantıksal Sıra',
          'Müsaade cümleleri öngörülebilir mantıksal kalıplar izler. Bu soru türünde hız ve doğruluk kazanmak için kısmi müsaadeleri tamamlama pratiği yap.'
        ),
        'student': (
          'Havacılık Cümle Yapısı',
          'Havacılık İngilizcesi cümleleri belirli yapısal kalıplar izler. ICAO iletişimlerinde bilginin nasıl sıralandığını — önce ne, sonra ne — çalış.'
        ),
        'cabin_crew': (
          'Prosedürel Dil Tamamlama',
          'Emniyet ve hizmet prosedürü cümleleri öngörülebilir yapılar izler. Kalıpları içselleştirmek için resmi kabin ekibi iletişim senaryolarıyla pratik yap.'
        ),
      },
    };

    if (weakCats.isEmpty) {
      return [
        AiFocusArea(
          title: 'Sınav Hazırlığını Koru',
          description:
              'Tüm kategorilerde performansın güçlü. Avantajını korumak ve gerçek sınav baskısını simüle etmek için haftada 2-3 zamanlı deneme sınavı çöz.',
          priority: 'medium',
        ),
      ];
    }

    return weakCats.take(3).map((cat) {
      final catInsights = insights[cat];
      final roleKey = catInsights?.containsKey(role) == true ? role : 'student';
      final info = catInsights?[roleKey] ?? ('${cat.replaceAll('_', ' ')} Becerileri', 'Genel performansını artırmak için bu alana odaklan.');
      return AiFocusArea(
        title: info.$1,
        description: info.$2,
        priority: weakCats.indexOf(cat) == 0 ? 'high' : 'medium',
      );
    }).toList();
  }

  List<String> _buildFallbackTips(String role, List<String> weakCats) {
    final tips = <String>[];

    switch (role) {
      case 'pilot':
        tips.add('Her gün LiveATC.net\'ten 15 dakika dinle ve duyduğun her müsaadeyi yaz — bu otomatik fraseoloji tanımayı geliştirir.');
        tips.add('Her çalışma seansından önce ücretsiz çevrimiçi kod çözücüler kullanarak METAR ve TAF\'ı 30 saniye zaman sınırıyla çözme pratiği yap.');
        tips.add('ICAO Dil Yeterlilik Gereksinimleri belgesini (Circular 323) sınav kıstasın olarak kullan ve her gün bir bölüm oku.');
      case 'atc':
        tips.add('LiveATC.net\'teki gerçek ATC kayıtlarını gölgele — her iletimden sonra dur, pilotun yanıtını dinlemeden önce teyit metnini yaz.');
        tips.add('ICAO Doc 4444 fraseoloji tablolarını çalış: her gün yeni bir standart ifade ezberle ve bunu yazılı bir cümlede kullan.');
        tips.add('Kesin ve yapılandırılmış İngilizce iletişim alışkanlığı edinmek için ATC simülasyon uygulamalarıyla (ör. Endless ATC) pratik yap.');
      case 'cabin_crew':
        tips.add('Kendin emniyet anonsu yapıp kaydet ve resmi havayolu senaryolarıyla karşılaştır — kelime bilgisi farklılıklarını tespit et.');
        tips.add('ICAO Kabin Ekibi Emniyet Eğitimi El Kitabı terminolojisini bölüm bölüm çalış, her yeni terim için kart oluştur.');
        tips.add('Hem anlama hem de üretim doğruluğunu geliştirmek için emniyet prosedürlerini ileri geri çevirme pratiği yap.');
      default:
        tips.add('Aralıklı tekrar yöntemiyle her gün 20 dakika çalış — kısa ve düzenli seanslar uzun ve düzensiz olanlara her zaman üstün gelir.');
        tips.add('Operasyonel havacılık İngilizcesi formatlarına alışmak için her sabah bir NOTAM veya METAR\'ı sesli oku.');
        tips.add('İlk 2 haftanı yalnızca ${weakCats.isNotEmpty ? weakCats.first.replaceAll("_", " ") : "en zayıf kategorine"} ayır — bir alanda uzmanlaşmak, çabayı dağıtmaktan çok daha etkilidir.');
    }

    return tips;
  }
}
