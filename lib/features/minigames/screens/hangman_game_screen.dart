import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/lessons/aviation_minigame_data.dart';

class HangmanGameScreen extends StatefulWidget {
  const HangmanGameScreen({super.key});

  @override
  State<HangmanGameScreen> createState() => _HangmanGameScreenState();
}

class _HangmanGameScreenState extends State<HangmanGameScreen> {
  static const _maxWrong = 6;
  static const _totalRounds = 5;

  late List<MiniGameTerm> _pool;
  int _round = 0;
  int _score = 0;
  int _totalCorrect = 0;

  late MiniGameTerm _current;
  Set<String> _guessed = {};
  int _wrongCount = 0;
  bool _roundOver = false;
  bool _roundWon = false;

  @override
  void initState() {
    super.initState();
    _buildPool();
  }

  void _buildPool() {
    final rng = Random();
    final pool = List<MiniGameTerm>.from(AviationMiniGameData.all)
        .where((t) => t.term.length >= 4 && t.term.length <= 12)
        .toList()
      ..shuffle(rng);
    _pool = pool.take(_totalRounds).toList();
    _round = 0;
    _score = 0;
    _totalCorrect = 0;
    _loadRound();
  }

  void _loadRound() {
    setState(() {
      _current = _pool[_round];
      _guessed = {};
      _wrongCount = 0;
      _roundOver = false;
      _roundWon = false;
    });
  }

  void _guess(String letter) {
    if (_roundOver) return;
    if (_guessed.contains(letter)) return;

    setState(() => _guessed.add(letter));

    final isCorrect = _current.term.contains(letter);
    if (!isCorrect) {
      setState(() => _wrongCount++);
      if (_wrongCount >= _maxWrong) {
        setState(() {
          _roundOver = true;
          _roundWon = false;
        });
        _afterRound();
        return;
      }
    }

    // Check win
    final allRevealed = _current.term
        .split('')
        .every((c) => _guessed.contains(c));
    if (allRevealed) {
      setState(() {
        _roundOver = true;
        _roundWon = true;
        _score += 20 - (_wrongCount * 2);
        _totalCorrect++;
      });
      _afterRound();
    }
  }

  void _afterRound() {
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      if (_round + 1 < _totalRounds) {
        setState(() => _round++);
        _loadRound();
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    final title = _totalCorrect >= 4
        ? 'Harika Pilot!'
        : _totalCorrect >= 2
            ? 'Fena Değil!'
            : 'Tekrar Dene';
    final xp = 10 + (_totalCorrect * 4);
    context.go('/minigame/result', extra: {
      'title': title,
      'subtitle': '$_totalCorrect / $_totalRounds bildin',
      'emoji': _totalCorrect >= 4 ? '✈️' : _totalCorrect >= 2 ? '🛩️' : '💪',
      'score': _score,
      'xp': xp,
      'color1': const Color(0xFF991B1B).value,
      'color2': const Color(0xFFEF4444).value,
      'stats': [
        {'icon': '✅', 'label': 'Doğru', 'value': '$_totalCorrect'},
        {'icon': '❌', 'label': 'Yanlış', 'value': '${_totalRounds - _totalCorrect}'},
        {'icon': '⭐', 'label': 'Puan', 'value': '$_score'},
      ],
      'sourceRoute': '/minigame/hangman',
    });
  }

  Widget _statRow(String icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$icon  $label', style: const TextStyle(fontSize: 14)),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final term = _current.term;
    final revealed = term
        .split('')
        .map((c) => _guessed.contains(c) ? c : '_')
        .join(' ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/home/minigames'),
        ),
        title: const Text('✈️ Adam Asmaca',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Tur ${_round + 1}/$_totalRounds  ⭐$_score',
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // ── Uçak hasar göstergesi ──────────────────────────────────
                _PlaneHangman(wrongCount: _wrongCount, maxWrong: _maxWrong),
                const SizedBox(height: 16),

                // ── İpucu ─────────────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _current.category,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _current.definition.split(' — ').last,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textPrimary, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Kelime harfleri ────────────────────────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _roundOver && !_roundWon ? term.split('').join(' ') : revealed,
                    key: ValueKey('$_round-$_roundOver'),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: _roundOver
                          ? (_roundWon ? AppColors.success : AppColors.error)
                          : AppColors.textPrimary,
                    ),
                  ),
                ),

                if (_roundOver)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _roundWon ? '✅ Doğru!' : '❌ Kaybettin',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: _roundWon ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // ── Yanlış hak göstergesi ──────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_maxWrong, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < _wrongCount
                            ? AppColors.error
                            : AppColors.surfaceVariant,
                        border: Border.all(
                          color: i < _wrongCount
                              ? AppColors.error
                              : AppColors.divider,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          i < _wrongCount ? Icons.close : Icons.favorite,
                          size: 14,
                          color: i < _wrongCount
                              ? Colors.white
                              : AppColors.textHint,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // ── Klavye ────────────────────────────────────────────────
                _Keyboard(
                  guessed: _guessed,
                  term: term,
                  disabled: _roundOver,
                  onTap: _guess,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Uçak hasar görseli (ASCII-style ama Flutter widget'larıyla) ──────────────

class _PlaneHangman extends StatelessWidget {
  final int wrongCount;
  final int maxWrong;

  const _PlaneHangman({required this.wrongCount, required this.maxWrong});

  // Hasar katmanları: 0 hata = sağlam uçak, 6 hata = yanıyor
  static const _stages = [
    '✈️',   // 0 hata
    '🛩️',  // 1 hata
    '💺',  // 2 hata
    '🔧',  // 3 hata
    '⚠️',  // 4 hata
    '💥',  // 5 hata
    '🔥',  // 6 hata
  ];

  @override
  Widget build(BuildContext context) {
    final emoji = _stages[wrongCount.clamp(0, _stages.length - 1)];
    final hpFraction = (maxWrong - wrongCount) / maxWrong;

    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 64)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: hpFraction,
            minHeight: 10,
            backgroundColor: AppColors.errorLight,
            valueColor: AlwaysStoppedAnimation(
              hpFraction > 0.5
                  ? AppColors.success
                  : hpFraction > 0.25
                      ? AppColors.warning
                      : AppColors.error,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${maxWrong - wrongCount} hak kaldı',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ── Klavye ────────────────────────────────────────────────────────────────────

class _Keyboard extends StatelessWidget {
  final Set<String> guessed;
  final String term;
  final bool disabled;
  final ValueChanged<String> onTap;

  static const _rows = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
  ];

  const _Keyboard({
    required this.guessed,
    required this.term,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((letter) {
              final isGuessed = guessed.contains(letter);
              final isCorrect = isGuessed && term.contains(letter);
              final isWrong = isGuessed && !term.contains(letter);

              Color bg;
              Color textColor;
              if (isCorrect) {
                bg = AppColors.successLight;
                textColor = AppColors.successDark;
              } else if (isWrong) {
                bg = AppColors.errorLight;
                textColor = AppColors.error;
              } else {
                bg = AppColors.surface;
                textColor = AppColors.textPrimary;
              }

              return GestureDetector(
                onTap: disabled || isGuessed ? null : () => onTap(letter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 30,
                  height: 38,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isGuessed ? Colors.transparent : AppColors.divider,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isGuessed ? textColor : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
