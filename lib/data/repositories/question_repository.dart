import 'dart:math';
import '../datasources/asset_question_source.dart';
import '../models/question_model.dart';

class QuestionRepository {
  final AssetQuestionSource _source;
  List<QuestionModel>? _cache;

  QuestionRepository(this._source);

  /// Ekranda kullanılamayacak soruları filtreler:
  /// - Soru metni 200+ karakter → pasaj gömülü fill_blanks soruları
  /// - Reading şıkları 100+ karakter → pasaja bağlı/bozuk sorular
  static bool _isUsable(QuestionModel q) {
    if (q.questionText.length > 200) return false;
    if (q.category == QuestionCategory.reading) {
      final maxOptLen = q.options.fold(0, (m, o) => o.length > m ? o.length : m);
      if (maxOptLen > 100) return false;
    }
    return true;
  }

  Future<List<QuestionModel>> getAll() async {
    _cache ??= (await _source.loadAll()).where(_isUsable).toList();
    return _cache!;
  }

  Future<List<QuestionModel>> getByCategory(QuestionCategory category) async {
    final all = await getAll();
    return all.where((q) => q.category == category).toList();
  }

  Future<List<QuestionModel>> getByDifficulty(Difficulty difficulty) async {
    final all = await getAll();
    return all.where((q) => q.difficulty == difficulty).toList();
  }

  /// Her soruya aynı kategoriden rastgele bir 5. şık ekler.
  Future<List<QuestionModel>> addFifthOptions(List<QuestionModel> questions) async {
    if (questions.isEmpty) return questions;
    final all = await getAll();
    final rng = Random();
    return questions.map((q) {
      if (q.options.length >= 5) return q;
      final candidates = all
          .where((other) => other.id != q.id && other.category == q.category)
          .expand((other) => other.options.where(
              (o) => !q.options.contains(o) && o.length < 80 && o.isNotEmpty))
          .toList();
      if (candidates.isEmpty) return q;
      candidates.shuffle(rng);
      return q.withFifthOption(candidates.first);
    }).toList();
  }

  /// Returns 25 stratified questions for the level assessment.
  /// Distribution: Grammar 5, Vocabulary 4, Translation 4, Reading 5, FillBlanks 4, Completion 3
  Future<List<QuestionModel>> getAssessmentQuestions() async {
    final all = await getAll();
    final distribution = {
      QuestionCategory.grammar: 5,
      QuestionCategory.vocabulary: 4,
      QuestionCategory.translation: 4,
      QuestionCategory.reading: 5,
      QuestionCategory.fillBlanks: 4,
      QuestionCategory.sentenceCompletion: 3,
    };

    final result = <QuestionModel>[];
    for (final entry in distribution.entries) {
      final pool = all.where((q) => q.category == entry.key).toList();
      if (pool.isEmpty) continue;
      pool.shuffle();
      result.addAll(pool.take(entry.value));
    }
    result.shuffle();
    final withFifth = await addFifthOptions(result);
    return withFifth.map((q) => q.withShuffledOptions()).toList();
  }

  /// Returns a shuffled exam session of [count] questions.
  /// Optionally filtered by [category] and/or [difficulty].
  Future<List<QuestionModel>> buildExamSession({
    QuestionCategory? category,
    Difficulty? difficulty,
    required int count,
  }) async {
    var pool = await getAll();
    if (category != null) pool = pool.where((q) => q.category == category).toList();
    if (difficulty != null) pool = pool.where((q) => q.difficulty == difficulty).toList();
    pool.shuffle();
    final selected = pool.take(count).toList();
    final withFifth = await addFifthOptions(selected);
    return withFifth.map((q) => q.withShuffledOptions()).toList();
  }

  /// Uçak Bakım Teknisyeni Yabancı Dil Sınavı — 80 soru, SHGM U 01 S UE 005 formatı.
  ///
  /// Dağılım (resmi sınav kapsamına göre):
  ///   Paragraf / Okuma (Reading)         15 soru
  ///   Boşluk Doldurma (Fill Blanks)      15 soru
  ///   Dil Bilgisi (Grammar)              10 soru
  ///   Kelime Bilgisi (Vocabulary)        15 soru
  ///   Çeviri (Translation)               15 soru
  ///   Cümle Tamamlama (Completion)       10 soru
  ///   ───────────────────────────────────────────
  ///   Toplam                             80 soru — 120 dakika
  Future<List<QuestionModel>> buildAmtExamSession() async {
    final all = await getAll();

    const distribution = {
      QuestionCategory.reading:            15,
      QuestionCategory.fillBlanks:         15,
      QuestionCategory.grammar:            10,
      QuestionCategory.vocabulary:         15,
      QuestionCategory.translation:        15,
      QuestionCategory.sentenceCompletion: 10,
    };

    final result = <QuestionModel>[];
    for (final entry in distribution.entries) {
      final pool = all.where((q) => q.category == entry.key).toList()..shuffle();
      result.addAll(pool.take(entry.value));
    }
    result.shuffle();
    final withFifth = await addFifthOptions(result);
    return withFifth.map((q) => q.withShuffledOptions()).toList();
  }
}
