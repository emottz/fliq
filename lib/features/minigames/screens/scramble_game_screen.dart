import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/lessons/aviation_minigame_data.dart';

class ScrambleGameScreen extends StatefulWidget {
  const ScrambleGameScreen({super.key});

  @override
  State<ScrambleGameScreen> createState() => _ScrambleGameScreenState();
}

class _ScrambleGameScreenState extends State<ScrambleGameScreen>
    with SingleTickerProviderStateMixin {
  static const _totalQuestions = 10;

  late List<MiniGameTerm> _questions;
  int _qIndex = 0;
  int _score = 0;
  int _correct = 0;

  // Scrambled letters — list of (letter, originalIndex)
  late List<_Letter> _scrambled;
  // Letters the player has placed in answer slots
  final List<_Letter?> _answer = [];
  bool _answered = false;
  bool _isCorrect = false;
  late AnimationController _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _buildQuestions();
  }

  @override
  void dispose() {
    _shakeAnim.dispose();
    super.dispose();
  }

  void _buildQuestions() {
    final rng = Random();
    final pool = List<MiniGameTerm>.from(AviationMiniGameData.all)..shuffle(rng);
    _questions = pool.take(_totalQuestions).toList();
    _qIndex = 0;
    _score = 0;
    _correct = 0;
    _loadQuestion();
  }

  void _loadQuestion() {
    final term = _questions[_qIndex].term;
    final rng = Random();
    // Create scrambled list (shuffle until different from original)
    List<_Letter> scrambled;
    int attempts = 0;
    do {
      final letters = term.split('').asMap().entries
          .map((e) => _Letter(letter: e.value, originalIndex: e.key))
          .toList();
      letters.shuffle(rng);
      scrambled = letters;
      attempts++;
    } while (attempts < 20 && scrambled.map((l) => l.letter).join() == term);

    setState(() {
      _scrambled = scrambled;
      _answer.clear();
      _answer.addAll(List.filled(term.length, null));
      _answered = false;
      _isCorrect = false;
    });
  }

  void _tapScrambled(int i) {
    if (_answered) return;
    final letter = _scrambled[i];
    if (letter.used) return;

    // Find first empty slot in answer
    final emptySlot = _answer.indexWhere((l) => l == null);
    if (emptySlot == -1) return;

    setState(() {
      letter.used = true;
      _answer[emptySlot] = letter;
    });

    // Auto-check when all slots filled
    if (_answer.every((l) => l != null)) {
      _checkAnswer();
    }
  }

  void _tapAnswer(int i) {
    if (_answered) return;
    final letter = _answer[i];
    if (letter == null) return;

    // Return letter to scrambled pool
    setState(() {
      letter.used = false;
      _answer[i] = null;
    });
  }

  void _checkAnswer() {
    final typed = _answer.map((l) => l?.letter ?? '').join();
    final correct = _questions[_qIndex].term;
    final isCorrect = typed == correct;

    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _score += 10;
        _correct++;
      }
    });

    if (!isCorrect) {
      _shakeAnim.forward(from: 0);
    }

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      if (_qIndex + 1 < _totalQuestions) {
        setState(() => _qIndex++);
        _loadQuestion();
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    final title = _correct >= 8
        ? 'Mükemmel!'
        : _correct >= 5
            ? 'İyi İş!'
            : 'Devam Et';
    final xp = 10 + (_correct * 3);
    context.go('/minigame/result', extra: {
      'title': title,
      'subtitle': '$_correct / $_totalQuestions doğru',
      'emoji': _correct >= 8 ? '🏆' : _correct >= 5 ? '🔀' : '💪',
      'score': _score,
      'xp': xp,
      'color1': const Color(0xFF065F46).value,
      'color2': const Color(0xFF10B981).value,
      'stats': [
        {'icon': '✅', 'label': 'Doğru', 'value': '$_correct'},
        {'icon': '❌', 'label': 'Yanlış', 'value': '${_totalQuestions - _correct}'},
        {'icon': '⭐', 'label': 'Puan', 'value': '$_score'},
      ],
      'sourceRoute': '/minigame/scramble',
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
    final q = _questions[_qIndex];
    final isComplete = _answer.every((l) => l != null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/home/minigames'),
        ),
        title: const Text('🔀 Kelime Karıştır',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('⭐ $_score',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.xpOrange)),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Progress dots
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Row(
                    children: List.generate(
                      _totalQuestions,
                      (i) => Expanded(
                        child: Container(
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: i < _qIndex
                                ? AppColors.primary
                                : i == _qIndex
                                    ? AppColors.primaryLight
                                    : AppColors.divider,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Category + definition hint
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF065F46),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(q.category,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11)),
                      ),
                      const SizedBox(height: 10),
                      const Text('Bu terimi hecelemeni lazım:',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(
                        q.definition.split(' — ').last,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Answer slots
                AnimatedBuilder(
                  animation: _shakeAnim,
                  builder: (_, child) {
                    final offset = _shakeAnim.isAnimating
                        ? (8 * (0.5 - (_shakeAnim.value % 0.1) * 10)).abs() *
                            (_shakeAnim.value < 0.5 ? 1 : -1)
                        : 0.0;
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_answer.length, (i) {
                      final letter = _answer[i];
                      Color bg = AppColors.surface;
                      Color border = AppColors.primary;
                      Color textColor = AppColors.textPrimary;

                      if (_answered && isComplete) {
                        bg = _isCorrect
                            ? AppColors.successLight
                            : AppColors.errorLight;
                        border = _isCorrect
                            ? AppColors.success
                            : AppColors.error;
                        textColor = _isCorrect
                            ? AppColors.successDark
                            : AppColors.error;
                      }

                      return GestureDetector(
                        onTap: () => _tapAnswer(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 44,
                          height: 52,
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: letter != null
                                  ? border
                                  : AppColors.divider,
                              width: letter != null ? 2 : 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letter?.letter ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                if (_answered)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _isCorrect ? '✅ Doğru!' : '❌ Doğrusu: ${q.term}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _isCorrect
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ),

                const SizedBox(height: 28),

                // Scrambled letters
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_scrambled.length, (i) {
                    final letter = _scrambled[i];
                    return GestureDetector(
                      onTap: () => _tapScrambled(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 44,
                        height: 52,
                        decoration: BoxDecoration(
                          color: letter.used
                              ? AppColors.surfaceVariant
                              : const Color(0xFF065F46),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: letter.used
                                ? AppColors.divider
                                : const Color(0xFF10B981),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            letter.used ? '' : letter.letter,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),
                Text(
                  'Harflere dokun → cevabı oluştur  •  Cevap harfine dokun → geri al',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textHint),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Letter {
  final String letter;
  final int originalIndex;
  bool used;

  _Letter({
    required this.letter,
    required this.originalIndex,
    this.used = false,
  });
}
