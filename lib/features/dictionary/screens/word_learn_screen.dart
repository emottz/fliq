import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/lessons/aviation_minigame_data.dart';
import '../../../shared/providers/app_providers.dart';

class WordLearnScreen extends ConsumerStatefulWidget {
  final String term;
  final String definition;
  final String category;

  const WordLearnScreen({
    super.key,
    required this.term,
    required this.definition,
    required this.category,
  });

  @override
  ConsumerState<WordLearnScreen> createState() => _WordLearnScreenState();
}

class _WordLearnScreenState extends ConsumerState<WordLearnScreen>
    with SingleTickerProviderStateMixin {
  late final List<_Question> _questions;
  int _current = 0;
  int _correct = 0;
  int? _selected;
  bool _answered = false;
  bool _done = false;
  bool _success = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  List<_Question> _buildQuestions() {
    final rng = Random();
    final all = AviationMiniGameData.all;
    final others = all.where((t) => t.term != widget.term).toList()..shuffle(rng);
    final shortDef = widget.definition.split(' — ').last;

    // ── Soru 1: Anlam sorusu (term → tanım) ──
    final d1 = others.take(3).toList();
    final opts1 = [widget.definition, ...d1.map((t) => t.definition)]..shuffle(rng);
    final q1 = _Question(
      prompt: widget.term,
      promptLabel: '"${widget.term}" teriminin doğru tanımı hangisidir?',
      options: opts1,
      correctIndex: opts1.indexOf(widget.definition),
      largePrompt: true,
    );

    // ── Soru 2: Cümle içinde kullanım (boşluk doldurma) ──
    final d2 = others.skip(3).take(3).toList();
    final sentence = _buildSentence(widget.term, shortDef);
    final opts2 = [widget.term, ...d2.map((t) => t.term)]..shuffle(rng);
    final q2 = _Question(
      prompt: sentence,
      promptLabel: 'Boşluğa hangi terim gelmelidir?',
      options: opts2,
      correctIndex: opts2.indexOf(widget.term),
      largePrompt: false,
    );

    // ── Soru 3: Kategori sorusu ──
    final allCategories = all.map((t) => t.category).toSet().toList()
      ..remove(widget.category)
      ..shuffle(rng);
    final catOpts = [widget.category, ...allCategories.take(3)]..shuffle(rng);
    final q3 = _Question(
      prompt: widget.term,
      promptLabel: 'Bu terim hangi konu başlığına aittir?',
      options: catOpts,
      correctIndex: catOpts.indexOf(widget.category),
      largePrompt: true,
    );

    // ── Soru 4: Aynı kategoriden hangi terim? ──
    final samecat = all.where((t) => t.term != widget.term && t.category == widget.category).toList()..shuffle(rng);
    final diffcat = all.where((t) => t.category != widget.category).toList()..shuffle(rng);
    MiniGameTerm? sameTerm = samecat.isNotEmpty ? samecat.first : null;

    _Question q4;
    if (sameTerm != null) {
      final wrongTerms = diffcat.take(3).map((t) => t.term).toList();
      final opts4 = [sameTerm.term, ...wrongTerms]..shuffle(rng);
      q4 = _Question(
        prompt: '${widget.category} kategorisinde yer alan başka bir terim hangisidir?',
        promptLabel: '"${widget.term}" ile aynı grupta olan terimi bulun',
        options: opts4,
        correctIndex: opts4.indexOf(sameTerm.term),
        largePrompt: false,
      );
    } else {
      // Kategori tekil ise: tanımdan terimi bul (farklı distractorlarla)
      final d4 = others.skip(6).take(3).toList();
      final opts4 = [widget.term, ...d4.map((t) => t.term)]..shuffle(rng);
      q4 = _Question(
        prompt: shortDef,
        promptLabel: 'Bu tanım hangi terime aittir?',
        options: opts4,
        correctIndex: opts4.indexOf(widget.term),
        largePrompt: false,
      );
    }

    // Soru sırası: anlam her zaman ilk, geri kalanı karıştır
    final rest = [q2, q3, q4]..shuffle(rng);
    return [q1, ...rest];
  }

  /// Terimi kullanarak basit bir boşluk-doldurma cümlesi üretir.
  String _buildSentence(String term, String shortDef) {
    // shortDef'in son karakterine göre bağlaç seç
    final trimmed = shortDef.trim();
    final endsVowel = 'aeıioöuüAEIİOÖUÜ'.contains(trimmed[trimmed.length - 1]);
    final connector = endsVowel ? "'dır" : "'dir";
    return 'Havacılıkta "$trimmed"$connector. Bu durumu ifade eden terim _____\'dır.';
  }

  void _select(int idx) {
    if (_answered) return;
    setState(() {
      _selected = idx;
      _answered = true;
    });

    final isCorrect = idx == _questions[_current].correctIndex;
    if (isCorrect) _correct++;

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_current < _questions.length - 1) {
        _animCtrl.reset();
        setState(() {
          _current++;
          _selected = null;
          _answered = false;
        });
        _animCtrl.forward();
      } else {
        // Bitti
        final allCorrect = _correct == 4;
        setState(() {
          _done = true;
          _success = allCorrect;
        });
        if (allCorrect) {
          ref.read(learnedTermsProvider.notifier).markLearned(widget.term);
          ref.read(userProfileProvider.notifier).addXp(15);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return _buildResult();

    final q = _questions[_current];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Kelimeyi Öğren',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              // ── İlerleme ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: List.generate(4, (i) {
                    Color color;
                    if (i < _current) {
                      color = AppColors.success;
                    } else if (i == _current) {
                      color = AppColors.primary;
                    } else {
                      color = AppColors.divider;
                    }
                    return Expanded(
                      child: Container(
                        height: 5,
                        margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_current + 1} / 4',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.category,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Prompt kartı ──
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                q.promptLabel,
                                style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                q.prompt,
                                style: TextStyle(
                                  fontSize: q.largePrompt ? 28 : 16,
                                  fontWeight: q.largePrompt
                                      ? FontWeight.w900
                                      : FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  letterSpacing:
                                      q.largePrompt ? 2 : 0,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Seçenekler ──
                        ...List.generate(q.options.length, (i) {
                          return _OptionTile(
                            text: q.options[i],
                            selected: _selected == i,
                            answered: _answered,
                            isCorrect: i == q.correctIndex,
                            onTap: () => _select(i),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Emoji & Başlık ──
                Text(
                  _success ? '🎉' : '😓',
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 16),
                Text(
                  _success ? 'Öğrenildi!' : 'Tekrar Dene',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _success
                      ? '"${widget.term}" kelimesini başarıyla öğrendiniz.'
                      : 'Tüm soruları doğru cevaplamak gerekiyor.',
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // ── Skor chip'leri ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Chip(
                      icon: '✅',
                      label: '$_correct / 4 doğru',
                      color: _success ? AppColors.success : AppColors.error,
                    ),
                    if (_success) ...[
                      const SizedBox(width: 10),
                      const _Chip(
                          icon: '⚡', label: '+15 XP', color: AppColors.xpOrange),
                    ],
                  ],
                ),
                const SizedBox(height: 32),

                // ── Butonlar ──
                if (!_success) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        setState(() {
                          _current = 0;
                          _correct = 0;
                          _selected = null;
                          _answered = false;
                          _done = false;
                          _success = false;
                        });
                        _questions
                          ..clear()
                          ..addAll(_buildQuestions());
                        _animCtrl.reset();
                        _animCtrl.forward();
                      },
                      child: const Text('Tekrar Dene',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: AppColors.divider),
                    ),
                    onPressed: () => context.pop(),
                    child: Text(
                      'Sözlüğe Dön',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Veri sınıfı ──────────────────────────────────────────────────────────────

class _Question {
  final String prompt;
  final String promptLabel;
  final List<String> options;
  final int correctIndex;
  final bool largePrompt;

  const _Question({
    required this.prompt,
    required this.promptLabel,
    required this.options,
    required this.correctIndex,
    required this.largePrompt,
  });
}

// ── Seçenek tile ──────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final String text;
  final bool selected;
  final bool answered;
  final bool isCorrect;
  final VoidCallback onTap;

  const _OptionTile({
    required this.text,
    required this.selected,
    required this.answered,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.surface;
    Color border = AppColors.divider;
    Color textColor = AppColors.textPrimary;
    Widget? trailing;

    if (answered && isCorrect) {
      bg = AppColors.successLight;
      border = AppColors.success;
      textColor = AppColors.successDark;
      trailing = const Icon(Icons.check_circle, color: AppColors.success, size: 18);
    } else if (answered && selected && !isCorrect) {
      bg = const Color(0xFFFFEBEB);
      border = AppColors.error;
      textColor = AppColors.error;
      trailing = const Icon(Icons.cancel, color: AppColors.error, size: 18);
    } else if (selected) {
      bg = AppColors.primary.withOpacity(0.08);
      border = AppColors.primary;
    }

    return GestureDetector(
      onTap: answered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1.35,
                ),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing],
          ],
        ),
      ),
    );
  }
}

// ── Chip ──────────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;

  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}
