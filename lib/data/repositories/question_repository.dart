import '../datasources/asset_question_source.dart';
import '../models/question_model.dart';

class QuestionRepository {
  final AssetQuestionSource _source;
  List<QuestionModel>? _cache;

  QuestionRepository(this._source);

  Future<List<QuestionModel>> getAll() async {
    _cache ??= await _source.loadAll();
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

  /// Returns 15 stratified questions for the level assessment.
  /// Distribution: Grammar 3, Vocabulary 2, Translation 2, Reading 3, FillBlanks 2, Completion 3
  Future<List<QuestionModel>> getAssessmentQuestions() async {
    final all = await getAll();
    final distribution = {
      QuestionCategory.grammar: 3,
      QuestionCategory.vocabulary: 2,
      QuestionCategory.translation: 2,
      QuestionCategory.reading: 3,
      QuestionCategory.fillBlanks: 2,
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
    return result;
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
    return pool.take(count).toList();
  }

  /// Uçak Bakım Teknisyeni Yabancı Dil Sınavı — 80 soru, SHGM dağılımına uygun.
  ///
  /// Dağılım:
  ///   Dil Bilgisi (Grammar)          20 soru — %25
  ///   Kelime Bilgisi (Vocabulary)    15 soru — %19
  ///   Çeviri (Translation)           15 soru — %19
  ///   Okuma (Reading)                15 soru — %19
  ///   Boşluk Doldurma (Fill Blanks)  10 soru — %12
  ///   Cümle Tamamlama (Completion)    5 soru —  %6
  ///   ───────────────────────────────────────────
  ///   Toplam                         80 soru
  Future<List<QuestionModel>> buildAmtExamSession() async {
    final all = await getAll();

    const distribution = {
      QuestionCategory.grammar:            20,
      QuestionCategory.vocabulary:         15,
      QuestionCategory.translation:        15,
      QuestionCategory.reading:            15,
      QuestionCategory.fillBlanks:         10,
      QuestionCategory.sentenceCompletion:  5,
    };

    final result = <QuestionModel>[];
    for (final entry in distribution.entries) {
      final pool = all.where((q) => q.category == entry.key).toList()..shuffle();
      result.addAll(pool.take(entry.value));
    }
    result.shuffle();
    return result;
  }
}
