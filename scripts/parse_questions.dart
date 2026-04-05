// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Run from project root: dart run scripts/parse_questions.dart
void main() async {
  final rawDir = Directory('assets/questions/raw');
  final outDir = Directory('assets/questions');

  final files = {
    'grammar': ['Soru_Bankasi_Part1_Grammar.txt'],
    'vocabulary': [
      'Soru_Bankasi_Part2_Vocabulary.txt',
      'Soru_Bankasi_Part2_Vocabulary_Cont.txt',
    ],
    'translation': [
      'Soru_Bankasi_Part3_Translation.txt',
      'Soru_Bankasi_Part3_Translation_Cont.txt',
    ],
    'reading': [
      'Soru_Bankasi_Part4_Reading.txt',
      'Soru_Bankasi_Part4_Reading_Cont.txt',
    ],
    'fill_blanks': [
      'Soru_Bankasi_Part5_FillBlanks.txt',
      'Soru_Bankasi_Part5_FillBlanks_Cont.txt',
    ],
    'sentence_completion': [
      'Soru_Bankasi_Part6_Completion.txt',
      'Soru_Bankasi_Part6_Completion_Cont.txt',
    ],
  };

  // Categories where difficulty never starts at easy
  const neverEasyCategories = {'reading', 'sentence_completion'};

  int globalId = 1;

  for (final entry in files.entries) {
    final category = entry.key;
    final fileNames = entry.value;
    final allQuestions = <Map<String, dynamic>>[];

    for (final fileName in fileNames) {
      final file = File('${rawDir.path}/$fileName');
      if (!file.existsSync()) {
        print('WARNING: File not found: $fileName');
        continue;
      }

      final lines = file.readAsLinesSync();
      final questions = _parseFile(lines, category);
      allQuestions.addAll(questions);
    }

    // Apply difficulty heuristic
    final total = allQuestions.length;
    final third = (total / 3).ceil();

    for (int i = 0; i < allQuestions.length; i++) {
      String diff;
      if (i < third) {
        diff = neverEasyCategories.contains(category) ? 'medium' : 'easy';
      } else if (i < third * 2) {
        diff = 'medium';
      } else {
        diff = 'hard';
      }
      allQuestions[i]['diff'] = diff;
      allQuestions[i]['id'] = globalId++;
    }

    final outFile = File('${outDir.path}/$category.json');
    outFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(allQuestions),
    );
    print('✓ $category.json  (${allQuestions.length} questions)');
  }

  print('\nDone! Total questions: ${globalId - 1}');
}

List<Map<String, dynamic>> _parseFile(List<String> lines, String category) {
  final results = <Map<String, dynamic>>[];

  String? currentPassageText;
  String? currentPassageTitle;
  int passageCounter = 0;
  String? currentPassageId;

  // State machine
  String? questionText;
  final List<String> options = [];
  int? origNumber;

  void flush() {
    if (questionText == null || options.length < 2) return;
    results.add({
      'id': 0, // filled later
      'cat': category,
      'orig': origNumber ?? results.length + 1,
      'q': questionText!.trim(),
      'opts': List<String>.from(options),
      'ans': 0, // filled when ANSWER: line found
      'diff': 'medium', // overwritten after
      'passage': currentPassageText,
      'passageTitle': currentPassageTitle,
      'passageId': currentPassageId,
    });
    questionText = null;
    options.clear();
    origNumber = null;
  }

  for (final rawLine in lines) {
    final line = rawLine.trim();

    if (line.isEmpty) continue;

    // Section separators — skip
    if (line.startsWith('===') || line.startsWith('---') && !line.contains('METİN')) {
      if (line.startsWith('---') && line.contains('METİN')) {
        // Passage header: --- METİN 1: TITLE ---
        flush();
        final match = RegExp(r'METİN\s+(\d+)\s*:\s*(.+?)\s*-{0,3}$').firstMatch(line);
        if (match != null) {
          passageCounter++;
          currentPassageId = 'passage_$passageCounter';
          currentPassageTitle = match.group(2)?.trim();
          currentPassageText = null; // next non-empty, non-header line is the passage
        }
      }
      continue;
    }

    // Passage text (quoted paragraph after METİN header)
    if (currentPassageId != null && currentPassageText == null && line.startsWith('"')) {
      currentPassageText = line.replaceAll('"', '').trim();
      continue;
    }

    // Header lines like SORU BANKASI, BÖLÜM, numbers — skip
    if (RegExp(r'^(HAVA ARACI|SORU BANKASI|=+|\d+ SORU)').hasMatch(line)) continue;

    // Answer line
    if (line.toUpperCase().startsWith('ANSWER:')) {
      final letter = line.split(':').last.trim().toLowerCase();
      final idx = letter.codeUnitAt(0) - 'a'.codeUnitAt(0);
      if (results.isNotEmpty && options.isNotEmpty) {
        // Update the last pending question's answer
        if (questionText != null) {
          // Still building; flush first
          results.add({
            'id': 0,
            'cat': category,
            'orig': origNumber ?? results.length + 1,
            'q': questionText!.trim(),
            'opts': List<String>.from(options),
            'ans': idx.clamp(0, 3),
            'diff': 'medium',
            'passage': currentPassageText,
            'passageTitle': currentPassageTitle,
            'passageId': currentPassageId,
          });
          questionText = null;
          options.clear();
          origNumber = null;
        } else {
          results.last['ans'] = idx.clamp(0, 3);
        }
      }
      continue;
    }

    // Option lines: a) b) c) d)
    final optMatch = RegExp(r'^([a-d])\)\s+(.+)$').firstMatch(line);
    if (optMatch != null) {
      options.add(optMatch.group(2)!.trim());
      continue;
    }

    // Question line: starts with a number
    final qMatch = RegExp(r'^(\d+)\.\s+(.+)$').firstMatch(line);
    if (qMatch != null) {
      // Flush previous question if any
      if (questionText != null && options.isNotEmpty) flush();
      origNumber = int.tryParse(qMatch.group(1)!);
      questionText = qMatch.group(2)!;
      options.clear();
      continue;
    }

    // Continuation of question text (multi-line questions)
    if (questionText != null && options.isEmpty && !line.startsWith('a)')) {
      questionText = '$questionText $line';
    }
  }

  // Flush final question
  if (questionText != null && options.isNotEmpty) flush();

  return results;
}
