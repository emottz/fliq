import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/firestore_service.dart';

// ── Admin e-postası buraya ────────────────────────────────────────────────────
const _adminEmail = 'emottz199@gmail.com';

const _geminiApiKey = 'AIzaSyBF2g68U1DltnnMWc2s1M1BHjCq6ErGDL4';
const _geminiUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;
  String? _error;
  String? _aiInsight;
  bool _aiLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String get _currentEmail =>
      (FirebaseAuth.instance.currentUser?.email ?? '').toLowerCase().trim();

  bool get _isAdmin =>
      _currentEmail == _adminEmail.toLowerCase().trim();

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final users = await FirestoreService.getAllUsers();
      setState(() { _users = users; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  // ── AI Insight ─────────────────────────────────────────────────────────────
  Future<void> _getAiInsight() async {
    if (_users.isEmpty) return;
    setState(() { _aiLoading = true; _aiInsight = null; });

    try {
      final prompt = _buildInsightPrompt(_users);
      final res = await http.post(
        Uri.parse('$_geminiUrl?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{'parts': [{'text': prompt}]}],
          'generationConfig': {'temperature': 0.5},
        }),
      ).timeout(const Duration(seconds: 20));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final text = body['candidates'][0]['content']['parts'][0]['text'] as String;
        setState(() { _aiInsight = text; _aiLoading = false; });
      } else {
        setState(() { _aiInsight = 'API hatası: ${res.statusCode}'; _aiLoading = false; });
      }
    } catch (e) {
      setState(() { _aiInsight = 'Hata: $e'; _aiLoading = false; });
    }
  }

  String _buildInsightPrompt(List<Map<String, dynamic>> users) {
    final total = users.length;
    final roles = _count(users, 'role');
    final levels = _count(users, 'level');
    final goals = _count(users, 'goal');
    final englishLevels = _count(users, 'englishLevel');
    final licenseLevels = _count(users, 'licenseLevel');
    final timelines = _count(users, 'examTimeline');
    final weakCatCounts = <String, int>{};
    for (final u in users) {
      final wc = (u['weakCategories'] as List?)?.cast<String>() ?? [];
      for (final c in wc) { weakCatCounts[c] = (weakCatCounts[c] ?? 0) + 1; }
    }
    final sortedWeak = weakCatCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return '''
Sen FLIQ adlı bir havacılık İngilizcesi uygulamasının ürün analisti olarak görev yapıyorsun.
Aşağıdaki kullanıcı tabanı verilerini analiz et ve Türkçe olarak 5-7 maddede içgörü üret.

KULLANICI VERİLERİ:
- Toplam kullanıcı: $total
- Rol dağılımı: ${_fmt(roles)}
- Proficiency seviyeleri: ${_fmt(levels)}
- Hedefler: ${_fmt(goals)}
- Öz-değerlendirme İngilizce düzeyi: ${_fmt(englishLevels)}
- Lisans düzeyi: ${_fmt(licenseLevels)}
- Sınav zaman planı: ${_fmt(timelines)}
- En yaygın zayıf kategoriler: ${sortedWeak.take(4).map((e) => '${e.key}:${e.value}').join(', ')}

İçgörüleri şu başlıklar altında ver:
1. Kullanıcı profili özeti
2. En kritik içerik ihtiyaçları
3. Ürün geliştirme önerileri
4. Pazarlama segmentasyonu
5. Dikkat edilmesi gereken riskler
''';
  }

  Map<String, int> _count(List<Map<String, dynamic>> users, String key) {
    final map = <String, int>{};
    for (final u in users) {
      final val = u[key]?.toString() ?? 'bilinmiyor';
      map[val] = (map[val] ?? 0) + 1;
    }
    return map;
  }

  String _fmt(Map<String, int> m) =>
      m.entries.map((e) => '${e.key}:${e.value}').join(', ');

  // ── Stats ──────────────────────────────────────────────────────────────────
  Map<String, int> get _roleStats => _count(_users, 'role');
  Map<String, int> get _levelStats => _count(_users, 'level');
  Map<String, int> get _goalStats => _count(_users, 'goal');

  @override
  Widget build(BuildContext context) {
    // Admin erişim kontrolü
    if (!_isAdmin) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: AppColors.textHint),
              const SizedBox(height: 16),
              const Text('Erişim Yok', style: AppTextStyles.heading2),
              const SizedBox(height: 8),
              Text(
                'Bu panel sadece admin hesabına açık.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 4),
              Text(
                'Giriş yapılan: $_currentEmail',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings_outlined, color: AppColors.primary, size: 22),
            SizedBox(width: 10),
            Text('FLIQ Admin', style: AppTextStyles.heading3),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yenile',
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 12),
          Text('Veri yüklenemedi', style: AppTextStyles.heading3),
          const SizedBox(height: 6),
          Text(
            _error!,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: _load, child: const Text('Tekrar Dene')),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Özet kartları ──────────────────────────────────
              _SectionTitle(icon: Icons.bar_chart_outlined, label: 'Genel Bakış'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(value: '${_users.length}', label: 'Toplam Kullanıcı', icon: Icons.people_outline, color: AppColors.primary),
                  _StatCard(value: '${_users.where((u) => u['level'] != null).length}', label: 'Değerlendirme Tamamlayan', icon: Icons.quiz_outlined, color: AppColors.success),
                  _StatCard(value: '${_users.where((u) => u['role'] == 'pilot').length}', label: 'Pilot', icon: Icons.flight, color: const Color(0xFF8B5CF6)),
                  _StatCard(value: '${_users.where((u) => u['nativeLanguage'] == 'turkish').length}', label: 'Türk Kullanıcı', icon: Icons.language_outlined, color: AppColors.xpOrange),
                ],
              ),

              const SizedBox(height: 28),

              // ── Dağılım tabloları ──────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _DistCard(title: 'Rol Dağılımı', data: _roleStats, labels: _roleLabels)),
                  const SizedBox(width: 12),
                  Expanded(child: _DistCard(title: 'Seviye Dağılımı', data: _levelStats, labels: _levelLabels)),
                  const SizedBox(width: 12),
                  Expanded(child: _DistCard(title: 'Hedef', data: _goalStats, labels: _goalLabels)),
                ],
              ),

              const SizedBox(height: 28),

              // ── AI Insights ────────────────────────────────────
              _SectionTitle(icon: Icons.auto_awesome_outlined, label: 'AI İçgörü'),
              const SizedBox(height: 12),
              if (_aiInsight == null && !_aiLoading)
                OutlinedButton.icon(
                  onPressed: _getAiInsight,
                  icon: const Icon(Icons.bolt_outlined),
                  label: const Text('Gemini ile Analiz Et'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                )
              else if (_aiLoading)
                const Row(
                  children: [
                    SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                    SizedBox(width: 12),
                    Text('Gemini analiz ediyor...', style: AppTextStyles.caption),
                  ],
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFDDD6FE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: Color(0xFF7C3AED), size: 16),
                          SizedBox(width: 8),
                          Text('Gemini Analizi', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700,
                            color: Color(0xFF7C3AED),
                          )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _aiInsight!,
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.6),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _getAiInsight,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Yenile'),
                        style: TextButton.styleFrom(foregroundColor: const Color(0xFF7C3AED)),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 28),

              // ── Kullanıcı listesi ──────────────────────────────
              _SectionTitle(
                icon: Icons.list_alt_outlined,
                label: 'Kullanıcılar (${_users.length})',
              ),
              const SizedBox(height: 12),
              _UserTable(users: _users),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Etiket map'leri ───────────────────────────────────────────────────────────
