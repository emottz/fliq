import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class AssetQuestionSource {
  static const _basePath = 'assets/questions';

  static const Map<QuestionCategory, String> _filePaths = {
    QuestionCategory.grammar: '$_basePath/grammar.json',
    QuestionCategory.vocabulary: '$_basePath/vocabulary.json',
    QuestionCategory.translation: '$_basePath/translation.json',
    QuestionCategory.reading: '$_basePath/reading.json',
    QuestionCategory.fillBlanks: '$_basePath/fill_blanks.json',
    QuestionCategory.sentenceCompletion: '$_basePath/sentence_completion.json',
  };

  Future<List<QuestionModel>> loadAll() async {
    final results = <QuestionModel>[];
    for (final entry in _filePaths.entries) {
      try {
        final raw = await rootBundle.loadString(entry.value);
        final list = jsonDecode(raw) as List;
        results.addAll(list.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>)));
      } catch (_) {
        // JSON not generated yet — skip gracefully
      }
    }
    return results;
  }
}
