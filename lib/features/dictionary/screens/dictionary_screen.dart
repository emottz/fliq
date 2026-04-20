import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/lessons/aviation_minigame_data.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/hearts_display.dart';
import '../../../core/services/hearts_service.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _selectedCategory;

  static final _allTerms = AviationMiniGameData.all;
  static final _categories = ['Tümü', ..._allTerms.map((t) => t.category).toSet().toList()..sort()];

  List<MiniGameTerm> get _filtered {
    return _allTerms.where((t) {
      final matchesQuery = _query.isEmpty ||
          t.term.toLowerCase().contains(_query.toLowerCase()) ||
          t.definition.toLowerCase().contains(_query.toLowerCase());
      final matchesCat = _selectedCategory == null || _selectedCategory == 'Tümü' ||
          t.category == _selectedCategory;
      return matchesQuery && matchesCat;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _startLearn(BuildContext ctx, MiniGameTerm term, bool isPremium) async {
    if (!isPremium) {
      final ok = await showNoHeartsDialog(ctx, ref, HeartsService.learnCost);
      if (!ok || !ctx.mounted) return;
      await ref.read(heartsProvider.notifier).use(HeartsService.learnCost);
      if (!ctx.mounted) return;
    }
    ctx.push('/dictionary/learn', extra: {'term': term.term, 'definition': term.definition, 'category': term.category});
  }

  @override
  Widget build(BuildContext context) {
    final learnedAsync = ref.watch(learnedTermsProvider);
    final learned = learnedAsync.value ?? {};
    final isPremium = ref.watch(isPremiumProvider).value ?? false;
    final filtered = _filtered;
    final learnedCount = _allTerms.where((t) => learned.contains(t.term)).length;

    return Column(
      children: [
        const HeartsEmptyBanner(),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sözlük', style: AppTextStyles.heading2),
                        const SizedBox(height: 4),
                        // İlerleme satırı
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: _allTerms.isEmpty ? 0 : learnedCount / _allTerms.length,
                                  minHeight: 8,
                                  backgroundColor: AppColors.divider,
                                  valueColor: const AlwaysStoppedAnimation(AppColors.success),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$learnedCount / ${_allTerms.length} öğrenildi',
                              style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // ── Arama ──────────────────────────────────────
                        TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _query = v),
                          decoration: InputDecoration(
                            hintText: 'Terim ara…',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _query.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      setState(() => _query = '');
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.divider),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.divider),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1.5),
                            ),
                            fillColor: AppColors.surface,
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── Kategori filtresi ───────────────────────────
                        SizedBox(
                          height: 34,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              final cat = _categories[i];
                              final selected = (_selectedCategory ?? 'Tümü') == cat;
                              return GestureDetector(
                                onTap: () => setState(() =>
                                    _selectedCategory = cat == 'Tümü' ? null : cat),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.divider,
                                    ),
                                  ),
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // ── Liste ────────────────────────────────────────────
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              'Sonuç bulunamadı',
                              style: AppTextStyles.body
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                            itemCount: filtered.length,
                            itemBuilder: (ctx, i) {
                              final term = filtered[i];
                              final isLearned = learned.contains(term.term);
                              return _TermCard(
                                term: term,
                                isLearned: isLearned,
                                isPremium: isPremium,
                                onLearn: () => _startLearn(ctx, term, isPremium),
                              );
                            },
                          ),
                  ),

                  if (!isPremium)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Kelime öğren ', style: AppTextStyles.caption),
                          Text(
                            '❤️ ${HeartsService.learnCost}',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error),
                          ),
                          const Text(' hak kullanır', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Terim kartı ───────────────────────────────────────────────────────────────

class _TermCard extends StatelessWidget {
  final MiniGameTerm term;
  final bool isLearned;
  final bool isPremium;
  final VoidCallback onLearn;

  const _TermCard({
    required this.term,
    required this.isLearned,
    required this.isPremium,
    required this.onLearn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLearned ? AppColors.success : AppColors.divider,
          width: isLearned ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      term.term,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        term.category,
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  term.definition.split(' — ').last,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Sağ taraf: öğrenildi badge veya öğren butonu
          if (isLearned)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.success),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: AppColors.success, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Öğrenildi',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.successDark,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: onLearn,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.school_outlined,
                        color: Colors.white, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      isPremium ? 'Öğren' : '❤️1  Öğren',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
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
