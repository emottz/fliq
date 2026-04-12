import 'dart:convert';
import 'package:http/http.dart' as http;

// Gerçek key'i --dart-define ile geç:
//   flutter build web --dart-define=WEB3FORMS_KEY=xxxx-xxxx-xxxx
// Ücretsiz key almak için: https://web3forms.com  (sadece e-posta gir, anında aktif)
const _key = String.fromEnvironment('WEB3FORMS_KEY', defaultValue: '');

class ReportService {
  static Future<bool> send({
    required String errorType,
    required String description,
    required String screen,       // 'Sınav' veya 'Ders'
    String? questionText,
    String? lessonName,
  }) async {
    if (_key.isEmpty) return false;

    final buf = StringBuffer()
      ..writeln('Hata Türü: $errorType')
      ..writeln('Açıklama: ${description.isEmpty ? '(belirtilmedi)' : description}')
      ..writeln()
      ..writeln('--- Bağlam ---')
      ..writeln('Ekran: $screen');

    if (questionText != null && questionText.isNotEmpty) {
      buf.writeln('Soru: $questionText');
    }
    if (lessonName != null && lessonName.isNotEmpty) {
      buf.writeln('Ders: $lessonName');
    }

    try {
      final resp = await http.post(
        Uri.parse('https://api.web3forms.com/submit'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'access_key': _key,
          'subject': 'Avia English Hata Bildirimi — $errorType',
          'from_name': 'Avia English Uygulama',
          'name': 'Avia English App',
          'email': 'noreply@aviaenglish.app',
          'message': buf.toString(),
          'botcheck': false,
        }),
      );
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
