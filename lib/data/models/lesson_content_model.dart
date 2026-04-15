import 'question_model.dart';

enum LessonSectionType { intro, rule, examples, animation, practice, tip }

enum GrammarAnimationType {
  passiveVoice,
  modalVerbs,
  conditionals,
  reportedSpeech,
  tensesTimeline,
  articleUsage,
}

class ExampleSentence {
  final String sentence;
  final String? translation;
  final String? highlight; // word/phrase to highlight in blue

  const ExampleSentence({
    required this.sentence,
    this.translation,
    this.highlight,
  });
}

class LessonSection {
  final LessonSectionType type;
  final String? title;
  final String? body; // markdown-lite: **bold**, *italic*, newline = paragraph break
  final List<ExampleSentence>? examples;
  final GrammarAnimationType? animationType;
  final List<QuestionModel>? practiceQuestions;
  /// Number of questions to show per practice attempt (default 4).
  final int practiceCount;

  const LessonSection({
    required this.type,
    this.title,
    this.body,
    this.examples,
    this.animationType,
    this.practiceQuestions,
    this.practiceCount = 4,
  });
}

class LessonContent {
  final String id;
  final String title;
  final String subtitle;
  final String categoryId;
  final String estimatedTime; // e.g. '8 min'
  final String emoji;
  final List<LessonSection> sections;

  const LessonContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryId,
    required this.estimatedTime,
    required this.emoji,
    required this.sections,
  });

  int get sectionCount => sections.length;

  List<QuestionModel> get allPracticeQuestions => sections
      .where((s) => s.type == LessonSectionType.practice && s.practiceQuestions != null)
      .expand((s) => s.practiceQuestions!)
      .toList();
}