const _roleLabels = {
  'pilot': 'Pilot', 'atc': 'ATC', 'cabin_crew': 'Kabin Ekibi', 'student': 'Öğrenci',
};
const _levelLabels = {
  'beginner': 'Başlangıç', 'elementary': 'Temel',
  'intermediate': 'Orta', 'advanced': 'İleri',
};
const _goalLabels = {
  'icao': 'ICAO Sınavı', 'general': 'Genel', 'both': 'Her İkisi',
};

// ── Widgets ───────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.heading3),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatCard({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _DistCard extends StatelessWidget {
  final String title;
  final Map<String, int> data;
  final Map<String, String> labels;
  const _DistCard({required this.title, required this.data, required this.labels});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0, (a, b) => a + b);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodyBold),
          const SizedBox(height: 12),
          ...data.entries.map((e) {
            final pct = total > 0 ? e.value / total : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(labels[e.key] ?? e.key,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('${e.value}  ${(pct * 100).round()}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      backgroundColor: AppColors.divider,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _UserTable extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  const _UserTable({required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('Henüz kayıtlı kullanıcı yok.', style: AppTextStyles.caption));
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 48,
          dataRowMaxHeight: 60,
          columnSpacing: 16,
          headingTextStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary,
          ),
          columns: const [
            DataColumn(label: Text('E-POSTA')),
            DataColumn(label: Text('ROL')),
            DataColumn(label: Text('LİSANS')),
            DataColumn(label: Text('İNGİLİZCE')),
            DataColumn(label: Text('HEDEF')),
            DataColumn(label: Text('SÜRE/GÜN')),
            DataColumn(label: Text('SINAV')),
            DataColumn(label: Text('SEVİYE')),
            DataColumn(label: Text('ZAYIF')),
          ],
          rows: users.map((u) {
            final weak = (u['weakCategories'] as List?)?.join(', ') ?? '—';
            return DataRow(cells: [
              DataCell(Text(u['email'] ?? '—', style: const TextStyle(fontSize: 12))),
              DataCell(_chip(_roleLabels[u['role']] ?? u['role']?.toString() ?? '—', AppColors.primary)),
              DataCell(Text(_licenseLabel(u['licenseLevel']), style: const TextStyle(fontSize: 12))),
              DataCell(Text(_englishLabel(u['englishLevel']), style: const TextStyle(fontSize: 12))),
              DataCell(Text(_goalLabels[u['goal']] ?? u['goal']?.toString() ?? '—', style: const TextStyle(fontSize: 12))),
              DataCell(Text(_timeLabel(u['dailyTime']), style: const TextStyle(fontSize: 12))),
              DataCell(Text(_timelineLabel(u['examTimeline']), style: const TextStyle(fontSize: 12))),
              DataCell(_chip(_levelLabels[u['level']] ?? '—', _levelColor(u['level']?.toString()))),
              DataCell(
                SizedBox(
                  width: 160,
                  child: Text(
                    weak,
                    style: const TextStyle(fontSize: 11, color: AppColors.warning),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Color _levelColor(String? level) => switch (level) {
    'beginner' => const Color(0xFF10B981),
    'elementary' => const Color(0xFF3B82F6),
    'intermediate' => const Color(0xFF8B5CF6),
    'advanced' => const Color(0xFFF59E0B),
    _ => AppColors.textHint,
  };

  String _licenseLabel(dynamic v) => switch (v?.toString()) {
    'not_started' => 'Başlamadı',
    'theory' => 'Teori',
    'flight_training' => 'Uçuş Eğt.',
    'ppl_holder' => 'PPL',
    _ => '—',
  };

  String _englishLabel(dynamic v) => switch (v?.toString()) {
    'weak' => 'Zayıf', 'medium' => 'Orta', 'good' => 'İyi', _ => '—',
  };

  String _timeLabel(dynamic v) => switch (v?.toString()) {
    '5_10' => '5-10 dk', '15_20' => '15-20 dk', '30_plus' => '30+ dk', _ => '—',
  };

  String _timelineLabel(dynamic v) => switch (v?.toString()) {
    'not_planned' => 'Planlanmadı',
    '6_months_plus' => '6ay+',
    '6_months' => '6 ay',
    '1_month' => '1 ay',
    _ => '—',
  };
}
