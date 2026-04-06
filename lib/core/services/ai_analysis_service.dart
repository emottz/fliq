import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_analysis_result.dart';

/// Replace with your Gemini API key from https://aistudio.google.com/app/apikey
const _geminiApiKey = 'YOUR_GEMINI_API_KEY';

const _model = 'gemini-1.5-flash';
const _baseUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

class AiAnalysisService {
  Future<AiAnalysisResult> analyze({
    required String role,
    required String level,
    required int totalCorrect,
    required int totalQuestions,
    required Map<String, Map<String, int>> categoryResults,
  }) async {
    if (_geminiApiKey == 'YOUR_GEMINI_API_KEY') {
      // No API key — return smart rule-based fallback
      return _fallback(
        role: role,
        level: level,
        totalCorrect: totalCorrect,
        totalQuestions: totalQuestions,
        categoryResults: categoryResults,
      );
    }

    try {
      final prompt = _buildPrompt(
        role: role,
        level: level,
        totalCorrect: totalCorrect,
        totalQuestions: totalQuestions,
        categoryResults: categoryResults,
      );

      final response = await http
          .post(
            Uri.parse('$_baseUrl?key=$_geminiApiKey'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt}
                  ]
                }
              ],
              'generationConfig': {
                'responseMimeType': 'application/json',
                'temperature': 0.4,
              },
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final text = body['candidates'][0]['content']['parts'][0]['text'] as String;
        final json = jsonDecode(text) as Map<String, dynamic>;
        return AiAnalysisResult.fromJson(json);
      }
    } catch (_) {
      // Fall through to rule-based fallback
    }

    return _fallback(
      role: role,
      level: level,
      totalCorrect: totalCorrect,
      totalQuestions: totalQuestions,
      categoryResults: categoryResults,
    );
  }

  String _buildPrompt({
    required String role,
    required String level,
    required int totalCorrect,
    required int totalQuestions,
    required Map<String, Map<String, int>> categoryResults,
  }) {
    final roleLabel = {
      'pilot': 'Commercial Pilot',
      'atc': 'Air Traffic Controller',
      'cabin_crew': 'Cabin Crew Member',
      'student': 'Aviation Student',
    }[role] ?? 'Aviation Professional';

    final categoryLines = categoryResults.entries.map((e) {
      final c = e.value['correct'] ?? 0;
      final t = e.value['total'] ?? 0;
      final pct = t > 0 ? (c / t * 100).round() : 0;
      return '- ${e.key.replaceAll('_', ' ')}: $c/$t ($pct%)';
    }).join('\n');

    return '''
You are an expert ICAO aviation English coach. Analyze this student's assessment results and provide personalized coaching.

STUDENT PROFILE:
- Role: $roleLabel
- Determined Level: $level
- Overall Score: $totalCorrect/$totalQuestions

CATEGORY SCORES:
$categoryLines

Respond ONLY with valid JSON matching this exact schema:
{
  "summary": "2-3 sentence personalized performance summary mentioning their role and specific observations",
  "focus_areas": [
    {
      "title": "Short technical topic title (e.g. Modal Verbs in Clearances)",
      "description": "1-2 sentences explaining the gap and why it matters for their specific role",
      "priority": "high"
    }
  ],
  "study_tips": [
    "Specific actionable study tip relevant to their role and weak areas"
  ]
}

Rules:
- focus_areas: 2-4 items, ordered by priority. Only include weak categories (under 70%).
- study_tips: exactly 3 items, practical and role-specific
- All text must be in English
- Be specific about ICAO standards, aviation phraseology, and their role
- If all categories are strong (>=80%), focus_areas should have 1 item about maintaining excellence
''';
  }

  AiAnalysisResult _fallback({
    required String role,
    required String level,
    required int totalCorrect,
    required int totalQuestions,
    required Map<String, Map<String, int>> categoryResults,
  }) {
    final weakCats = categoryResults.entries.where((e) {
      final t = e.value['total'] ?? 0;
      final c = e.value['correct'] ?? 0;
      return t > 0 && c / t < 0.7;
    }).map((e) => e.key).toList();

    final roleLabel = {
      'pilot': 'pilot',
      'atc': 'air traffic controller',
      'cabin_crew': 'cabin crew member',
      'student': 'aviation student',
    }[role] ?? 'aviation professional';

    final pct = (totalCorrect / totalQuestions * 100).round();
    String summary;
    if (pct >= 80) {
      summary =
          'Strong performance — you\'re well above average for a $roleLabel at the $level level. '
          'Your results show solid command of most ICAO English areas. '
          'Targeted practice in a few specific areas will bring you to exam-ready condition.';
    } else if (pct >= 50) {
      summary =
          'Your $level result shows a good foundation as a $roleLabel with clear areas to develop. '
          'You answered $totalCorrect out of $totalQuestions correctly, '
          'with some categories needing focused attention before your exam.';
    } else {
      summary =
          'You\'re at the beginning of your aviation English journey as a $roleLabel. '
          'With $totalCorrect/$totalQuestions correct, there\'s significant room to grow. '
          'A structured daily study plan will help you progress to exam-ready level.';
    }

    final focusAreas = _buildFallbackFocusAreas(weakCats, role);
    final studyTips = _buildFallbackTips(role, weakCats);

    return AiAnalysisResult(
      summary: summary,
      focusAreas: focusAreas,
      studyTips: studyTips,
    );
  }

  List<AiFocusArea> _buildFallbackFocusAreas(List<String> weakCats, String role) {
    const insights = {
      'grammar': {
        'pilot': (
          'Modal Verbs & Conditional Structures',
          'Gaps in grammar directly affect clearance readbacks and PIREP accuracy. Focus on shall/must/should and if-clauses in operational contexts.'
        ),
        'atc': (
          'Tense Consistency in Instructions',
          'Inconsistent tense usage causes ambiguity in traffic information. Practice passive voice and future tense in ATC coordination phrases.'
        ),
        'cabin_crew': (
          'Imperative & Modal Structures',
          'Safety announcements require precise imperative and modal grammar. Passengers must receive unambiguous instructions in emergency situations.'
        ),
        'student': (
          'Core Aviation Grammar Patterns',
          'Master modal verbs, passive constructions, and conditional sentences — the three pillars of ICAO standard aviation English grammar.'
        ),
      },
      'vocabulary': {
        'pilot': (
          'METAR/TAF & NOTAMs Terminology',
          'Weather and NOTAM vocabulary is critical for pre-flight planning and in-flight decision making. Build your decoding speed for METAR abbreviations.'
        ),
        'atc': (
          'SID/STAR & Holding Phraseology',
          'Precise vocabulary for departure and arrival procedures prevents misunderstandings in high-traffic environments. Focus on ICAO Doc 4444 phraseology.'
        ),
        'cabin_crew': (
          'Safety Equipment Terminology',
          'Accurate names for safety equipment and procedures are non-negotiable for ICAO compliance and passenger safety management.'
        ),
        'student': (
          'ICAO Core Aviation Vocabulary',
          'Build your foundation with ATC phraseology, aircraft systems vocabulary, and standard ICAO terminology used across all aviation roles.'
        ),
      },
      'reading': {
        'pilot': (
          'Operational Document Comprehension',
          'Slow reading of NOTAMs and OFPs under time pressure is a common exam failure point. Practice extracting key data from dense aviation texts in under 90 seconds.'
        ),
        'atc': (
          'Flight Plan & Strip Reading Speed',
          'ATC strips and flight plan formats contain dense information that must be processed rapidly. Drill reading speed on ICAO flight plan formats.'
        ),
        'cabin_crew': (
          'Safety Procedure Manuals',
          'Understanding company ops manuals and ICAO safety documents in English is required for all cabin crew roles. Focus on procedural language patterns.'
        ),
        'student': (
          'Aviation Text Comprehension',
          'ICAO English exams include dense operational texts. Practice reading NOTAMs, METARs, and AIP extracts — focus on identifying key information quickly.'
        ),
      },
      'translation': {
        'pilot': (
          'Operational Meaning Interpretation',
          'Accurately interpreting the intent of ATC instructions and translating concepts between English and your working language prevents dangerous misunderstandings.'
        ),
        'atc': (
          'Readback & Clearance Precision',
          'Translation errors in clearance readbacks are a leading cause of runway incursions. Practice precision in both directions without paraphrasing critical values.'
        ),
        'student': (
          'Context-Based Language Transfer',
          'Focus on understanding aviation texts in context rather than word-for-word translation. ICAO language is formulaic — learn the patterns.'
        ),
        'cabin_crew': (
          'Safety Communication Accuracy',
          'Translating safety instructions accurately ensures passenger compliance. Focus on official ICAO safety terminology rather than free translation.'
        ),
      },
      'fill_blanks': {
        'pilot': (
          'Aviation Collocations & Fixed Phrases',
          'Many ATC communications use fixed collocations (e.g. "cleared for", "report passing"). Recognition of these patterns is tested directly in fill-in-the-blank questions.'
        ),
        'atc': (
          'Standard Phraseology Patterns',
          'Fill-in-the-blank questions test your knowledge of ICAO Doc 4444 standard phrases. Memorize the exact wording of common clearances and instructions.'
        ),
        'student': (
          'Aviation Collocation Patterns',
          'Aviation English uses specific word combinations that don\'t follow general English rules. Study collocations from ICAO training materials systematically.'
        ),
        'cabin_crew': (
          'Safety Announcement Templates',
          'Standard safety announcements follow fixed templates. Master the exact phrasing for each type of announcement — these appear frequently in fill-blank exams.'
        ),
      },
      'sentence_completion': {
        'pilot': (
          'Discourse Flow in ATC Communication',
          'Understanding how ATC/pilot exchanges are structured helps predict how sentences complete. Study the logical flow of standard communication sequences.'
        ),
        'atc': (
          'Logical Sequence in Clearances',
          'Clearance sentences follow predictable logical patterns. Practice completing partial clearances to build speed and accuracy on this question type.'
        ),
        'student': (
          'Aviation Sentence Structure',
          'Aviation English sentences follow specific structural patterns. Study how information is sequenced in ICAO communications — what comes first, second, third.'
        ),
        'cabin_crew': (
          'Procedural Language Completion',
          'Safety and service procedure sentences follow predictable structures. Practice with official cabin crew communication scripts to internalize the patterns.'
        ),
      },
    };

    if (weakCats.isEmpty) {
      return [
        AiFocusArea(
          title: 'Maintain Exam Readiness',
          description:
              'Your performance is strong across all categories. Take 2-3 timed practice exams weekly to maintain your edge and simulate real exam pressure.',
          priority: 'medium',
        ),
      ];
    }

    return weakCats.take(3).map((cat) {
      final catInsights = insights[cat];
      final roleKey = catInsights?.containsKey(role) == true ? role : 'student';
      final info = catInsights?[roleKey] ?? ('${cat.replaceAll('_', ' ')} Skills', 'Focus on this area to improve your overall performance.');
      return AiFocusArea(
        title: info.$1,
        description: info.$2,
        priority: weakCats.indexOf(cat) == 0 ? 'high' : 'medium',
      );
    }).toList();
  }

  List<String> _buildFallbackTips(String role, List<String> weakCats) {
    final tips = <String>[];

    switch (role) {
      case 'pilot':
        tips.add('Listen to 15 minutes of LiveATC.net daily and write down every clearance you hear — this builds automatic phraseology recognition.');
        tips.add('Practice METAR and TAF decoding under a 30-second time limit using free online decoders before each study session.');
        tips.add('Use the ICAO Language Proficiency Requirements doc (Circular 323) as your exam benchmark and read one section per day.');
      case 'atc':
        tips.add('Shadow real ATC recordings on LiveATC.net — pause after each transmission and write the readback before listening to the pilot\'s response.');
        tips.add('Drill ICAO Doc 4444 phraseology tables: memorize one new standard phrase per day and use it in a written sentence.');
        tips.add('Practice with ATC simulation apps (e.g. Endless ATC) to build the habit of precise, structured English communication.');
      case 'cabin_crew':
        tips.add('Record yourself delivering safety announcements and compare against official airline scripts — identify any vocabulary differences.');
        tips.add('Study ICAO Cabin Crew Safety Training Manual terminology chapter by chapter, creating flashcards for each new term.');
        tips.add('Practice translating safety procedures back and forth to build both comprehension and production accuracy.');
      default:
        tips.add('Study for 20 minutes daily using spaced repetition — short consistent sessions beat long irregular ones every time.');
        tips.add('Read one NOTAM or METAR aloud every morning to build familiarity with operational aviation English formats.');
        tips.add('Focus your first 2 weeks exclusively on ${weakCats.isNotEmpty ? weakCats.first.replaceAll("_", " ") : "your weakest category"} — mastering one area at a time is more effective than spreading effort thin.');
    }

    return tips;
  }
}
