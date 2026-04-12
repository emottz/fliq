import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/report_service.dart';

const _errorTypes = [
  'Yanlış cevap anahtarı',
  'Yazım / dilbilgisi hatası',
  'Soru belirsiz veya eksik',
  'Çeviri hatası',
  'Diğer',
];

/// Hata bildir bottom sheet'i gösterir.
///
/// [screen]: 'Sınav' veya 'Ders'
/// [questionText]: Sınav ekranında mevcut sorunun metni
/// [lessonName]: Ders ekranında dersin adı
Future<void> showReportErrorSheet(
  BuildContext context, {
  required String screen,
  String? questionText,
  String? lessonName,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ReportSheet(
      screen: screen,
      questionText: questionText,
      lessonName: lessonName,
    ),
  );
}

class _ReportSheet extends StatefulWidget {
  final String screen;
  final String? questionText;
  final String? lessonName;

  const _ReportSheet({
    required this.screen,
    this.questionText,
    this.lessonName,
  });

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  String _selectedType = _errorTypes[0];
  final _descCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _errorMsg;

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() { _loading = true; _errorMsg = null; });

    final ok = await ReportService.send(
      errorType: _selectedType,
      description: _descCtrl.text.trim(),
      screen: widget.screen,
      questionText: widget.questionText,
      lessonName: widget.lessonName,
    );

    if (!mounted) return;

    if (ok) {
      setState(() { _loading = false; _sent = true; });
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
    } else {
      setState(() {
        _loading = false;
        _errorMsg = 'Gönderilemedi. Web3Forms key\'ini kontrol et veya internetini dene.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24, 20, 24,
        MediaQuery.viewInsetsOf(context).bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tutamaç
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Başlık
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.flag_rounded, color: AppColors.error, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hata Bildir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.screen == 'Sınav' && widget.questionText != null
                ? 'Bu soruyla ilgili bir hata mı buldun?'
                : 'Bu içerikte bir hata mı buldun?',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),

          // Soru bağlamı (kısa önizleme)
          if (widget.questionText != null && widget.questionText!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.divider),
              ),
              child: Text(
                widget.questionText!.length > 120
                    ? '${widget.questionText!.substring(0, 120)}…'
                    : widget.questionText!,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Hata türü
          const Text(
            'Hata Türü',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                items: _errorTypes.map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t, style: const TextStyle(fontSize: 14)),
                )).toList(),
                onChanged: _sent || _loading ? null : (v) {
                  if (v != null) setState(() => _selectedType = v);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Açıklama
          const Text(
            'Açıklama (isteğe bağlı)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descCtrl,
            enabled: !_sent && !_loading,
            maxLines: 3,
            maxLength: 300,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Hatayı biraz daha açıkla…',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              contentPadding: const EdgeInsets.all(14),
              counterStyle: TextStyle(fontSize: 11, color: Colors.grey[400]),
            ),
          ),
          const SizedBox(height: 4),

          // Hata mesajı
          if (_errorMsg != null) ...[
            const SizedBox(height: 4),
            Text(
              _errorMsg!,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
          ],
          const SizedBox(height: 16),

          // Gönder butonu
          SizedBox(
            width: double.infinity,
            child: _sent
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Hata bildirildi, teşekkürler!',
                          style: TextStyle(
                            color: Color(0xFF15803D),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: _loading ? null : _send,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send_rounded, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Hata Bildir',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
