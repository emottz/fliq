import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/lessons/aviation_minigame_data.dart';

class QuickQuizGameScreen extends StatefulWidget {
  const QuickQuizGameScreen({super.key});

  @override
  State<QuickQuizGameScreen> createState() => _QuickQuizGameScreenState();
}

class _QuickQuizGameScreenState extends State<QuickQuizGameScreen>
    with SingleTickerProviderStateMixin {
  static const _totalQuestions = 10;
  static const _timePerQuestion = 8;

  late List<MiniGameTerm> _questions;
  int _qIndex = 0;
  int _score = 0;
  int _correct = 0;
  int _timeLeft = _timePerQuestion;
  int? _selectedIndex;
  bool _answered = false;
  Timer? _timer;
  late List<String> _choices; // 4 definitions
  bool _started = false;
  bool _finished = false;

  late AnimationController _timerAnim;

  @override
  void initState() {
    super.initState();
    _timerAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _timePerQuestion),
    );
    _buildQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerAnim.dispose();
    super.dispose();
  }

  void _buildQuestions() {
    final rng = Random();
    final pool = List<MiniGameTerm>.from(AviationMiniGameData.all)..shuffle(rng);
    _questions = pool.take(_totalQuestions).toList();
    _qIndex = 0;
    _score = 0;
    _correct = 0;
    _started = false;
    _finished = false;
    _answered = false;
    _selectedIndex = null;
    _loadQuestion();
  }

  void _loadQuestion() {
    final rng = Random();
    final correctDef = _questions[_qIndex].definition.split(' — ').last;
    final distractors = AviationMiniGameData.all
        .where((t) => t.term != _questions[_qIndex].term)
        .map((t) => t.definition.split(' — ').last)
        .toList()
      ..shuffle(rng);
    final choices = [correctDef, ...distractors.take(3)]..shuffle(rng);
    setState(() {
      _choices = choices;
      _timeLeft = _timePerQuestion;
      _answered = false;
      _selectedIndex = null;
    });
    _timerAnim.forward(from: 0);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_answered) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        _onAnswer(-1); // timeout
      }
    });
  }

  void _onAnswer(int choiceIndex) {
    if (_answered) return;
    _timer?.cancel();
    _timerAnim.stop();

    final correctDef = _questions[_qIndex].definition.split(' — ').last;
    final isCorrect = choiceIndex >= 0 && _choices[choiceIndex] == correctDef;
    final speedBonus = isCorrect ? (_timeLeft * 2) : 0;
    final pts = isCorrect ? (10 + speedBonus) : 0;

    setState(() {
      _answered = true;
      _selectedIndex = choiceIndex;
      if (isCorrect) {
        _score += pts;
        _correct++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_qIndex + 1 < _totalQuestions) {
        setState(() => _qIndex++);
        _loadQuestion();
      } else {
        _timer?.cancel();
        setState(() => _finished = true);
        _showResult();
      }
    });
  }

  void _showResult() {
    final title = _correct >= 7
        ? 'Harika!'
        : _correct >= 4
            ? 'İyi İş!'
            : 'Tekrar Dene';
    final avgPts = _score ~/ (_correct == 0 ? 1 : _correct);
    final xp = 10 + (_correct * 3);
    context.go('/minigame/result', extra: {
      'title': title,
      'subtitle': '$_correct / $_totalQuestions doğru',
      'emoji': _correct >= 7 ? '⚡' : _correct >= 4 ? '👍' : '💪',
      'score': _score,
      'xp': xp,
      'color1': const Color(0xFFB45309).value,
      'color2': const Color(0xFFF59E0B).value,
      'stats': [
        {'icon': '✅', 'label': 'Doğru', 'value': '$_correct'},
        {'icon': '❌', 'label': 'Yanlış', 'value': '${_totalQuestions - _correct}'},
        {'icon': '⚡', 'label': 'Ort. puan', 'value': '$avgPts'},
        {'icon': '⭐', 'label': 'Toplam', 'value': '$_score'},
      ],
      'sourceRoute': '/minigame/quickquiz',
    });
  }

  Widget _statRow(String icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$icon  $label', style: const TextStyle(fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    ),
  );

  Color _choiceColor(int i) {
    if (!_answered) return AppColors.surface;
    final correctDef = _questions[_qIndex].definition.split(' — ').last;
    if (_choices[i] == correctDef) return AppColors.successLight;
    if (i == _selectedIndex) return AppColors.errorLight;
    return AppColors.surface;
  }

  Color _choiceBorder(int i) {
    if (!_answered) return AppColors.divider;
    final correctDef = _questions[_qIndex].definition.split(' — ').last;
    if (_choices[i] == correctDef) return AppColors.success;
    if (i == _selectedIndex) return AppColors.error;
    return AppColors.divider;
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final q = _questions[_qIndex];
    final timerColor = _timeLeft > 4 ? AppColors.success : AppColors.error;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/home/minigames'),
        ),
        title: Text('⚡ Hızlı Quiz',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('⭐ $_score',
                  style: const TextStyle(fontWeight: FontWeight.w700,
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
                // Progress bar
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Row(
                    children: List.generate(_totalQuestions, (i) => Expanded(
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
                    )),
                  ),
                ),
                Text('${_qIndex + 1} / $_totalQuestions',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 20),

                // Timer ring
                SizedBox(
                  width: 72,
                  height: 72,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _timerAnim,
                        builder: (_, __) => CircularProgressIndicator(
                          value: 1 - _timerAnim.value,
                          strokeWidth: 6,
                          backgroundColor: AppColors.divider,
                          valueColor: AlwaysStoppedAnimation(timerColor),
                        ),
                      ),
                      Text(
                        '$_timeLeft',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: timerColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Term card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text('✈️  Bu terimin tanımı hangisi?',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 10),
                      Text(
                        q.term,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(q.category,
                            style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Choices
                ...List.generate(4, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => _onAnswer(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _choiceColor(i),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _choiceBorder(i), width: 1.5),
                      ),
                      child: Text(
                        _choices[i],
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
