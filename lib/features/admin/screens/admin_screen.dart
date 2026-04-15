import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/supabase_service.dart';

const _adminEmail = 'emottz199@gmail.com';
const _geminiApiKey = 'AIzaSyBF2g68U1DltnnMWc2s1M1BHjCq6ErGDL4';
const _geminiUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;
  String? _error;
  String? _aiInsight;
  bool _aiLoading = false;
  late TabController _tabController;

  String get _currentEmail =>
      (Supabase.instance.client.auth.currentUser?.email ?? '').toLowerCase().trim();
  bool get _isAdmin =>
      _currentEmail == _adminEmail.toLowerCase().trim();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final users = await SupabaseService.getAllUsers();
      setState(() { _users = users; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _getAiInsight() async {
    if (_users.isEmpty) return;
    setState(() { _aiLoading = true; _aiInsight = null; });
    try {
      final res = await http.post(
        Uri.parse('$_geminiUrl?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{'parts': [{'text': _buildInsightPrompt(_users)}]}],
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
    final weakCatCounts = <String, int>{};
    for (final u in users) {
      final wc = (u['weakCategories'] as List?)?.cast<String>() ?? [];
      for (final c in wc) { weakCatCounts[c] = (weakCatCounts[c] ?? 0) + 1; }
    }
    final sortedWeak = weakCatCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return '''
FLIQ havacılık İngilizcesi uygulaması — $total kullanıcı analizi:
- Ortamlar: ${_fmt(_count(users, 'flyingEnvironment'))}
- Uçuş saatleri: ${_fmt(_count(users, 'flightHours'))}
- En zor alan: ${_fmt(_count(users, 'hardestArea'))}
- İngilizce öz-değer: ${_fmt(_count(users, 'englishLevel'))}
- Hedefler: ${_fmt(_count(users, 'goal'))}
- ICAO deneyimi: ${_fmt(_count(users, 'prevIcaoAttempt'))}
- Sınav zaman planı: ${_fmt(_count(users, 'examTimeline'))}
- Proficiency seviyeleri: ${_fmt(_count(users, 'level'))}
- Zayıf kategoriler: ${sortedWeak.take(4).map((e) => '${e.key}:${e.value}').join(', ')}

Türkçe olarak 5 maddede içgörü ver: kullanıcı profili, kritik içerik ihtiyaçları, ürün önerileri, pazarlama segmenti, dikkat edilmesi gerekenler.
''';
  }

  Map<String, int> _count(List<Map<String, dynamic>> users, String key) {
    final map = <String, int>{};
    for (final u in users) {
      final val = u[key]?.toString() ?? '—';
      if (val.isNotEmpty && val != '—') map[val] = (map[val] ?? 0) + 1;
    }
    return map;
  }

  String _fmt(Map<String, int> m) =>
      m.entries.map((e) => '${e.key}:${e.value}').join(', ');

  @override
  Widget build(BuildContext context) {
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
              Text('Giriş yapılan: $_currentEmail', style: AppTextStyles.caption),
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
            Icon(Icons.admin_panel_settings_outlined, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('FLIQ Admin', style: AppTextStyles.heading3),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.people_outline, size: 18), text: 'Kullanıcılar'),
            Tab(icon: Icon(Icons.confirmation_number_outlined, size: 18), text: 'Kuponlar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Kullanıcılar
          _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : _error != null
                  ? _buildError()
                  : _buildContent(),
          // Tab 2: Kuponlar
          const _CouponManagementTab(),
        ],
      ),
    );
  }

  Widget _buildError() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 12),
          const Text('Veri yüklenemedi', style: AppTextStyles.heading3),
          const SizedBox(height: 6),
          Text(_error!, style: AppTextStyles.caption, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextButton(onPressed: _load, child: const Text('Tekrar Dene')),
        ],
      ),
    ),
  );

  Widget _buildContent() {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth >= 700;
      return SingleChildScrollView(
        padding: EdgeInsets.all(isWide ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Özet kartları ─────────────────────────────────
            _sectionTitle(Icons.bar_chart_outlined, 'Genel Bakış'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatCard('${_users.length}', 'Toplam Kullanıcı', Icons.people_outline, AppColors.primary),
                _StatCard('${_users.where((u) => u['level'] != null && u['level'].toString().isNotEmpty).length}', 'Sınav Tamamlayan', Icons.quiz_outlined, AppColors.success),
                _StatCard('${_users.where((u) => u['flyingEnvironment'] == 'ifr_commercial').length}', 'IFR Ticari', Icons.flight, const Color(0xFF8B5CF6)),
                _StatCard('${_users.where((u) => u['prevIcaoAttempt'] == 'failed').length}', 'Tekrar Deneyen', Icons.replay_outlined, AppColors.warning),
                _StatCard('${_users.where((u) => u['nativeLanguage'] == 'turkish').length}', 'Türk Kullanıcı', Icons.language_outlined, AppColors.xpOrange),
                _StatCard('${_users.where((u) => u['examTimeline'] == '1_month').length}', '1 Ay İçinde Sınav', Icons.alarm_outlined, AppColors.error),
              ],
            ),

            const SizedBox(height: 28),

            // ── Dağılım grafikleri ────────────────────────────
            _sectionTitle(Icons.pie_chart_outline, 'Dağılımlar'),
            const SizedBox(height: 12),
            isWide ? _wideDistRow() : _narrowDistCol(),

            const SizedBox(height: 28),

            // ── AI Insights ───────────────────────────────────
            _sectionTitle(Icons.auto_awesome_outlined, 'Gemini Analizi'),
            const SizedBox(height: 12),
            _buildAiSection(),

            const SizedBox(height: 28),

            // ── Kullanıcı listesi ─────────────────────────────
            _sectionTitle(Icons.list_alt_outlined, 'Kullanıcılar (${_users.length})'),
            const SizedBox(height: 12),
            _buildUserList(isWide),
          ],
        ),
      );
    });
  }

  Widget _wideDistRow() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: _DistCard('Uçuş Ortamı', _count(_users, 'flyingEnvironment'), _envLabels)),
      const SizedBox(width: 12),
      Expanded(child: _DistCard('En Zor Alan', _count(_users, 'hardestArea'), _hardestLabels)),
      const SizedBox(width: 12),
      Expanded(child: _DistCard('ICAO Deneyimi', _count(_users, 'prevIcaoAttempt'), _icaoLabels)),
      const SizedBox(width: 12),
      Expanded(child: _DistCard('Hedef', _count(_users, 'goal'), _goalLabels)),
    ],
  );

  Widget _narrowDistCol() => Column(
    children: [
      Row(children: [
        Expanded(child: _DistCard('Uçuş Ortamı', _count(_users, 'flyingEnvironment'), _envLabels)),
        const SizedBox(width: 12),
        Expanded(child: _DistCard('En Zor Alan', _count(_users, 'hardestArea'), _hardestLabels)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _DistCard('ICAO Deneyimi', _count(_users, 'prevIcaoAttempt'), _icaoLabels)),
        const SizedBox(width: 12),
        Expanded(child: _DistCard('Hedef', _count(_users, 'goal'), _goalLabels)),
      ]),
    ],
  );

  Widget _buildAiSection() {
    if (_aiInsight == null && !_aiLoading) {
      return OutlinedButton.icon(
        onPressed: _getAiInsight,
        icon: const Icon(Icons.bolt_outlined),
        label: const Text('Gemini ile Analiz Et'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      );
    }
    if (_aiLoading) {
      return const Row(
        children: [
          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
          SizedBox(width: 12),
          Text('Gemini analiz ediyor...', style: AppTextStyles.caption),
        ],
      );
    }
    return Container(
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
              Text('Gemini Analizi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED))),
            ],
          ),
          const SizedBox(height: 10),
          Text(_aiInsight!, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.6)),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _getAiInsight,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Yenile'),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF7C3AED)),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(bool isWide) {
    if (_users.isEmpty) {
      return const Center(child: Text('Henüz kayıtlı kullanıcı yok.', style: AppTextStyles.caption));
    }
    if (isWide) return _UserTable(users: _users);
    return _UserCardList(users: _users);
  }

  Widget _sectionTitle(IconData icon, String label) => Row(
    children: [
      Icon(icon, color: AppColors.primary, size: 18),
      const SizedBox(width: 8),
      Text(label, style: AppTextStyles.heading3),
    ],
  );
}

