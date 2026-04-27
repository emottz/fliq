import 'package:flutter/material.dart' show Color;
import 'question_model.dart';

enum LessonType { avia, standard }

enum LessonSectionType { intro, rule, examples, animation, practice, tip, dialogue }

enum GrammarAnimationType {
  passiveVoice,
  modalVerbs,
  conditionals,
  reportedSpeech,
  tensesTimeline,
  articleUsage,
  sentenceStructure,
  wordBuilder,
  compareContrast,
}

/// Cümle yapısı animasyonu için token
class SentenceToken {
  final String word;
  final String role;   // 'subject','verb','object','adverbial','complement'
  final String label;  // Türkçe etiket
  const SentenceToken(this.word, this.role, this.label);
}

/// Kelime morfem animasyonu için morpheme
class WordMorpheme {
  final String part;
  final String type;   // 'prefix','root','suffix'
  final String meaning;
  const WordMorpheme(this.part, this.type, this.meaning);
}

/// Karşılaştırma animasyonu için çift
class ContrastPair {
  final String leftLabel;
  final String rightLabel;
  final Color leftColor;
  final Color rightColor;
  final String leftEmoji;
  final String rightEmoji;
  final List<(String, String)> rows; // (sol, sağ)
  const ContrastPair({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftColor,
    required this.rightColor,
    required this.leftEmoji,
    required this.rightEmoji,
    required this.rows,
  });
}

/// Diyalog konuşmacısı
enum DialogueSpeaker {
  atc,        // ATC / Kule — mavi
  pilot,      // Pilot — turuncu
  cabin,      // Kabin görevlisi — mor
  passenger,  // Yolcu — gri
  amt,        // Bakım teknisyeni — amber
  engineer,   // Mühendis / Müfettiş — yeşil
  captain,    // Kaptan pilot — koyu mavi
}

class DialogueLine {
  final DialogueSpeaker speaker;
  final String text;
  final String? translation;
  final bool highlight;

  const DialogueLine({
    required this.speaker,
    required this.text,
    this.translation,
    this.highlight = false,
  });
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
  final String? body;
  final List<ExampleSentence>? examples;
  final GrammarAnimationType? animationType;
  final List<QuestionModel>? practiceQuestions;
  final List<DialogueLine>? dialogueLines;
  // sentenceStructure animasyonu için
  final List<List<SentenceToken>>? sentenceTokens;
  // wordBuilder animasyonu için
  final List<(String, List<WordMorpheme>)>? wordMorphemes;
  // compareContrast animasyonu için
  final ContrastPair? contrastPair;
  final int practiceCount;

  const LessonSection({
    required this.type,
    this.title,
    this.body,
    this.examples,
    this.animationType,
    this.practiceQuestions,
    this.dialogueLines,
    this.sentenceTokens,
    this.wordMorphemes,
    this.contrastPair,
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
  final LessonType lessonType;

  const LessonContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryId,
    required this.estimatedTime,
    required this.emoji,
    required this.sections,
    this.lessonType = LessonType.avia,
  });

  int get sectionCount => sections.length;

  List<QuestionModel> get allPracticeQuestions => sections
      .where((s) => s.type == LessonSectionType.practice && s.practiceQuestions != null)
      .expand((s) => s.practiceQuestions!)
      .toList();
}
