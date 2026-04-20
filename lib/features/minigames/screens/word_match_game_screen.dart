import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/lessons/aviation_minigame_data.dart';

class WordMatchGameScreen extends StatefulWidget {
  const WordMatchGameScreen({super.key});

  @override
  State<WordMatchGameScreen> createState() => _WordMatchGameScreenState();
}

class _MatchCard {
  final String text;
  final String pairId; // term string — links term card to definition card
  final bool isTerm;
  bool isFlipped = false;
  bool isMatched = false;

  _MatchCard({required this.text, required this.pairId, required this.isTerm});
}

class _WordMatchGameScreenState extends State<WordMatchGameScreen> {
  late List<_MatchCard> _cards;
  final List<int> _selected = [];
  bool _checking = false;
  int _score = 0;
  int _attempts = 0;
  int _elapsed = 0;
  Timer? _timer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final rng = Random();
    final pool = List<MiniGameTerm>.from(AviationMiniGameData.all)..shuffle(rng);
    final picked = pool.take(8).toList();

    final cards = <_MatchCard>[];
    for (final t in picked) {
      cards.add(_MatchCard(text: t.term, pairId: t.term, isTerm: true));
      cards.add(_MatchCard(text: t.definition.split(' — ').last, pairId: t.term, isTerm: false));
    }
    cards.shuffle(rng);

    setState(() {
      _cards = cards;
      _selected.clear();
      _checking = false;
      _score = 0;
      _attempts = 0;
      _elapsed = 0;
      _finished = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_finished) setState(() => _elapsed++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTap(int index) {
    if (_checking) return;
    final card = _cards[index];
    if (card.isFlipped || card.isMatched) return;
    if (_selected.contains(index)) return;

    setState(() {
      card.isFlipped = true;
      _selected.add(index);
    });

    if (_selected.length == 2) {
      _checking = true;
      _attempts++;
      final a = _cards[_selected[0]];
      final b = _cards[_selected[1]];

      if (a.pairId == b.pairId && a.isTerm != b.isTerm) {
        // Match!
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          setState(() {
            a.isMatched = true;
            b.isMatched = true;
            _selected.clear();
            _checking = false;
            _score += 10;
          });
          if (_cards.every((c) => c.isMatched)) {
            _timer?.cancel();
            setState(() => _finished = true);
            _showResult();
          }
        });
      } else {
        // No match — flip back
        Future.delayed(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          setState(() {
            a.isFlipped = false;
            b.isFlipped = false;
            _selected.clear();
            _checking = false;
          });
        });
      }
    }
  }

  void _showResult() {
    final accuracy = _score ~/ 10 * 100 ~/ (_attempts == 0 ? 1 : _attempts);
    final title = accuracy >= 80 ? 'Tebrikler!' : accuracy >= 50 ? 'İyi İş!' : 'Tekrar Dene';
    final xp = 10 + (_score ~/ 4);
    context.go('/minigame/result', extra: {
      'title': title,
      'subtitle': '8 / 8 eşleşme tamamlandı',
      'emoji': accuracy >= 80 ? '🏆' : accuracy >= 50 ? '🃏' : '💪',
      'score': _score,
      'xp': xp,
      'color1': const Color(0xFF7C3AED).value,
      'color2': const Color(0xFF9F67F2).value,
      'stats': [
        {'icon': '⏱', 'label': 'Süre', 'value': '${_elapsed}s'},
        {'icon': '🎯', 'label': 'Deneme', 'value': '$_attempts'},
        {'icon': '✅', 'label': 'Doğruluk', 'value': '%$accuracy'},
        {'icon': '⭐', 'label': 'Puan', 'value': '$_score'},
      ],
      'sourceRoute': '/minigame/wordmatch',
    });
  }

  Widget _statRow(String icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$icon  $label', style: const TextStyle(fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      ],
    ),
  );

  String _fmtTime(int s) => '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final matched = _cards.where((c) => c.isMatched).length ~/ 2;
    final total = _cards.length ~/ 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/home/minigames'),
        ),
        title: Row(
          children: [
            const Text('🃏 Kelime Eşleştirme',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '⏱ ${_fmtTime(_elapsed)}',
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Progress
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: matched / total,
                            minHeight: 8,
                            backgroundColor: AppColors.divider,
                            valueColor: const AlwaysStoppedAnimation(AppColors.success),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('$matched / $total',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                // Cards grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (_, i) {
                      final card = _cards[i];
                      final isSelected = _selected.contains(i);
                      return GestureDetector(
                        onTap: () => _onTap(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: card.isMatched
                                ? AppColors.successLight
                                : card.isFlipped || isSelected
                                    ? (card.isTerm ? AppColors.surfaceVariant : const Color(0xFFEDE9FE))
                                    : const Color(0xFF6366F1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: card.isMatched
                                  ? AppColors.success
                                  : card.isFlipped
                                      ? (card.isTerm ? AppColors.primary : const Color(0xFF7C3AED))
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: card.isFlipped || card.isMatched
                                  ? Text(
                                      card.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: card.isTerm ? 13 : 10,
                                        fontWeight: card.isTerm
                                            ? FontWeight.w800
                                            : FontWeight.w500,
                                        color: card.isMatched
                                            ? AppColors.successDark
                                            : AppColors.textPrimary,
                                      ),
                                    )
                                  : const Icon(Icons.flight,
                                      color: Colors.white54, size: 28),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Instructions
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Mavi kart = Terim  •  Mor kart = Tanım\nAynı terimin kartlarını eşleştir',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
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