// ── Label maps ────────────────────────────────────────────────────────────────

const _envLabels = {
  'vfr_private': 'VFR Özel', 'ifr_commercial': 'IFR Ticari',
  'atc': 'ATC', 'cabin': 'Kabin', 'student': 'Öğrenci',
};
const _hardestLabels = {
  'grammar': 'Gramer', 'vocabulary': 'Kelime',
  'atc_comm': 'ATC İletişimi', 'reading': 'Okuma', 'all': 'Hepsi',
};
const _icaoLabels = {
  'never': 'İlk kez', 'failed': 'Başarısız oldu', 'passed_want_higher': 'Geçti, yükseltmek istiyor',
};
const _goalLabels = {
  'icao': 'ICAO Sınavı', 'general': 'Genel', 'both': 'Her İkisi',
};
const _levelLabels = {
  'beginner': 'Başlangıç', 'elementary': 'Temel',
  'intermediate': 'Orta', 'advanced': 'İleri',
};

// ── Stat card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatCard(this.value, this.label, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

// ── Distribution card ─────────────────────────────────────────────────────────

class _DistCard extends StatelessWidget {
  final String title;
  final Map<String, int> data;
  final Map<String, String> labels;
  const _DistCard(this.title, this.data, this.labels);

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0, (a, b) => a + b);
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodyBold),
            const SizedBox(height: 12),
            const Text('Veri yok', style: AppTextStyles.caption),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(14),
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
                      Flexible(
                        child: Text(
                          labels[e.key] ?? e.key,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${e.value}  ${(pct * 100).round()}%',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: pct, minHeight: 5,
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

// ── Wide user table ───────────────────────────────────────────────────────────

class _UserTable extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  const _UserTable({required this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 40,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 56,
          columnSpacing: 14,
          headingTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
          columns: const [
            DataColumn(label: Text('E-POSTA')),
            DataColumn(label: Text('ORTAM')),
            DataColumn(label: Text('SAAT')),
            DataColumn(label: Text('EN ZOR')),
            DataColumn(label: Text('İNGİLİZCE')),
            DataColumn(label: Text('HEDEF')),
            DataColumn(label: Text('ICAO GEÇMİŞ')),
            DataColumn(label: Text('SINAV')),
            DataColumn(label: Text('SEVİYE')),
            DataColumn(label: Text('ZAYIF')),
          ],
          rows: users.map((u) => DataRow(cells: [
            DataCell(Text(u['email'] ?? '—', style: const TextStyle(fontSize: 11))),
            DataCell(_chip(_envLabels[u['flyingEnvironment']] ?? '—', AppColors.primary)),
            DataCell(Text(_hoursLabel(u['flightHours']), style: const TextStyle(fontSize: 11))),
            DataCell(Text(_hardestLabels[u['hardestArea']] ?? '—', style: const TextStyle(fontSize: 11))),
            DataCell(Text(_engLabel(u['englishLevel']), style: const TextStyle(fontSize: 11))),
            DataCell(Text(_goalLabels[u['goal']] ?? '—', style: const TextStyle(fontSize: 11))),
            DataCell(Text(_icaoLabels[u['prevIcaoAttempt']] ?? '—', style: const TextStyle(fontSize: 11))),
            DataCell(Text(_timelineLabel(u['examTimeline']), style: const TextStyle(fontSize: 11))),
            DataCell(_chip(_levelLabels[u['level']] ?? '—', _levelColor(u['level']?.toString()))),
            DataCell(SizedBox(
              width: 140,
              child: Text(
                (u['weakCategories'] as List?)?.join(', ') ?? '—',
                style: const TextStyle(fontSize: 10, color: AppColors.warning),
                overflow: TextOverflow.ellipsis,
              ),
            )),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(5)),
    child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
  );

  Color _levelColor(String? l) => switch (l) {
    'beginner' => const Color(0xFF10B981), 'elementary' => const Color(0xFF3B82F6),
    'intermediate' => const Color(0xFF8B5CF6), 'advanced' => const Color(0xFFF59E0B),
    _ => AppColors.textHint,
  };

  String _hoursLabel(dynamic v) => switch (v?.toString()) {
    '0_50' => '0-50', '50_200' => '50-200', '200_500' => '200-500', '500_plus' => '500+', _ => '—',
  };
  String _engLabel(dynamic v) => switch (v?.toString()) {
    'weak' => 'Zayıf', 'medium' => 'Orta', 'good' => 'İyi', _ => '—',
  };
  String _timelineLabel(dynamic v) => switch (v?.toString()) {
    'not_planned' => 'Planlanmadı', '6_months_plus' => '6ay+',
    '6_months' => '6ay', '1_month' => '1ay', _ => '—',
  };
}

// ── Mobile user card list ─────────────────────────────────────────────────────

class _UserCardList extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  const _UserCardList({required this.users});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users.map((u) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(u['email'] ?? '—', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: [
                _tag(_envLabels[u['flyingEnvironment']] ?? '—', AppColors.primary),
                _tag(_levelLabels[u['level']] ?? '—', _levelColor(u['level']?.toString())),
                if ((u['prevIcaoAttempt'] ?? '').isNotEmpty)
                  _tag(_icaoLabels[u['prevIcaoAttempt']] ?? '—', AppColors.warning),
              ],
            ),
            const SizedBox(height: 8),
            _row('En zor:', _hardestLabels[u['hardestArea']] ?? '—'),
            _row('Hedef:', _goalLabels[u['goal']] ?? '—'),
            _row('Sınav:', _timelineLabel(u['examTimeline'])),
            if ((u['weakCategories'] as List?)?.isNotEmpty == true)
              _row('Zayıf:', (u['weakCategories'] as List).join(', ')),
          ],
        ),
      )).toList(),
    );
  }

  Widget _tag(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
  );

  Widget _row(String k, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 3),
    child: Row(
      children: [
        Text('$k ', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Flexible(child: Text(v, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
      ],
    ),
  );

  Color _levelColor(String? l) => switch (l) {
    'beginner' => const Color(0xFF10B981), 'elementary' => const Color(0xFF3B82F6),
    'intermediate' => const Color(0xFF8B5CF6), 'advanced' => const Color(0xFFF59E0B),
    _ => AppColors.textHint,
  };
  String _timelineLabel(dynamic v) => switch (v?.toString()) {
    'not_planned' => 'Planlanmadı', '6_months_plus' => '6ay+',
    '6_months' => '6ay', '1_month' => '1ay', _ => '—',
  };
}

// ── Kupon Yönetimi Sekmesi ────────────────────────────────────────────────────

class _CouponManagementTab extends StatefulWidget {
  const _CouponManagementTab();

  @override
  State<_CouponManagementTab> createState() => _CouponManagementTabState();
}

class _CouponManagementTabState extends State<_CouponManagementTab> {
  static final _sb = Supabase.instance.client;

  List<Map<String, dynamic>> _coupons = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    setState(() { _loading = true; _error = null; });
    try {
      final rows = await _sb
          .from('coupons')
          .select()
          .order('created_at', ascending: false);
      final list = (rows as List).map((r) {
        final data = Map<String, dynamic>.from(r as Map);
        data['_id'] = data['id'];
        return data;
      }).toList();
      setState(() { _coupons = list; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (_) => _CreateCouponDialog(onCreated: _loadCoupons),
    );
  }

  Future<void> _toggleActive(String id, bool current) async {
    await _sb.from('coupons').update({'is_active': !current}).eq('id', id);
    _loadCoupons();
  }

  Future<void> _deleteCoupon(String id, String code) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kuponu sil?'),
        content: Text(
          '$code kodu silinecek ve bu kuponla aktif edilen tüm premium erişimler iptal edilecek.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true) {
      // Bu kuponla aktif edilen premium erişimleri iptal et
      await _sb.rpc('revoke_coupon_premium', params: {'coupon_code_param': code});
      // Kuponu sil
      await _sb.from('coupons').delete().eq('id', id);
      _loadCoupons();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              Text(_error!, style: AppTextStyles.caption, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton(onPressed: _loadCoupons, child: const Text('Tekrar Dene')),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text('${_coupons.length} kupon', style: AppTextStyles.bodyBold),
              const Spacer(),
              FilledButton.icon(
                onPressed: _showCreateDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Yeni Kupon'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _loadCoupons,
                icon: const Icon(Icons.refresh, size: 20),
                tooltip: 'Yenile',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _coupons.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.confirmation_number_outlined, size: 48, color: AppColors.textHint),
                      SizedBox(height: 12),
                      Text('Henüz kupon yok', style: AppTextStyles.caption),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _coupons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _CouponCard(
                    data: _coupons[i],
                    onToggle: () => _toggleActive(
                      _coupons[i]['_id'] as String,
                      _coupons[i]['is_active'] == true,
                    ),
                    onDelete: () => _deleteCoupon(
                      _coupons[i]['_id'] as String,
                      _coupons[i]['code'] as String? ?? '',
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

// ── Kupon kartı ───────────────────────────────────────────────────────────────

class _CouponCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const _CouponCard({required this.data, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final id           = data['_id'] as String;
    final active       = data['is_active'] == true;
    final plan         = data['plan'] as String? ?? '—';
    final durationDays = (data['duration_days'] as num?)?.toInt() ?? 0;
    final usedCount    = (data['use_count'] as num?)?.toInt() ?? 0;
    final maxUses      = data['max_uses'] as int?;
    final singleUse    = data['single_use'] == true;

    final isTimed      = durationDays > 0;
    final durationLabel = isTimed ? '$durationDays Gün' : 'Süresiz';
    final durationColor = isTimed ? const Color(0xFF2563EB) : const Color(0xFF16A34A);

    final String usageLabel;
    if (singleUse) {
      usageLabel = usedCount >= 1 ? 'Kullanıldı' : 'Tek kullanım';
    } else if (maxUses != null) {
      usageLabel = '$usedCount / $maxUses kullanım';
    } else {
      usageLabel = '$usedCount kullanım';
    }

    final planLabel = const {
      'pilot':      'Pilot',
      'cabin_crew': 'Kabin',
      'amt':        'AMT',
      'student':    'Öğrenci',
      'free':       'Ücretsiz',
    }[plan] ?? plan;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: active ? AppColors.surface : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: active ? AppColors.divider : const Color(0xFFD1D5DB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$id kopyalandı'), duration: const Duration(seconds: 1)),
                        );
                      },
                      child: Text(
                        id,
                        style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary, fontFamily: 'monospace',
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.copy_outlined, size: 13, color: AppColors.textHint),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6, runSpacing: 4,
                  children: [
                    _badge(planLabel, AppColors.primary),
                    _badge(durationLabel, durationColor),
                    _badge(usageLabel, AppColors.textSecondary),
                    if (!active) _badge('Pasif', AppColors.error),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: active,
                onChanged: (_) => onToggle(),
                activeThumbColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
  );
}

// ── Kupon oluşturma dialog'u ──────────────────────────────────────────────────

class _CreateCouponDialog extends StatefulWidget {
  final VoidCallback onCreated;
  const _CreateCouponDialog({required this.onCreated});

  @override
  State<_CreateCouponDialog> createState() => _CreateCouponDialogState();
}

class _CreateCouponDialogState extends State<_CreateCouponDialog> {
  static final _sb   = Supabase.instance.client;
  final _codeCtrl    = TextEditingController();
  final _daysCtrl    = TextEditingController();
  final _maxUsesCtrl = TextEditingController();

  String _plan        = 'student';
  bool   _singleUse   = false;
  bool   _hasDuration = true;   // true = süreli, false = süresiz
  bool   _hasMaxUses  = false;
  bool   _saving      = false;
  String? _err;

  static const _plans = {
    'pilot':      'Pilot',
    'cabin_crew': 'Kabin Görevlisi',
    'amt':        'Uçak Bakım Teknisyeni',
    'student':    'Öğrenci',
    'free':       'Ücretsiz Erişim',
  };

  @override
  void dispose() {
    _codeCtrl.dispose();
    _daysCtrl.dispose();
    _maxUsesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) { setState(() => _err = 'Kupon kodu girin.'); return; }

    int durationDays = 0;
    if (_hasDuration) {
      final parsed = int.tryParse(_daysCtrl.text.trim());
      if (parsed == null || parsed <= 0) {
        setState(() => _err = 'Geçerli bir gün sayısı girin (>0).');
        return;
      }
      durationDays = parsed;
    }

    int? maxUses;
    if (_hasMaxUses && !_singleUse) {
      final parsed = int.tryParse(_maxUsesCtrl.text.trim());
      if (parsed == null || parsed <= 0) {
        setState(() => _err = 'Geçerli bir kullanım limiti girin (>0).');
        return;
      }
      maxUses = parsed;
    }

    setState(() { _saving = true; _err = null; });

    try {
      // Aynı kod var mı kontrol et
      final existing = await _sb
          .from('coupons')
          .select('code')
          .eq('code', code)
          .maybeSingle();
      if (existing != null) {
        setState(() { _err = '$code zaten mevcut.'; _saving = false; });
        return;
      }

      await _sb.from('coupons').insert({
        'code':          code,
        'is_active':     true,
        'plan':          _plan,
        'duration_days': durationDays,
        'single_use':    _singleUse,
        'use_count':     0,
        'used_by':       <String>[],
        'max_uses':      maxUses ?? 0,
        'created_at':    DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.of(context).pop();
        widget.onCreated();
      }
    } catch (e) {
      setState(() { _err = e.toString(); _saving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.confirmation_number_outlined, color: AppColors.primary),
                  const SizedBox(width: 10),
                  const Text('Yeni Kupon Oluştur', style: AppTextStyles.heading3),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const _CouponLabel('Kupon Kodu'),
              const SizedBox(height: 6),
              TextField(
                controller: _codeCtrl,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(fontFamily: 'monospace', letterSpacing: 1.5, fontWeight: FontWeight.w700),
                decoration: _inputDec('Örn: FLIQ2024'),
              ),
              const SizedBox(height: 16),

              const _CouponLabel('Plan'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _plan,
                decoration: _inputDec(null),
                items: _plans.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) => setState(() => _plan = v!),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const _CouponLabel('Süre'),
                  const Spacer(),
                  const Text('Süresiz', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Switch(
                    value: _hasDuration,
                    onChanged: (v) => setState(() { _hasDuration = v; if (!v) _daysCtrl.clear(); }),
                    activeThumbColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const Text('Süreli', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              if (_hasDuration) ...[
                const SizedBox(height: 6),
                TextField(
                  controller: _daysCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDec('Kaç gün? (ör: 30, 90, 365)'),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Bu kupon süresiz erişim verecek.',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF16A34A)),
                  ),
                ),
              const SizedBox(height: 16),

              const _CouponLabel('Kullanım Tipi'),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _TypeButton(
                      label: 'Tek Kullanım',
                      icon: Icons.person_outlined,
                      selected: _singleUse,
                      onTap: () => setState(() { _singleUse = true; _hasMaxUses = false; }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TypeButton(
                      label: 'Çok Kullanım',
                      icon: Icons.people_outlined,
                      selected: !_singleUse,
                      onTap: () => setState(() => _singleUse = false),
                    ),
                  ),
                ],
              ),
              if (!_singleUse) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _hasMaxUses,
                      onChanged: (v) => setState(() { _hasMaxUses = v!; if (!v) _maxUsesCtrl.clear(); }),
                      fillColor: WidgetStateProperty.resolveWith((s) =>
                          s.contains(WidgetState.selected) ? AppColors.primary : null),
                    ),
                    const Text('Kullanım limiti koy', style: TextStyle(fontSize: 13)),
                  ],
                ),
                if (_hasMaxUses) ...[
                  const SizedBox(height: 6),
                  TextField(
                    controller: _maxUsesCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _inputDec('Maksimum kullanım sayısı'),
                  ),
                ],
              ],

              if (_err != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, size: 16, color: AppColors.error),
                      const SizedBox(width: 8),
                      Flexible(child: Text(_err!, style: const TextStyle(fontSize: 12, color: AppColors.error))),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _saving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Kuponu Oluştur', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDec(String? hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.divider)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.divider)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    filled: true,
    fillColor: const Color(0xFFFAFAFA),
  );
}

class _CouponLabel extends StatelessWidget {
  final String text;
  const _CouponLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
  );
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TypeButton({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withValues(alpha: 0.1) : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.divider,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: selected ? AppColors.primary : AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? AppColors.primary : AppColors.textSecondary)),
        ],
      ),
    ),
  );
}
