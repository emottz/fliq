import 'dart:math';

import 'package:equatable/equatable.dart';

enum Difficulty { easy, medium, hard }

enum QuestionCategory {
  grammar,
  vocabulary,
  translation,
  reading,
  fillBlanks,
  sentenceCompletion;

  String get displayName {
    switch (this) {
      case grammar:
        return 'Grammar';
      case vocabulary:
        return 'Vocabulary';
      case translation:
        return 'Translation';
      case reading:
        return 'Reading';
      case fillBlanks:
        return 'Fill in the Blanks';
      case sentenceCompletion:
        return 'Sentence Completion';
    }
  }

  String get id {
    switch (this) {
      case grammar:
        return 'grammar';
      case vocabulary:
        return 'vocabulary';
      case translation:
        return 'translation';
      case reading:
        return 'reading';
      case fillBlanks:
        return 'fill_blanks';
      case sentenceCompletion:
        return 'sentence_completion';
    }
  }

  static QuestionCategory fromId(String id) {
    return QuestionCategory.values.firstWhere((c) => c.id == id);
  }
}

class QuestionModel extends Equatable {
  final int id;
  final QuestionCategory category;
  final int originalNumber;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final Difficulty difficulty;
  final String? passageText;
  final String? passageTitle;
  final String? passageId;

  const QuestionModel({
    required this.id,
    required this.category,
    required this.originalNumber,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.difficulty,
    this.passageText,
    this.passageTitle,
    this.passageId,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as int,
      category: QuestionCategory.fromId(json['cat'] as String),
      originalNumber: json['orig'] as int,
      questionText: json['q'] as String,
      options: List<String>.from(json['opts'] as List),
      correctIndex: json['ans'] as int,
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == (json['diff'] as String),
      ),
      passageText: json['passage'] as String?,
      passageTitle: json['passageTitle'] as String?,
      passageId: json['passageId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cat': category.id,
        'orig': originalNumber,
        'q': questionText,
        'opts': options,
        'ans': correctIndex,
        'diff': difficulty.name,
        'passage': passageText,
        'passageTitle': passageTitle,
        'passageId': passageId,
      };

  /// Şıkları karıştırır ve correctIndex'i günceller.
  QuestionModel withShuffledOptions() {
    final indices = List<int>.generate(options.length, (i) => i)..shuffle(Random());
    return QuestionModel(
      id: id,
      category: category,
      originalNumber: originalNumber,
      questionText: questionText,
      options: indices.map((i) => options[i]).toList(),
      correctIndex: indices.indexOf(correctIndex),
      difficulty: difficulty,
      passageText: passageText,
      passageTitle: passageTitle,
      passageId: passageId,
    );
  }

  @override
  List<Object?> get props => [id];
}
