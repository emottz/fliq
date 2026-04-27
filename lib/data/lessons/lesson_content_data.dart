import 'package:flutter/material.dart' show Color;
import '../models/lesson_content_model.dart';
import '../models/question_model.dart';
import '../models/user_profile_model.dart';
import 'lesson_standard_data.dart';

/// All lesson content. Practice questions are embedded directly so they
/// remain self-contained even before the JSON question bank is loaded.
class LessonContentData {
  LessonContentData._();

  static const List<LessonContent> all = [
    // ── BEGINNER (13 ders) ───────────────────────────────────
    _passiveVoice,
    _modalVerbs,
    _simpleTenses,
    _aircraftComponents,
    _airportGround,
    _safetyEquipment,
    _atcFillBlanks,
    _preflightChecklist,
    _natoAlphabet,
    _basicAtcInstructions,
    _runwayTaxiway,
    _aviationAbbreviations,
    _basicWeatherFill,
    // ── ELEMENTARY (14 ders) ─────────────────────────────────
    _conditionals,
    _weatherNavigation,
    _emergencyVocab,
    _atcPhraseology,
    _metarTranslation,
    _approachLanding,
    _atisReading,
    _positionReports,
    _weatherPhenomena,
    _holdingPatterns,
    _squawkTransponder,
    _departureProcedures,
    _atcReadbackDrills,
    _flightPhasesVocab,
    // ── INTERMEDIATE (16 ders) ───────────────────────────────
    _notamReading,
    _reportedSpeech,
    _articlesAviation,
    _instrumentSystems,
    _flightPlanReading,
    _engineFailureLanguage,
    _opsManualTranslation,
    _emergencyCompletion,
    _ifrClearance,
    _emergencyPhraseology,
    _conditionalEmergency,
    _atisDecoding,
    _advancedPassiveVoice,
    _notamReadingAdv,
    _navSystemsVocab,
    _tafReading,
    // ── ADVANCED (17 ders) ───────────────────────────────────
    _complexStructures,
    _expertVocab,
    _sidStarReading,
    _accidentReport,
    _cat3Completion,
    _advancedAtcClearances,
    _accidentTranslation,
    _airworthinessDirectives,
    _advancedCompletion,
    _humanFactorsCrm,
    _smsLanguage,
    _regulatoryLanguage,
    _accidentInvestigation,
    _pirepLanguage,
    _opManualSentences,
    _advancedAtcCompletion,
    _fatigueLanguage,
  ];

  /// Kullanıcının seviyesinin altındaki tüm pilot dersleri döndürür.
  static List<String> lessonIdsBeforeLevel(ProficiencyLevel level) {
    // 13 beginner, 14 elementary, 16 intermediate, 17 advanced
    const boundaries = {
      ProficiencyLevel.beginner: 0,
      ProficiencyLevel.elementary: 13,
      ProficiencyLevel.intermediate: 27,
      ProficiencyLevel.advanced: 43,
    };
    final count = boundaries[level] ?? 0;
    return all.take(count).map((l) => l.id).toList();
  }

  static LessonContent? findById(String id) {
    try {
      return _everything.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  // Tüm dersler (rol bazlı listeler dahil)
  static const List<LessonContent> _everything = [
    ...all,
    ...LessonStandardData.all,
    // Dialogue lessons
    _pilotDlg1, _pilotDlg2, _pilotDlg3,
    _cabinDlg1, _cabinDlg2,
    _amtDlg1,
    _studentDlg1,
    // Cabin crew lessons
    _cabin1SafetyAnnouncements,
    _cabin2PassengerComm,
    _cabin3EmergencyProc,
    _cabin4CrmBriefing,
    _cabin5MedicalTerms,
    _cabin6DangerousGoods,
    _cabin7BoardingAnnouncements,
    _cabin8SeatbeltDemo,
    _cabin9ServiceLanguage,
    _cabin10TurbulenceComm,
    _cabin11MedicalReporting,
    _cabin12EvacuationCommands,
    _cabin13ConflictResolution,
    _cabin14CustomsForms,
    _cabin15CrewRest,
    _cabin16MaydayPanPan,
    _cabin17InfantSafety,
    _cabin18ServiceFailure,
    // AMT lessons
    _amt1AmmLanguage,
    _amt2Abbreviations,
    _amt3Airworthiness,
    _amt4RegulatoryLang,
    _amt5DefectReporting,
    _amt6WorkOrder,
    _amt7TechnicalLog,
    _amt8InspectionTerms,
    _amt9EngineRunup,
    _amt10CorrosionReport,
    _amt11NdtTerms,
    _amt12HydraulicSystem,
    _amt13AvionicsTroubleshooting,
    _amt14PartsLogistics,
    _amt15CertificationRelease,
    _amt16FuelSystem,
    _amt17LandingGear,
    _amt18SafetyMgmt,
  ];

  // Rol bazlı ders listesi — Avia ve Standart dersler iç içe geçmiş
  static List<LessonContent> forRole(String role) {
    switch (role) {
      case 'pilot':
        return const [
          // ── BAŞLANGIÇ ─────────────────────────────────────────
          LessonStandardData.presentSimple,          // STD
          _natoAlphabet,                             // AVIA
          LessonStandardData.thereIs,                // STD
          _aircraftComponents,                       // AVIA
          LessonStandardData.questions,              // STD
          _basicAtcInstructions,                     // AVIA
          LessonStandardData.adjectives,             // STD
          _airportGround,                            // AVIA
          LessonStandardData.prepositions,           // STD
          _safetyEquipment,                          // AVIA
          LessonStandardData.articles,               // STD ★
          _aviationAbbreviations,                    // AVIA
          LessonStandardData.pronouns,               // STD ★
          _basicWeatherFill,                         // AVIA
          LessonStandardData.presentSimpleKeywords,  // STD ★
          _atcFillBlanks,                            // AVIA
          _passiveVoice,                             // AVIA
          _preflightChecklist,                       // AVIA
          _runwayTaxiway,                            // AVIA
          // ── TEMEL ─────────────────────────────────────────────
          LessonStandardData.pastSimple,             // STD
          _metarTranslation,                         // AVIA
          LessonStandardData.pastSimpleKeywords,     // STD ★
          _departureProcedures,                      // AVIA
          LessonStandardData.futureWill,             // STD
          _approachLanding,                          // AVIA
          LessonStandardData.futureKeywords,         // STD ★
          _modalVerbs,                               // AVIA
          LessonStandardData.canCould,               // STD
          _atisReading,                              // AVIA
          LessonStandardData.presentContinuous,      // STD
          _positionReports,                          // AVIA
          LessonStandardData.comparatives,           // STD
          _weatherNavigation,                        // AVIA
          LessonStandardData.conjunctions,           // STD ★
          _holdingPatterns,                          // AVIA
          _squawkTransponder,                        // AVIA
          _emergencyVocab,                           // AVIA
          _atcReadbackDrills,                        // AVIA
          _flightPhasesVocab,                        // AVIA
          _atcPhraseology,                           // AVIA
          _simpleTenses,                             // AVIA
          // ── ORTA ──────────────────────────────────────────────
          LessonStandardData.presentPerfect,         // STD
          _notamReading,                             // AVIA
          LessonStandardData.presentPerfectKeywords, // STD ★
          _ifrClearance,                             // AVIA
          LessonStandardData.conditionals1,          // STD
          _emergencyPhraseology,                     // AVIA
          LessonStandardData.relativeClauses,        // STD
          _instrumentSystems,                        // AVIA
          LessonStandardData.gerunds,                // STD
          _flightPlanReading,                        // AVIA
          LessonStandardData.pastContinuous,         // STD
          _navSystemsVocab,                          // AVIA
          LessonStandardData.pastPerfectKeywords,    // STD ★
          _tafReading,                               // AVIA
          LessonStandardData.passiveVoiceBasic,      // STD ★
          _atisDecoding,                             // AVIA
          _engineFailureLanguage,                    // AVIA
          _conditionalEmergency,                     // AVIA
          _reportedSpeech,                           // AVIA
          _articlesAviation,                         // AVIA
          _notamReadingAdv,                          // AVIA
          _advancedPassiveVoice,                     // AVIA
          _emergencyCompletion,                      // AVIA
          _opsManualTranslation,                     // AVIA
          // ── İLERİ ─────────────────────────────────────────────
          LessonStandardData.conditionals2,          // STD
          _sidStarReading,                           // AVIA
          LessonStandardData.pastPerfect,            // STD
          _accidentReport,                           // AVIA
          LessonStandardData.reportedSpeechAdv,      // STD
          _advancedAtcClearances,                    // AVIA
          LessonStandardData.mustShouldHaveTo,       // STD ★
          _humanFactorsCrm,                          // AVIA
          LessonStandardData.inversion,              // STD
          _smsLanguage,                              // AVIA
          LessonStandardData.tagQuestions,           // STD ★
          _complexStructures,                        // AVIA
          LessonStandardData.discourseMarkers,       // STD
          _expertVocab,                              // AVIA
          LessonStandardData.wishIfOnly,             // STD ★
          _regulatoryLanguage,                       // AVIA
          LessonStandardData.usedToWould,            // STD ★
          _pirepLanguage,                            // AVIA
          LessonStandardData.quantifiers,            // STD ★
          _cat3Completion,                           // AVIA
          LessonStandardData.phrasalVerbs,           // STD ★
          _fatigueLanguage,                          // AVIA
          LessonStandardData.wordFormation,          // STD ★
          _opManualSentences,                        // AVIA
          _advancedCompletion,                       // AVIA
          _accidentInvestigation,                    // AVIA
          _accidentTranslation,                      // AVIA
          _airworthinessDirectives,                  // AVIA
          _advancedAtcCompletion,                    // AVIA
          // Pilot diyalog dersleri
          _pilotDlg1, _pilotDlg2, _pilotDlg3,
        ];

      case 'cabin_crew':
        return const [
          // ── BAŞLANGIÇ ─────────────────────────────────────────
          LessonStandardData.presentSimple,          // STD
          _cabin1SafetyAnnouncements,                // AVIA
          LessonStandardData.thereIs,                // STD
          _aircraftComponents,                       // AVIA
          LessonStandardData.questions,              // STD
          _cabin2PassengerComm,                      // AVIA
          LessonStandardData.adjectives,             // STD
          _safetyEquipment,                          // AVIA
          LessonStandardData.prepositions,           // STD
          _airportGround,                            // AVIA
          LessonStandardData.articles,               // STD ★
          _natoAlphabet,                             // AVIA
          LessonStandardData.pronouns,               // STD ★
          _aviationAbbreviations,                    // AVIA
          LessonStandardData.presentSimpleKeywords,  // STD ★
          _cabin7BoardingAnnouncements,              // AVIA
          _cabin8SeatbeltDemo,                       // AVIA
          // ── TEMEL ─────────────────────────────────────────────
          LessonStandardData.pastSimple,             // STD
          _cabin3EmergencyProc,                      // AVIA
          LessonStandardData.pastSimpleKeywords,     // STD ★
          _cabin4CrmBriefing,                        // AVIA
          LessonStandardData.futureWill,             // STD
          _cabin5MedicalTerms,                       // AVIA
          LessonStandardData.futureKeywords,         // STD ★
          _cabin9ServiceLanguage,                    // AVIA
          LessonStandardData.canCould,               // STD
          _cabin10TurbulenceComm,                    // AVIA
          LessonStandardData.presentContinuous,      // STD
          _passiveVoice,                             // AVIA
          LessonStandardData.comparatives,           // STD
          _modalVerbs,                               // AVIA
          LessonStandardData.conjunctions,           // STD ★
          _emergencyVocab,                           // AVIA
          _cabin6DangerousGoods,                     // AVIA
          _weatherPhenomena,                         // AVIA
          // ── ORTA ──────────────────────────────────────────────
          LessonStandardData.presentPerfect,         // STD
          _cabin11MedicalReporting,                  // AVIA
          LessonStandardData.presentPerfectKeywords, // STD ★
          _cabin12EvacuationCommands,                // AVIA
          LessonStandardData.conditionals1,          // STD
          _cabin13ConflictResolution,                // AVIA
          LessonStandardData.relativeClauses,        // STD
          _cabin14CustomsForms,                      // AVIA
          LessonStandardData.gerunds,                // STD
          _cabin15CrewRest,                          // AVIA
          LessonStandardData.pastContinuous,         // STD
          _atcFillBlanks,                            // AVIA
          LessonStandardData.pastPerfectKeywords,    // STD ★
          _preflightChecklist,                       // AVIA
          LessonStandardData.passiveVoiceBasic,      // STD ★
          _metarTranslation,                         // AVIA
          _reportedSpeech,                           // AVIA
          _simpleTenses,                             // AVIA
          // ── İLERİ ─────────────────────────────────────────────
          LessonStandardData.conditionals2,          // STD
          _cabin16MaydayPanPan,                      // AVIA
          LessonStandardData.pastPerfect,            // STD
          _cabin17InfantSafety,                      // AVIA
          LessonStandardData.reportedSpeechAdv,      // STD
          _cabin18ServiceFailure,                    // AVIA
          LessonStandardData.mustShouldHaveTo,       // STD ★
          _humanFactorsCrm,                          // AVIA
          LessonStandardData.inversion,              // STD
          _smsLanguage,                              // AVIA
          LessonStandardData.tagQuestions,           // STD ★
          _emergencyPhraseology,                     // AVIA
          LessonStandardData.discourseMarkers,       // STD
          _regulatoryLanguage,                       // AVIA
          LessonStandardData.wishIfOnly,             // STD ★
          _expertVocab,                              // AVIA
          LessonStandardData.usedToWould,            // STD ★
          LessonStandardData.quantifiers,            // STD ★
          LessonStandardData.phrasalVerbs,           // STD ★
          LessonStandardData.wordFormation,          // STD ★
          // Kabin diyalog dersleri
          _cabinDlg1, _cabinDlg2,
        ];

      case 'amt':
        return const [
          // ── BAŞLANGIÇ ─────────────────────────────────────────
          LessonStandardData.presentSimple,          // STD
          _amt1AmmLanguage,                          // AVIA
          LessonStandardData.thereIs,                // STD
          _aircraftComponents,                       // AVIA
          LessonStandardData.questions,              // STD
          _amt2Abbreviations,                        // AVIA
          LessonStandardData.adjectives,             // STD
          _aviationAbbreviations,                    // AVIA
          LessonStandardData.prepositions,           // STD
          _passiveVoice,                             // AVIA
          LessonStandardData.articles,               // STD ★
          _modalVerbs,                               // AVIA
          LessonStandardData.pronouns,               // STD ★
          _amt3Airworthiness,                        // AVIA
          LessonStandardData.presentSimpleKeywords,  // STD ★
          _amt4RegulatoryLang,                       // AVIA
          // ── TEMEL ─────────────────────────────────────────────
          LessonStandardData.pastSimple,             // STD
          _amt5DefectReporting,                      // AVIA
          LessonStandardData.pastSimpleKeywords,     // STD ★
          _amt6WorkOrder,                            // AVIA
          LessonStandardData.futureWill,             // STD
          _amt7TechnicalLog,                         // AVIA
          LessonStandardData.futureKeywords,         // STD ★
          _amt8InspectionTerms,                      // AVIA
          LessonStandardData.canCould,               // STD
          _amt9EngineRunup,                          // AVIA
          LessonStandardData.presentContinuous,      // STD
          _simpleTenses,                             // AVIA
          LessonStandardData.comparatives,           // STD
          _atcFillBlanks,                            // AVIA
          LessonStandardData.conjunctions,           // STD ★
          _preflightChecklist,                       // AVIA
          // ── ORTA ──────────────────────────────────────────────
          LessonStandardData.presentPerfect,         // STD
          _amt10CorrosionReport,                     // AVIA
          LessonStandardData.presentPerfectKeywords, // STD ★
          _amt11NdtTerms,                            // AVIA
          LessonStandardData.conditionals1,          // STD
          _amt12HydraulicSystem,                     // AVIA
          LessonStandardData.relativeClauses,        // STD
          _amt13AvionicsTroubleshooting,             // AVIA
          LessonStandardData.gerunds,                // STD
          _amt14PartsLogistics,                      // AVIA
          LessonStandardData.pastContinuous,         // STD
          _notamReading,                             // AVIA
          LessonStandardData.pastPerfectKeywords,    // STD ★
          _airworthinessDirectives,                  // AVIA
          LessonStandardData.passiveVoiceBasic,      // STD ★
          _reportedSpeech,                           // AVIA
          _advancedPassiveVoice,                     // AVIA
          // ── İLERİ ─────────────────────────────────────────────
          LessonStandardData.conditionals2,          // STD
          _amt15CertificationRelease,                // AVIA
          LessonStandardData.pastPerfect,            // STD
          _amt16FuelSystem,                          // AVIA
          LessonStandardData.reportedSpeechAdv,      // STD
          _amt17LandingGear,                         // AVIA
          LessonStandardData.mustShouldHaveTo,       // STD ★
          _amt18SafetyMgmt,                          // AVIA
          LessonStandardData.inversion,              // STD
          _regulatoryLanguage,                       // AVIA
          LessonStandardData.tagQuestions,           // STD ★
          _smsLanguage,                              // AVIA
          LessonStandardData.discourseMarkers,       // STD
          _humanFactorsCrm,                          // AVIA
          LessonStandardData.wishIfOnly,             // STD ★
          _expertVocab,                              // AVIA
          LessonStandardData.usedToWould,            // STD ★
          _complexStructures,                        // AVIA
          LessonStandardData.quantifiers,            // STD ★
          LessonStandardData.phrasalVerbs,           // STD ★
          LessonStandardData.wordFormation,          // STD ★
          // AMT diyalog dersleri
          _amtDlg1,
        ];

      case 'student':
      default:
        return const [
          // ── BAŞLANGIÇ ─────────────────────────────────────────
          LessonStandardData.presentSimple,          // STD
          _natoAlphabet,                             // AVIA
          LessonStandardData.thereIs,                // STD
          _aircraftComponents,                       // AVIA
          LessonStandardData.questions,              // STD
          _basicAtcInstructions,                     // AVIA
          LessonStandardData.adjectives,             // STD
          _airportGround,                            // AVIA
          LessonStandardData.prepositions,           // STD
          _safetyEquipment,                          // AVIA
          LessonStandardData.articles,               // STD ★
          _aviationAbbreviations,                    // AVIA
          LessonStandardData.pronouns,               // STD ★
          _basicWeatherFill,                         // AVIA
          LessonStandardData.presentSimpleKeywords,  // STD ★
          _passiveVoice,                             // AVIA
          _atcFillBlanks,                            // AVIA
          _preflightChecklist,                       // AVIA
          _runwayTaxiway,                            // AVIA
          // ── TEMEL ─────────────────────────────────────────────
          LessonStandardData.pastSimple,             // STD
          _metarTranslation,                         // AVIA
          LessonStandardData.pastSimpleKeywords,     // STD ★
          _departureProcedures,                      // AVIA
          LessonStandardData.futureWill,             // STD
          _approachLanding,                          // AVIA
          LessonStandardData.futureKeywords,         // STD ★
          _modalVerbs,                               // AVIA
          LessonStandardData.canCould,               // STD
          _atisReading,                              // AVIA
          LessonStandardData.presentContinuous,      // STD
          _positionReports,                          // AVIA
          LessonStandardData.comparatives,           // STD
          _weatherNavigation,                        // AVIA
          LessonStandardData.conjunctions,           // STD ★
          _holdingPatterns,                          // AVIA
          _squawkTransponder,                        // AVIA
          _emergencyVocab,                           // AVIA
          _atcReadbackDrills,                        // AVIA
          _flightPhasesVocab,                        // AVIA
          _simpleTenses,                             // AVIA
          // ── ORTA ──────────────────────────────────────────────
          LessonStandardData.presentPerfect,         // STD
          _notamReading,                             // AVIA
          LessonStandardData.presentPerfectKeywords, // STD ★
          _ifrClearance,                             // AVIA
          LessonStandardData.conditionals1,          // STD
          _emergencyPhraseology,                     // AVIA
          LessonStandardData.relativeClauses,        // STD
          _instrumentSystems,                        // AVIA
          LessonStandardData.gerunds,                // STD
          _flightPlanReading,                        // AVIA
          LessonStandardData.pastContinuous,         // STD
          _navSystemsVocab,                          // AVIA
          LessonStandardData.pastPerfectKeywords,    // STD ★
          _tafReading,                               // AVIA
          LessonStandardData.passiveVoiceBasic,      // STD ★
          _reportedSpeech,                           // AVIA
          _articlesAviation,                         // AVIA
          // ── İLERİ ─────────────────────────────────────────────
          LessonStandardData.conditionals2,          // STD
          _sidStarReading,                           // AVIA
          LessonStandardData.pastPerfect,            // STD
          _accidentReport,                           // AVIA
          LessonStandardData.reportedSpeechAdv,      // STD
          _humanFactorsCrm,                          // AVIA
          LessonStandardData.mustShouldHaveTo,       // STD ★
          _smsLanguage,                              // AVIA
          LessonStandardData.inversion,              // STD
          _regulatoryLanguage,                       // AVIA
          LessonStandardData.tagQuestions,           // STD ★
          _expertVocab,                              // AVIA
          LessonStandardData.discourseMarkers,       // STD
          _complexStructures,                        // AVIA
          LessonStandardData.wishIfOnly,             // STD ★
          LessonStandardData.usedToWould,            // STD ★
          LessonStandardData.quantifiers,            // STD ★
          LessonStandardData.phrasalVerbs,           // STD ★
          LessonStandardData.wordFormation,          // STD ★
          // Öğrenci diyalog dersleri
          _studentDlg1,
        ];
    }
  }

  // ─────────────────────────────────────────────────────────────
  // LESSON 1 — Passive Voice
  // ─────────────────────────────────────────────────────────────
  static const _passiveVoice = LessonContent(
    id: 'grammar_1',
    title: 'Edilgen Çatı',
    subtitle: 'Havacılık görevlerinin nasıl anlatıldığı',
    categoryId: 'grammar',
    estimatedTime: '10 dk',
    emoji: '🔧',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Edilgen çatı neden önemlidir',
        body:
            'Havacılık İngilizcesi büyük ölçüde **edilgen çatı**ya dayanır. Bakım kılavuzları, kontrol listeleri ve ATC talimatları, eylemi gerçekleştirenden değil **yapılan eylemin daha önemli** olduğu durumlarda edilgen yapıları sıkça kullanır.\n\nÖrneğin, "The fuel filter must be replaced" ifadesi "You must replace the fuel filter" ifadesinden daha kesin ve profesyoneldir.',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Dönüşmü gör',
        animationType: GrammarAnimationType.passiveVoice,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı Kuralı',
        body:
            '**Active:** Subject + **verb** + object\n**Passive:** Object + **be** + past participle (+ by + agent)\n\n**Tense mapping:**\n• Simple Present → is/are + V3\n• Simple Past → was/were + V3\n• Must/Should → must/should + be + V3\n• Has/Have → has/have + been + V3',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Havacılık Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'The hydraulic pump is driven by the engine through a gearbox.',
            highlight: 'is driven',
            translation: 'Hidrolik pompa, motor tarafından dişli kutusu aracılığıyla çalıştırılır.',
          ),
          ExampleSentence(
            sentence: 'All maintenance tasks must be performed in accordance with the AMM.',
            highlight: 'must be performed',
            translation: 'Tüm bakım görevleri AMM\'ye uygun şekilde gerçekleştirilmelidir.',
          ),
          ExampleSentence(
            sentence: 'The fuel filter is replaced every 500 flight hours.',
            highlight: 'is replaced',
            translation: 'Yakıt filtresi her 500 uçuş saatinde değiştirilir.',
          ),
          ExampleSentence(
            sentence: 'Warning notices must be placed in the cockpit before maintenance.',
            highlight: 'must be placed',
            translation: 'Bakımdan önce kokpite uyarı levhaları yerleştirilmelidir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Cümle Yapısını Gör',
        animationType: GrammarAnimationType.sentenceStructure,
        sentenceTokens: [
          [
            SentenceToken('The fuel filter', 'subject', 'Özne'),
            SentenceToken('was replaced', 'verb', 'Fiil (Edilgen)'),
            SentenceToken('by the engineer', 'adverbial', 'Zarflık'),
          ],
          [
            SentenceToken('All checklists', 'subject', 'Özne'),
            SentenceToken('must be completed', 'verb', 'Fiil (Edilgen)'),
            SentenceToken('before departure', 'adverbial', 'Zarflık'),
          ],
          [
            SentenceToken('The aircraft', 'subject', 'Özne'),
            SentenceToken('was cleared', 'verb', 'Fiil (Edilgen)'),
            SentenceToken('for landing', 'adverbial', 'Zarflık'),
            SentenceToken('by ATC', 'adverbial', 'Zarflık'),
          ],
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Çoktan seçmeli sorularda ipucu ara:\n• Özne bir **nesne** ise (kişi değilse), büyük ihtimalle edilgen çatı doğrudur.\n• "………… by the engine" → edilgen form gerekir.\n• Modal fiil + edilgen: **must be + geçmiş zaman ortacı** kalıbı havacılık bakım İngilizcesinde en yaygın yapıdır.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -1,
            category: QuestionCategory.grammar,
            originalNumber: 1,
            questionText: 'The hydraulic pump ………… by the engine through a gearbox.',
            options: ['drives', 'is driven', 'are driven', 'driving'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -2,
            category: QuestionCategory.grammar,
            originalNumber: 2,
            questionText: 'All maintenance tasks ………… in accordance with the Aircraft Maintenance Manual.',
            options: ['perform', 'must perform', 'must be performed', 'must performing'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -3,
            category: QuestionCategory.grammar,
            originalNumber: 5,
            questionText: 'The warning notice ………… in the cockpit to prevent operation of flight controls during maintenance.',
            options: ['places', 'placed', 'must be placed', 'must place'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -4,
            category: QuestionCategory.grammar,
            originalNumber: 6,
            questionText: 'All contaminated parts ………… for laboratory analysis.',
            options: ['should keep', 'should be kept', 'keeping', 'must keep'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 2 — Modal Verbs
  // ─────────────────────────────────────────────────────────────
  static const _modalVerbs = LessonContent(
    id: 'grammar_2',
    title: 'Havacılıkta Modal Fiiller',
    subtitle: 'must, should, may, can — her birini ne zaman kullanacağını bilmek',
    categoryId: 'grammar',
    estimatedTime: '12 dk',
    emoji: '📋',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Modal fiiller zorunluluk ve izin ifade eder',
        body:
            'Modal fiiller, **zorunluluk derecelerini** ifade ettiği için havacılık İngilizcesinde son derece önemlidir. "must" ile "should" arasındaki fark güvenlik sonuçları doğurabilir.\n\n**must** = zorunlu (yasal gereklilik)\n**should** = önerilen (en iyi uygulama)\n**may** = izin verilen (serbest)\n**can** = yetenek / teorik olasılık',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Modal güç skalası',
        animationType: GrammarAnimationType.modalVerbs,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Modal + Fiil Yapısı',
        body:
            '**Rule:** Modal verb + **base infinitive** (no "to", no "-s", no "-ing")\n\n✓ The pilot **must check** the fuel level.\n✗ The pilot must **checks** / must **checking** / must **to check**\n\n**With passive:**\nModal + **be** + past participle\n✓ The engine **must be shut down** before maintenance.\n✓ Parts **should be inspected** visually.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Bağlamda Modal Fiiller',
        examples: [
          ExampleSentence(
            sentence: 'The engine must be shut down before any maintenance work begins.',
            highlight: 'must be shut down',
            translation: 'Herhangi bir bakım çalışması başlamadan önce motor kapatılmalıdır.',
          ),
          ExampleSentence(
            sentence: 'Technicians should wear protective equipment when handling fuel.',
            highlight: 'should wear',
            translation: 'Teknisyenler yakıt ile çalışırken koruyucu ekipman takmalıdır.',
          ),
          ExampleSentence(
            sentence: 'The aircraft may depart after all checks are completed.',
            highlight: 'may depart',
            translation: 'Tüm kontroller tamamlandıktan sonra uçak kalkabilir.',
          ),
          ExampleSentence(
            sentence: 'Contaminated parts must not be reinstalled without inspection.',
            highlight: 'must not be reinstalled',
            translation: 'Kirlenmiş parçalar incelenmeden yeniden takılmamalıdır.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Modal sorularında yaygın tuzaklar:\n• "must checking" → YANLIŞ (modal + yalın fiil, -ing değil)\n• "should to inspect" → YANLIŞ (modal sonrasında "to" gelmez)\n• "must performed" → YANLIŞ (edilgen için "be" gerekli: must **be** performed)\n\nModal fiil + boşluk görünce sor: etken mi yoksa edilgen anlam mı gerekiyor?',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -10,
            category: QuestionCategory.grammar,
            originalNumber: 4,
            questionText: 'The engine ………… before any maintenance work begins on the fuel system.',
            options: ['must shut down', 'must be shut down', 'should shutting down', 'would shut down'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -11,
            category: QuestionCategory.grammar,
            originalNumber: 8,
            questionText: 'After maintenance, all access panels ………… with the specified fasteners.',
            options: ['must close', 'must be closed', 'should closes', 'can closing'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -12,
            category: QuestionCategory.grammar,
            originalNumber: 20,
            questionText: 'Pilots ………… their pre-flight checklists before every departure.',
            options: ['must completing', 'must to complete', 'must complete', 'must completed'],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -13,
            category: QuestionCategory.grammar,
            originalNumber: 21,
            questionText: 'Maintenance records ………… for a minimum of two years.',
            options: ['should keep', 'should be kept', 'must keeping', 'may keeps'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 3 — Aircraft Components (Vocabulary)
  // ─────────────────────────────────────────────────────────────
  static const _aircraftComponents = LessonContent(
    id: 'vocab_1',
    title: 'Uçak Bileşenleri',
    subtitle: 'Sınav için temel teknik kelimeler',
    categoryId: 'vocabulary',
    estimatedTime: '8 dk',
    emoji: '✈️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Teknik kelime bilgisi neden önemlidir',
        body:
            'Havacılık sınavları, kesin teknik terimleri anlama ve kullanma becerinizi ölçer. Bir teknisyenin **aileron** yerine "uçağı kaldıran şey" demesi hem profesyonellikten uzak hem de tehlikelidir.\n\nBu ders, uçak sistemine göre gruplandırılmış en sık sınanan bileşenleri kapsar.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛩️ Uçuş Kontrol Yüzeyleri',
        body:
            '**Ailerons** — on the wings; control roll (bank left/right)\n**Elevator** — on the horizontal stabilizer; controls pitch (nose up/down)\n**Rudder** — on the vertical stabilizer; controls yaw (nose left/right)\n**Flaps** — on wing trailing edge; increase lift and drag during takeoff/landing\n**Spoilers** — on wings; reduce lift, increase drag, assist in roll control',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚙️ Motor & Yakıt Sistemleri',
        body:
            '**Turbine engine** — compressor → combustion chamber → turbine → nozzle\n**HP fuel shutoff valve** — high-pressure fuel control valve\n**Fuel manifold** — distributes fuel to combustion chambers\n**Gearbox** — transfers power between engine components\n**Nacelle** — streamlined housing enclosing the engine',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔧 Hidrolik & İniş Takımı',
        body:
            '**Hydraulic actuator** — converts hydraulic pressure to mechanical movement\n**Hydraulic pump** — pressurizes hydraulic fluid\n**Landing gear strut** — shock-absorbing leg of landing gear\n**Torque link** — scissors linkage preventing wheel rotation on strut\n**Brake assembly** — disc brakes on main landing gear wheels',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Kelime Yapısını Keşfet',
        animationType: GrammarAnimationType.wordBuilder,
        wordMorphemes: [
          ('AIRWORTHINESS', [
            WordMorpheme('AIR', 'root', 'hava'),
            WordMorpheme('WORTH', 'root', 'değer/layık'),
            WordMorpheme('I', 'suffix', 'bağlaç'),
            WordMorpheme('NESS', 'suffix', 'durum/nitelik'),
          ]),
          ('UNSERVICEABLE', [
            WordMorpheme('UN', 'prefix', 'olumsuzluk'),
            WordMorpheme('SERVICE', 'root', 'hizmet'),
            WordMorpheme('ABLE', 'suffix', 'yeteneğinde'),
          ]),
          ('PRESSURIZATION', [
            WordMorpheme('PRESSURE', 'root', 'basınç'),
            WordMorpheme('IZA', 'suffix', 'dönüşüm'),
            WordMorpheme('TION', 'suffix', 'eylem adı'),
          ]),
          ('TROUBLESHOOTING', [
            WordMorpheme('TROUBLE', 'root', 'sorun'),
            WordMorpheme('SHOOT', 'root', 'çözme'),
            WordMorpheme('ING', 'suffix', 'devam eden eylem'),
          ]),
        ],
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Bağlamda Örnekler',
        examples: [
          ExampleSentence(
            sentence: 'The ailerons deflect differentially to produce a rolling moment.',
            highlight: 'ailerons',
            translation: 'Eleronlar, yuvarlanma momenti üretmek için farklı açılarda sapma yapar.',
          ),
          ExampleSentence(
            sentence: 'The hydraulic pump is driven by the engine through a gearbox.',
            highlight: 'hydraulic pump',
            translation: 'Hidrolik pompa, motor tarafından dişli kutusu aracılığıyla tahrik edilir.',
          ),
          ExampleSentence(
            sentence: 'Flap extension increases the camber of the wing and generates additional lift.',
            highlight: 'Flap extension',
            translation: 'Flap açılımı kanat kavisini artırır ve ilave kaldırma kuvveti üretir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Kelime soruları çoğunlukla **eş anlamlı** sorar. Yaygın tuzaklar:\n• "nacelle" ≠ "fuselage" (nacelle motor kovanıdır)\n• "aileron" **roll** (yuvarlama) eksenini kontrol eder, yaw değil\n• "elevator" **pitch** (yunuslama) eksenini kontrol eder, roll değil\n\nEzber formülü: **A**ileron → **A**ks (roll), **E**levator → **E**levasyonu (pitch), **R**udder → **R**otasyon (yaw).',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -20,
            category: QuestionCategory.vocabulary,
            originalNumber: 251,
            questionText: 'Which control surface is primarily responsible for controlling the roll of an aircraft?',
            options: ['Elevator', 'Rudder', 'Aileron', 'Flap'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -21,
            category: QuestionCategory.vocabulary,
            originalNumber: 252,
            questionText: 'What is the function of the rudder?',
            options: ['Controls pitch', 'Controls roll', 'Controls yaw', 'Controls speed'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -22,
            category: QuestionCategory.vocabulary,
            originalNumber: 253,
            questionText: 'The "nacelle" refers to which part of the aircraft?',
            options: ['The fuselage section', 'The engine housing', 'The cockpit area', 'The cargo hold'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -23,
            category: QuestionCategory.vocabulary,
            originalNumber: 254,
            questionText: 'Which device converts hydraulic pressure into mechanical movement?',
            options: ['Hydraulic pump', 'Hydraulic reservoir', 'Hydraulic actuator', 'Hydraulic manifold'],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 4 — Fill in the Blanks: ATC
  // ─────────────────────────────────────────────────────────────
  static const _atcFillBlanks = LessonContent(
    id: 'fill_1',
    title: 'Boşluk Doldurma: ATC',
    subtitle: 'ATC iletişim ifadelerini tamamlama',
    categoryId: 'fill_blanks',
    estimatedTime: '9 dk',
    emoji: '🗼',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'ATC ifade kalıpları standarttır',
        body:
            'Hava Trafik Kontrol iletişimleri ICAO standart ifade kalıplarını izler. Boşluk doldurma soruları, klirens, talimat ve tekrar (readback) ifadelerinde kullanılan **tam kelimeleri** bilip bilmediğinizi sınar.\n\nAnahtar, her ifade türünün **yapısını** anlamaktır; böylece her ifadeyi ezberlemenize gerek kalmadan eksik kelimeyi bulabilirsiniz.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛫 Klirans Yapısı',
        body:
            'Standart bir ATC kliransı şu kalıbı izler:\n\n**Uçak kimliği** + klirans limiti + rota + irtifa + hız + squawk\n\nÖrnek: "THY123, **cleared to** İstanbul, via KEMER, **climb and maintain** FL350, squawk 4521."\n\nTemel fiiller: **cleared**, **maintain**, **climb**, **descend**, **turn**, **contact**, **report**',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📻 Tekrar Etme Kuralları',
        body:
            'Pilotlar aşağıdakilerin hepsini **tekrar etmek** (**read back**) zorundadır:\n• Kullanılan pist\n• Altimetre ayarları\n• İrtifa/uçuş seviyesi\n• Yön talimatları\n• Hız talimatları\n• Frekans değişiklikleri\n• Transponder kodları\n• Taksi talimatları (kontrollü havalimanlarında)\n\n**Standart ifade:** "Cleared to FL350, THY123." (tekrarda çağrı kodu sonda söylenir)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'İfade Kalıbı Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'THY123, descend and maintain flight level 150.',
            highlight: 'descend and maintain',
            translation: 'THY123, alçal ve uçuş seviyesi 150\'yi koru.',
          ),
          ExampleSentence(
            sentence: 'Cleared for ILS approach runway 36R, report established.',
            highlight: 'report established',
            translation: 'İLS yaklaşımı pist 36R için yetkilendirildiniz, iniş glide slope\'unda olduğunuzda bildirin.',
          ),
          ExampleSentence(
            sentence: 'Hold short of runway 18L, traffic on final.',
            highlight: 'Hold short',
            translation: 'Pist 18L\'ye girmeden bekleyin, finalden gelen trafik var.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav Stratejisi',
        body:
            'ATC boşluk doldurma sorularında:\n1. Önce **tümceyi baştan sona** oku — durumu anla\n2. Gereken **fiil türünü** belirle (klirens mi, talimat mı, rapor mu?)\n3. **Eleme** yöntemini uygula — dilbilgisel olarak yanlış seçenekleri önce çıkar\n4. **Edatlara** dikkat et: "cleared **to**", "cleared **for**", "climb **to**", "maintain **at**"',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -30,
            category: QuestionCategory.fillBlanks,
            originalNumber: 751,
            questionText: 'THY123, ………… runway 36R, wind 350 degrees, 12 knots.',
            options: ['cleared to land', 'cleared for landing', 'cleared landing', 'clear to land'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -31,
            category: QuestionCategory.fillBlanks,
            originalNumber: 752,
            questionText: 'Descend ………… flight level 250, report passing flight level 300.',
            options: ['at', 'to and maintain', 'until', 'for'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -32,
            category: QuestionCategory.fillBlanks,
            originalNumber: 753,
            questionText: 'THY123, ………… heading 090 for traffic separation.',
            options: ['fly', 'turn left', 'turn right heading', 'fly heading'],
            correctIndex: 3,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -33,
            category: QuestionCategory.fillBlanks,
            originalNumber: 754,
            questionText: 'Contact Istanbul Approach ………… 119.7.',
            options: ['at frequency', 'on', 'with', 'for'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 5 — Conditional Sentences
  // ─────────────────────────────────────────────────────────────
  static const _conditionals = LessonContent(
    id: 'grammar_3',
    title: 'Koşul Cümleleri',
    subtitle: 'Havacılıkta gerçek ve varsayımsal durumlar',
    categoryId: 'grammar',
    estimatedTime: '11 dk',
    emoji: '🔀',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Koşul cümleleri neden-sonuç ilişkisi kurar',
        body:
            'Havacılık prosedürleri çoğunlukla belirli bir koşul gerçekleştiğinde ne olacağını anlatır. Acil durum kontrol listeleri, operasyon kılavuzları ve sınav soruları koşul cümlelerine yoğun biçimde dayanır.\n\nHangi koşul cümlesi tipini kullanacağınız, durumun **gerçek/olası** mı yoksa **varsayımsal/imkânsız** mı olduğuna göre belirlenir.',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Bir bakışta koşul tipleri',
        animationType: GrammarAnimationType.conditionals,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Üç Ana Tip',
        body:
            '**Type 1 — Real/Possible (present/future)**\nIf + present simple, will/can/must + base verb\n→ "If the oil pressure drops, the pilot **will** declare an emergency."\n\n**Type 2 — Hypothetical (present/future)**\nIf + past simple, would/could + base verb\n→ "If the engine **failed**, the crew **would** follow the ECAM."\n\n**Type 3 — Impossible (past)**\nIf + past perfect, would/could + have + past participle\n→ "If the crew **had noticed** the leak, they **would have** diverted."',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Havacılıkta Koşul Cümleleri',
        examples: [
          ExampleSentence(
            sentence: 'If the fuel quantity drops below minimum, the aircraft must return to base.',
            highlight: 'If the fuel quantity drops',
            translation: 'Yakıt miktarı minimumun altına düşerse uçak üsse dönmelidir.',
          ),
          ExampleSentence(
            sentence: 'If the hydraulic system were to fail, the pilot would use backup controls.',
            highlight: 'were to fail',
            translation: 'Hidrolik sistem arıza yapsa pilot yedek kontrolleri kullanırdı.',
          ),
          ExampleSentence(
            sentence: 'If maintenance had been performed on time, the fault would not have occurred.',
            highlight: 'had been performed',
            translation: 'Bakım zamanında yapılsaydı arıza meydana gelmezdi.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Hızlı tanıma yöntemi:\n• Sonuç yan cümlesinde "will" → **Tip 1** (gerçek)\n• "would" + yalın fiil → **Tip 2** (varsayımsal)\n• "would have" + geçmiş zaman ortacı → **Tip 3** (geçmiş)\n\n"unless" = "if not" dikkat:\n"Unless the checklist is completed, departure is not permitted."\n= Kontrol listesi **tamamlanmazsa** kalkışa izin verilmez.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -40,
            category: QuestionCategory.grammar,
            originalNumber: 100,
            questionText: 'If the oil pressure ………… below the minimum, the pilot must shut down the engine.',
            options: ['will drop', 'drops', 'dropped', 'would drop'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -41,
            category: QuestionCategory.grammar,
            originalNumber: 101,
            questionText: 'If the de-icing system had been activated earlier, the accident ………… avoided.',
            options: ['could be', 'could have been', 'can be', 'will be'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -42,
            category: QuestionCategory.grammar,
            originalNumber: 102,
            questionText: 'Unless all systems ………… serviceable, the aircraft should not depart.',
            options: ['are', 'were', 'will be', 'have been'],
            correctIndex: 0,
            difficulty: Difficulty.hard,
          ),
          QuestionModel(
            id: -43,
            category: QuestionCategory.grammar,
            originalNumber: 103,
            questionText: 'If the runway ………… contaminated, takeoff performance must be recalculated.',
            options: ['is', 'was', 'would be', 'were'],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 6 — Weather & Navigation Vocabulary
  // ─────────────────────────────────────────────────────────────
  static const _weatherNavigation = LessonContent(
    id: 'vocab_2',
    title: 'Hava Durumu & Navigasyon',
    subtitle: 'METAR, TAF ve navigasyon terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '🌤️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Hava durumu havacılık için kritiktir',
        body:
            'Hava raporları ve navigasyon belgeleri yüksek düzeyde standardize edilmiş kelime bilgisi kullanır. METAR, TAF, NOTAM ve ATIS, pilotların ve kontrolörlerin aninda anlaması gereken belirli terimler içerir.\n\nBu ders, en sık sınanan hava durumu ve navigasyon terimlerini kapsar.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🌦️ Hava Olayları',
        body:
            '**CAVOK** — Ceiling And Visibility OK (vis >10km, no cloud below 5000ft, no significant weather)\n**BECMG** — Becoming (gradual change within a period)\n**TEMPO** — Temporary fluctuations lasting less than 1 hour\n**CB** — Cumulonimbus (thunderstorm cloud, avoid by 20nm)\n**TSRA** — Thunderstorm with rain\n**FG** — Fog | **BR** — Mist | **RA** — Rain | **SN** — Snow',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🧭 Navigasyon Terimleri',
        body:
            '**Track** — actual path over the ground\n**Heading** — direction the nose is pointing\n**Bearing** — direction from one point to another\n**QNH** — altimeter setting (sea level pressure in hPa)\n**QFE** — altimeter setting (airfield elevation, reads zero on ground)\n**ATIS** — Automatic Terminal Information Service\n**VOR/DME** — VHF Omni Range / Distance Measuring Equipment',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'METAR Örneği',
        examples: [
          ExampleSentence(
            sentence: 'METAR LTBA 120850Z 35015KT 9999 FEW030 SCT100 18/08 Q1013 NOSIG',
            highlight: 'NOSIG',
            translation: 'İstanbul Atatürk, 12. gün 08:50 UTC, rüzgar 350°/15 knot, görüş >10km, 3000ft AGL az bulut, 18°C, Q1013, değişiklik yok.',
          ),
          ExampleSentence(
            sentence: 'Wind shear has been reported on the approach to runway 18L.',
            highlight: 'Wind shear',
            translation: 'Pist 18L yaklaşmasında rüzgar kırılması bildirildi.',
          ),
          ExampleSentence(
            sentence: 'Cumulonimbus clouds must be avoided by at least 20 nautical miles.',
            highlight: 'Cumulonimbus',
            translation: 'Kümülonimbus bulutlarından en az 20 deniz mili uzak durulmalıdır.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'METAR okuma sırası (her zaman aynıdır):\nStation → Date/Time → Wind → Visibility → Weather → Cloud → Temperature/Dewpoint → QNH → Trend\n\n"QNH" ile "QFE" farkı:\n• **QNH** → deniz seviyesinden yükseklik (standart, yolculuk fazında kullanılır)\n• **QFE** → pist yüzeyinden yükseklik (yerde sıfır gösterir)\n\nSınav sorularının büyük çoğunluğu QNH hakkındadır.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -50,
            category: QuestionCategory.vocabulary,
            originalNumber: 300,
            questionText: 'In a METAR, "CAVOK" means:',
            options: [
              'Ceiling above visibility OK',
              'Ceiling and visibility are satisfactory with no significant weather',
              'Clouds are visible at low altitude',
              'Clear air visibility over 5km',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -51,
            category: QuestionCategory.vocabulary,
            originalNumber: 301,
            questionText: 'What does "TEMPO" indicate in a TAF forecast?',
            options: [
              'Temporary changes lasting less than 1 hour, occurring less than half the period',
              'Temperature changes expected',
              'Permanent forecast conditions',
              'Terminal area meteorological observations',
            ],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -52,
            category: QuestionCategory.vocabulary,
            originalNumber: 302,
            questionText: 'The altimeter setting that causes the altimeter to read zero on the ground at the aerodrome is:',
            options: ['QNH', 'QFE', 'QNE', 'STD'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 7 — ATC Phraseology EN→TR
  // ─────────────────────────────────────────────────────────────
  static const _atcPhraseology = LessonContent(
    id: 'translation_1',
    title: 'ATC İfade Kalıpları EN→TR',
    subtitle: 'Standart ATC ifadelerini doğru çevirme',
    categoryId: 'translation',
    estimatedTime: '10 dk',
    emoji: '🗣️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Havacılıkta kesin çeviri',
        body:
            'Çeviri soruları, havacılık ifadelerinin **teknik anlamını** ve doğru Türkçe karşılıklarını anlayanıp anlamadığınızı sınar.\n\nYanlış bir çeviri prosedür yanlış anlaşılmasına işaret edebildiğinden bu sorular sınavlarda önemli ağırlık taşır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔑 Temel İfade Çevirileri',
        body:
            '"**Cleared to land**" → Piste inişe yetkilendirildiniz\n"**Go around**" → Tırmaniş yapın / Alçalışı iptal edin\n"**Hold short**" → Girmeden bekleyin\n"**Line up and wait**" → Sıraya girin ve bekleyin\n"**Contact [unit] on [freq]**" → [birim] ile [frekans] üzerinde temasa geçin\n"**Report final**" → Final pistine geldiğinizde bildirin\n"**Confirm**" → Teyit edin\n"**Affirm**" → Evet/Doğru (Teyit ederim)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Çeviri Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'THY123, descend and maintain flight level 150.',
            translation: 'THY123, alçal ve uçuş seviyesi 150\'de kal.',
            highlight: 'descend and maintain',
          ),
          ExampleSentence(
            sentence: 'THY123, go around, I say again, go around.',
            translation: 'THY123, tırmanış yapın, tekrar ediyorum, tırmanış yapın.',
            highlight: 'go around',
          ),
          ExampleSentence(
            sentence: 'THY123, you are cleared to land runway 36R.',
            translation: 'THY123, pist 36R\'ye inişe yetkilendirildiniz.',
            highlight: 'cleared to land',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Çeviri İpuçları',
        body:
            'Kaçınılması gereken yaygın çeviri hataları:\n• "Hold position" ≠ "pisti tutun" → Doğrusu: "bulunduğunuz yerde bekleyin"\n• "Expedite" ≠ "acele edin" → Doğrusu: "mümkün olan en kısa sürede (yapın)"\n• "Wilco" ≠ "tamam" → Doğrusu: "anlıyorum ve gereğini yapacağım"\n• "Roger" = "mesajınız alındı" (onay değil, sadece teslim alma)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -60,
            category: QuestionCategory.translation,
            originalNumber: 426,
            questionText: '"Go around" ifadesinin Türkçe karşılığı nedir?',
            options: [
              'Etrafta dön',
              'Alçalış prosedürünü iptal et ve tırmanış yap',
              'Pistın çevresinde uç',
              'Sola dön',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -61,
            category: QuestionCategory.translation,
            originalNumber: 427,
            questionText: '"Hold short of runway 18L" ifadesinin doğru Türkçe çevirisi hangisidir?',
            options: [
              'Pist 18L\'de bekleyin',
              'Pist 18L\'yi geçin',
              'Pist 18L\'ye girmeden önce bekleyin',
              'Pist 18L\'de kısa süre durun',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -62,
            category: QuestionCategory.translation,
            originalNumber: 428,
            questionText: '"Wilco" kelimesinin anlamı nedir?',
            options: [
              'Anlamıyorum',
              'Mesajınız alındı',
              'Anlıyorum ve gereğini yapacağım',
              'Tekrar edin',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 8 — NOTAM Reading
  // ─────────────────────────────────────────────────────────────
  static const _notamReading = LessonContent(
    id: 'reading_1',
    title: 'NOTAM Okuma',
    subtitle: 'Havacılık Bildirimlerini Anlama',
    categoryId: 'reading',
    estimatedTime: '12 dk',
    emoji: '📄',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'NOTAM nedir?',
        body:
            'Bir **NOTAM** (Notice to Air Missions — Havacılık Operasyonlarına Bildirim), uçuş operasyonlarıyla ilgili personele dağıtılan resmi bir bildirimdir. Herhangi bir havacılık tesisi, hizmet, prosedür veya tehlike hakkında oluşturma, durum veya değişiklik bilgisi içerir.\n\nOkuma anlama soruları çoğunlukla NOTAM tarzı metinler ya da bakım/muayene belgeleri kullanır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 NOTAM Yapısı',
        body:
            'Bir NOTAM şunları içerir:\n**Q)** — Konu/durum/trafik kodları\n**A)** — Konum (ICAO kodu)\n**B)** — Başlangıç tarihi/saati\n**C)** — Bitiş tarihi/saati\n**E)** — Tam metin açıklaması\n\nÖrnek yapı:\n"A0123/24 NOTAMN\nQ) LTAA/QMRLC/IV/NBO/A/000/999/4059N02858E005\n**A) LTBA B) 2401150600 C) 2401152359**\n**E) RWY 36L/18R CLOSED FOR MAINTENANCE\"**',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔍 Okuma Anlama Stratejisi',
        body:
            'Herhangi bir havacılık metni için (NOTAM, rapor, kılavuz alıntısı):\n1. **Önce tara** — belge türünü ve konuyu belirle\n2. **Soruyu oku, sonra metni yeniden oku** — neye bakacağını bil\n3. **Anahtar gerçekleri bul** — tarihler, yerler, kısıtlamalar, gereklilikler\n4. **Olumsuzlamalara dikkat et** — "not", "except", "unless" anlamı tamamen değiştirir\n5. **Varsayımdan kaçın** — yalnızca verilen metinden yanıt ver',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnek Pasaj',
        examples: [
          ExampleSentence(
            sentence: 'Detailed Inspection (DI) is an intensive examination of a specific item to detect damage, failure or irregularity.',
            translation: 'Detaylı Muayene (DI), hasar, arıza veya düzensizlikleri tespit etmek için belirli bir ürünün yoğun incelemesidir.',
            highlight: 'detect damage, failure or irregularity',
          ),
          ExampleSentence(
            sentence: 'Available lighting is normally supplemented with a direct source of good lighting at an intensity deemed appropriate.',
            translation: 'Mevcut aydınlatma normalde uygun görülen yoğunlukta iyi bir aydınlatma kaynağıyla desteklenir.',
            highlight: 'supplemented',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Okuma İpuçları',
        body:
            'Soru türlerine dikkat et:\n• **"Ana amaç nedir?"** → açılış tanım cümlesini ara\n• **"Hangisi GEREKLİ DEĞİLDİR?"** → listeyi bul ve eksik/dışlanan ögeyi belirle\n• **"Metne göre..."** → yanıt açıkça belirtilmiş olmalı, çıkarım yapılmamalı\n• **"X neyi inceler?"** → anahtar fiilin doğrudan nesnesini bul',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        body: 'Read the following passage, then answer the questions.\n\n"Detailed Inspection (DI) is an intensive examination of a specific item, installation, or assembly to detect damage, failure or irregularity. Available lighting is normally supplemented with a direct source of good lighting at an intensity deemed appropriate. Inspection aids such as mirrors, magnifying lenses etc. may be necessary. Surface cleaning and elaborate access procedures may be required."',
        practiceQuestions: [
          QuestionModel(
            id: -70,
            category: QuestionCategory.reading,
            originalNumber: 601,
            questionText: 'What is the main purpose of a Detailed Inspection?',
            options: [
              'To replace damaged components',
              'To detect damage, failure, or irregularity',
              'To clean the surface of the aircraft',
              'To troubleshoot system malfunctions',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -71,
            category: QuestionCategory.reading,
            originalNumber: 602,
            questionText: 'Which of the following is NOT necessarily required for a Detailed Inspection?',
            options: [
              'Direct source of good lighting',
              'Inspection aids such as mirrors',
              'Complete disassembly of the aircraft',
              'Surface cleaning',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -72,
            category: QuestionCategory.reading,
            originalNumber: 603,
            questionText: 'What does a Detailed Inspection examine?',
            options: [
              'An entire aircraft at once',
              'The aircraft\'s documentation',
              'A specific item, installation, or assembly',
              'Only the exterior of the aircraft',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 9 — Reported Speech
  // ─────────────────────────────────────────────────────────────
  static const _reportedSpeech = LessonContent(
    id: 'grammar_4',
    title: 'Dolaylı Anlatım',
    subtitle: 'Olay raporları ve ekip ifadeleri',
    categoryId: 'grammar',
    estimatedTime: '11 dk',
    emoji: '💬',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Havacılık raporlarında dolaylı anlatım',
        body:
            'Havacılık olay ve kaza raporları, mürettebat üyelerinin veya kontrolörlerin **söylediklerini** veya **düşündüklerini** sıkça aktarır. Bu ifadeleri aktarmak için kullanılan dilbilgisi yapısına **dolaylı/aktarmalı anlatım** denir.\n\nSınav soruları çoğunlukla doğrudan anlatımı dolaylıya çevirmenizi ya da dolaylı anlatım cümlesini doğru tamamlamanızı ister.',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Zaman kaymasını izle',
        animationType: GrammarAnimationType.reportedSpeech,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Zaman Kayması Kuralı',
        body:
            'Aktarım fiili **geçmiş zaman** olduğunda (said, told, reported), zamanlar geri kayar:\n\n| Doğrudan | Dolaylı Anlatım |\n|---|---|\n| is/am/are | **was/were** |\n| was/were | **had been** |\n| will | **would** |\n| can | **could** |\n| must | **had to** |\n| has/have + V3 | **had** + V3 |\n\n"The system **is** malfunctioning." →\nPilot, sistemin **was** malfunctioning olduğunu söyledi.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Havacılıkta Dolaylı Anlatım',
        examples: [
          ExampleSentence(
            sentence: 'The captain reported that the hydraulic pressure had dropped below limits.',
            highlight: 'had dropped',
            translation: 'Kaptan, hidrolik basıncın limitin altına düştüğünü bildirdi.',
          ),
          ExampleSentence(
            sentence: 'ATC informed the crew that the runway was temporarily closed.',
            highlight: 'was temporarily closed',
            translation: 'ATC ekibe pistin geçici olarak kapatıldığını bildirdi.',
          ),
          ExampleSentence(
            sentence: 'The maintenance engineer said he would complete the inspection by 0600.',
            highlight: 'would complete',
            translation: 'Bakım mühendisi incelemeyi 06:00\'ya kadar tamamlayacağını söyledi.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Temel aktarma fiilleri ve edatları:\n• said (that) — genel ifade\n• told + kişi + (that) — "ona söyledi"\n• reported (that) — resmi/yazılı rapor\n• informed + kişi + (that) — resmi bildirim\n• warned + kişi + (that/about) — tehlike uyardı\n\n"said" sonrasında edat gelmez: ✓ "said **that**" / ✗ "said **to** him that"',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -80,
            category: QuestionCategory.grammar,
            originalNumber: 180,
            questionText: 'The pilot said that the engine ………… making unusual noises during the climb.',
            options: ['is', 'was', 'will be', 'has been'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -81,
            category: QuestionCategory.grammar,
            originalNumber: 181,
            questionText: 'ATC informed the flight that the airport ………… closed due to fog.',
            options: ['will be', 'has been', 'had been', 'is'],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -82,
            category: QuestionCategory.grammar,
            originalNumber: 182,
            questionText: 'The captain ………… the cabin crew to prepare for an emergency landing.',
            options: ['said', 'told', 'spoke', 'informed to'],
            correctIndex: 1,
            difficulty: Difficulty.hard,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 10 — Emergency Sentence Completion
  // ─────────────────────────────────────────────────────────────
  static const _emergencyCompletion = LessonContent(
    id: 'completion_1',
    title: 'Acil Durum Prosedürleri',
    subtitle: 'Acil iletişim ifadelerini tamamlama',
    categoryId: 'sentence_completion',
    estimatedTime: '10 dk',
    emoji: '🚨',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Acil durum dili kesin olmalıdır',
        body:
            'Acil durum iletişimleri ICAO ifade kurallarına uyar. Cümle tamamlama sorularında, cümlenin anlamını **tam ve eksiksiz** dolduran kelime ya da ifadeyi seçmeniz gerekir.\n\nYanlış seçenekler çoğunlukla mantıklı görünür — anahtar, en **doğru** havacılık terimini seçmektir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🚨 Acil Durum Seviyeleri',
        body:
            '**MAYDAY** (×3) — Distress: immediate danger to life\n"MAYDAY MAYDAY MAYDAY — THY123 — engine fire — declaring emergency"\n\n**PAN-PAN** (×3) — Urgency: serious situation, not immediate danger\n"PAN-PAN PAN-PAN PAN-PAN — THY123 — medical emergency on board"\n\n**SQUAWK 7700** — General emergency\n**SQUAWK 7600** — Radio failure\n**SQUAWK 7500** — Unlawful interference (hijack)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📡 Acil Durum Kontrol Listesi Dili',
        body:
            'Acil durum kontrol listeleri özel cümle kalıpları kullanır:\n• "In the event of …………, the crew should…"\n• "If ………… is observed, immediately…"\n• "…………… and report to ATC"\n• "Declare …………… and request priority landing"\n\nYaygın fiiller: **declare, squawk, divert, dump, depressurize, evacuate, report**',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Acil Durum Tamamlamaları',
        examples: [
          ExampleSentence(
            sentence: 'In the event of an engine fire, the crew must __________ the affected engine.',
            highlight: 'shut down',
            translation: 'Motor yangını durumunda, ekip etkilenen motoru kapatmalıdır.',
          ),
          ExampleSentence(
            sentence: 'The pilots declared a MAYDAY and requested __________ priority landing.',
            highlight: 'immediate',
            translation: 'Pilotlar MAYDAY ilan etti ve acil öncelikli iniş talep etti.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Tamamlama Soruları için Sınav Stratejisi',
        body:
            '1. **Tümceyi baştan sona** oku — havacılık durumunu anla\n2. **Dilbilgisel boşluğu** belirle — isim mi? fiil mi? sıfat mı? edat mı?\n3. **Öbekleri** kontrol et — "declare an emergency" (acil durum ilan etmek), "announce" değil\n4. Havacılığa özgü öbekler:\n   • declare **an emergency** / mayday\n   • squawk **a code** (7700)\n   • divert **to** an alternate\n   • request **immediate** / priority assistance',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -90,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 966,
            questionText: 'The crew ………… MAYDAY three times and stated the nature of the emergency.',
            options: ['announced', 'declared', 'said', 'reported'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -91,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 967,
            questionText: 'In case of radio failure, the pilot should squawk …………',
            options: ['7500', '7600', '7700', '7000'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -92,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 968,
            questionText: 'When cabin altitude exceeds 10,000 feet, oxygen masks will ………… automatically.',
            options: ['drop down', 'fall off', 'come out', 'release'],
            correctIndex: 0,
            difficulty: Difficulty.hard,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 11 — Accident Report Analysis
  // ─────────────────────────────────────────────────────────────
  static const _accidentReport = LessonContent(
    id: 'reading_2',
    title: 'Kaza Raporu Analizi',
    subtitle: 'İleri okuma anlama',
    categoryId: 'reading',
    estimatedTime: '14 dk',
    emoji: '📑',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Kaza raporları karmaşık metinlerdir',
        body:
            'Havacılık kaza soruşturma raporları (ICAO Ek 13 standartlarına göre hazırlananlar gibi) havacılık İngilizcesi sınavlarında sınanan en karmaşık metinlerdendir.\n\nTeknik terminoloji, edilgen yapılar, dolaylı anlatım ve koşul çıkarımlarını tek bir belgede bir araya getirirler.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Rapor Yapısı',
        body:
            'Standart bir kaza raporu şunları içerir:\n1. **Özet (Synopsis)** — kazanın kısa özeti\n2. **Olgusal bilgi** — uçak, mürettebat, hava durumu, havalimanı verileri\n3. **Analiz** — ne olduğu ve neden (neden zinciri)\n4. **Bulgular** — tespit edilen olgular\n5. **Neden** — muhtemel neden(ler)\n6. **Güvenlik önerileri** — neyin değişmesi gerektiği\n\nSınav soruları genellikle **Olgusal Bilgi** ve **Analiz** bölümlerini hedefler.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔍 Kritik Okuma Becerileri',
        body:
            'Kaza raporu pasajları için:\n• **Sıralama kelimeleri**: prior to, during, following, subsequently, as a result\n• **Nedensellik dili**: due to, caused by, attributed to, led to, resulted in\n• **Bulgu ile Öneri** arasındaki fark: bulgular olgulardır; öneriler tavsiyedir\n• **Contributing factor** ≠ **Probable cause**: katkıda bulunan faktörler durumu ağırlaştırır; muhtemel neden birincil sebeptir',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Rapor Dili Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'The accident was attributed to the crew\'s failure to monitor fuel quantity during the extended hold.',
            highlight: 'attributed to',
            translation: 'Kaza, ekibin uzun süren bekleme sırasında yakıt miktarını izlememesine bağlandı.',
          ),
          ExampleSentence(
            sentence: 'A contributing factor was the inadequate crew resource management training.',
            highlight: 'contributing factor',
            translation: 'Katkıda bulunan bir faktör yetersiz ekip kaynak yönetimi eğitimiydi.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ İleri Okuma Stratejisi',
        body:
            'Üç okuma yöntemi:\n1. **Birinci okuma**: konu ve yapıyı taramak için (30 saniye)\n2. **Soruyu oku**: tam olarak neyin sorulduğunu anla\n3. **İkinci okuma**: yalnızca ilgili paragrafa odaklan\n\nBellekten yanıt verme — her zaman metinde doğrula. İleri düzey sorularda çoğunlukla pasajdaki kelimelerin yanlış bağlamda kullanıldığı **mantıklı ama yanlış** seçenekler bulunur.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        body: '"Wet motoring the engine is necessary to test the fuel system. When an engine is wet motored, the two ignition systems are turned OFF and the starter is engaged to turn the HP rotor to 15%-20% N2. At N2 = 15%, the HP fuel shutoff valve control lever is moved to ON and the engine exhaust nozzle is carefully monitored for any sign of fuel."',
        practiceQuestions: [
          QuestionModel(
            id: -100,
            category: QuestionCategory.reading,
            originalNumber: 606,
            questionText: 'What is the purpose of wet motoring the engine?',
            options: [
              'To start the engine for the first time',
              'To test the fuel system',
              'To increase engine speed',
              'To test the electrical system',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -101,
            category: QuestionCategory.reading,
            originalNumber: 607,
            questionText: 'During wet motoring, what is the position of the ignition systems?',
            options: [
              'Both are turned ON',
              'One is ON and one is OFF',
              'Both are turned OFF',
              'The position does not matter',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -102,
            category: QuestionCategory.reading,
            originalNumber: 608,
            questionText: 'What is monitored during the wet motoring test?',
            options: [
              'Engine speed only',
              'The starter motor temperature',
              'The exhaust nozzle for signs of fuel',
              'The HP rotor vibration',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON B3 — Simple & Continuous Tenses
  // ─────────────────────────────────────────────────────────────
  static const _simpleTenses = LessonContent(
    id: 'grammar_5',
    title: 'Basit & Sürekli Zamanlar',
    subtitle: 'Her zamanın havacılık bağlamında kullanımı',
    categoryId: 'grammar',
    estimatedTime: '10 dk',
    emoji: '⏰',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Zaman kipi, eylemin ne zaman gerçekleştiğini gösterir',
        body:
            'Havacılık İngilizcesinde doğru zaman kipini seçmek kritik öneme sahiptir. ATC kalıcı gerçekler için **basit geniş zaman**, anlık eylemler için **şimdiki sürekli zaman**, raporlardaki tamamlanmış olaylar için **basit geçmiş zaman** kullanır.\n\nKontrol listeleri veya raporlarda zaman kipi karıştırmak yaygın bir sınav hatasıdır.',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Zaman çizelgesinde kipler',
        animationType: GrammarAnimationType.tensesTimeline,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Basit vs. Sürekli',
        body:
            '**Present Simple** — facts, routines, permanent states\n→ "The ILS localizer **operates** on frequencies 108–111.95 MHz."\n\n**Present Continuous** — actions happening now, temporary\n→ "The aircraft **is climbing** through flight level 180."\n\n**Past Simple** — completed events (reports, logs)\n→ "The crew **performed** the before-start checklist at 0612Z."\n\n**Past Continuous** — ongoing past action interrupted\n→ "The aircraft **was taxiing** when the bird strike **occurred**."',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Bağlamda Zaman Kipi',
        examples: [
          ExampleSentence(
            sentence: 'The aircraft is currently holding at ELVIN fix due to traffic congestion.',
            highlight: 'is currently holding',
            translation: 'Uçak, trafik yoğunluğu nedeniyle şu anda ELVIN noktasında bekleme yapıyor.',
          ),
          ExampleSentence(
            sentence: 'The crew completed the after-landing checklist at 14:32 UTC.',
            highlight: 'completed',
            translation: 'Ekip iniş sonrası kontrol listesini 14:32 UTC\'de tamamladı.',
          ),
          ExampleSentence(
            sentence: 'ATIS information Bravo states that the active runway is 36L.',
            highlight: 'states',
            translation: 'ATIS bilgisi Bravo, aktif pistin 36L olduğunu belirtiyor.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Zaman belirteçleri kipe işaret eder:\n• **now / currently / at the moment** → şimdiki sürekli zaman\n• **always / usually / every flight** → basit geniş zaman\n• **at 14:32 / yesterday / last night** → basit geçmiş zaman\n• **while / when / as** → iki eş zamanlı geçmiş eylem arayın\n\nHavacılık kayıtları ve raporlar her zaman **basit geçmiş zaman** kullanır — tamamlanmış olayları kaydederler.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -120, category: QuestionCategory.grammar, originalNumber: 50, questionText: 'The aircraft ………… through FL200 when the turbulence began.', options: ['climbs', 'was climbing', 'has climbed', 'climbed'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -121, category: QuestionCategory.grammar, originalNumber: 51, questionText: 'At 0800Z, the first officer ………… the pre-departure ATIS.', options: ['receives', 'is receiving', 'received', 'has receive'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -122, category: QuestionCategory.grammar, originalNumber: 52, questionText: 'The ILS approach ………… a precision guide path to the runway threshold.', options: ['provides', 'is providing', 'provided', 'has provided'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -123, category: QuestionCategory.grammar, originalNumber: 53, questionText: 'The crew ………… the approach briefing when ATC called with a new routing.', options: ['conduct', 'were conducting', 'conducted', 'had conduct'], correctIndex: 1, difficulty: Difficulty.hard),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON B5 — Airport & Ground Operations
  // ─────────────────────────────────────────────────────────────
  static const _airportGround = LessonContent(
    id: 'vocab_3',
    title: 'Havalimanı & Yer Hizmetleri',
    subtitle: 'Ramplar, taksi yolları, kapılar ve yer operasyonları',
    categoryId: 'vocabulary',
    estimatedTime: '9 dk',
    emoji: '🏗️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Havalimanı ortamının kesin terminolojisi vardır',
        body:
            'Yer operasyonları kelime bilgisi, boşluk doldurma ve okuma anlama sorularında yoğun biçimde sınanır. **Taksi yolu (taxiway)**, **pist (runway)**, **apron** ve **ramp** arasındaki farkı bilmek hem güvenli operasyonlar hem de sınav başarısı için şarttır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛬 Havalimanı Hareket Alanları',
        body:
            '**Runway** — paved surface for takeoff and landing\n**Taxiway** — paved path connecting runways to aprons (named A, B, C…)\n**Apron (Ramp)** — area for parking, loading, servicing aircraft\n**Holding Bay** — area where aircraft wait before entering runway\n**Threshold** — beginning of the runway available for landing\n**Displaced Threshold** — landing threshold moved from physical runway end\n**Stopway** — paved area beyond runway end, usable for stopping only',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🚧 Yer Hareketi Terimleri',
        body:
            '**Pushback** — towing aircraft backward from gate using a tug\n**Tow** — moving aircraft with a ground vehicle\n**Ground power unit (GPU)** — provides external electrical power\n**Chocks** — wheel blocks preventing movement\n**Jet bridge / Jetway** — passenger boarding bridge\n**FOD** — Foreign Object Debris (anything on runway/taxiway that could damage aircraft)\n**Ground stop** — ATC directive halting departures',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Bağlamda Yer Operasyonları',
        examples: [
          ExampleSentence(
            sentence: 'Hold short of taxiway Charlie, there is an aircraft being towed across.',
            highlight: 'being towed',
            translation: 'Charlie taksi yolunun önünde bekleyin, bir uçak çekiliyor.',
          ),
          ExampleSentence(
            sentence: 'FOD inspection of the runway must be completed before the first departure.',
            highlight: 'FOD inspection',
            translation: 'İlk kalkıştan önce pistin yabancı cisim denetimi tamamlanmalıdır.',
          ),
          ExampleSentence(
            sentence: 'The aircraft requires GPU connection as the APU is unserviceable.',
            highlight: 'GPU connection',
            translation: 'APU arızalı olduğundan uçak yer güç ünitesi bağlantısı gerektiriyor.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Sık karıştırılan çiftler:\n• **Apron** = park/servis alanı | **Tarmac** = apron/taksi yolu için gayri resmi terim (resmi kullanımda kaçının)\n• **Taxiway** = hareket yolu | **Runway** = yalnızca kalkış/iniş\n• **Gate** = yolcu biniş pozisyonu | **Stand/Bay** = park pozisyonu (gate yok)\n• **Pushback** = uçak geri gider | **Tow** = araçla herhangi bir yöne çekme',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -130, category: QuestionCategory.vocabulary, originalNumber: 260, questionText: 'The area of an airport used for parking, loading, and servicing aircraft is called the:', options: ['Taxiway', 'Runway', 'Apron', 'Threshold'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -131, category: QuestionCategory.vocabulary, originalNumber: 261, questionText: 'What does "FOD" stand for in aviation ground operations?', options: ['Flight Operations Document', 'Foreign Object Debris', 'Final Obstacle Distance', 'Field Operations Division'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -132, category: QuestionCategory.vocabulary, originalNumber: 262, questionText: 'When an aircraft is pushed backward from the gate using a tug, this is called a:', options: ['Tow-out', 'Pushback', 'Ground roll', 'Reverse taxi'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -133, category: QuestionCategory.vocabulary, originalNumber: 263, questionText: 'The "displaced threshold" means:', options: ['The runway end has been extended', 'The landing threshold is moved from the physical runway beginning', 'The threshold is temporarily closed', 'An extra stopway has been added'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON B6 — Safety Equipment Vocabulary
  // ─────────────────────────────────────────────────────────────
  static const _safetyEquipment = LessonContent(
    id: 'vocab_4',
    title: 'Güvenlik Ekipmanları',
    subtitle: 'Sınav için acil ekipman terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '8 dk',
    emoji: '🦺',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Güvenlik ekipmanı adları kesin olmalıdır',
        body:
            'Güvenlik ekipmanı için yanlış isimler kullanmak tehlikeli yanlış anlaşılmalara yol açabilir. Sınav soruları ekipman adları, işlevleri ve bunlarla kullanılan fiiller hakkında kesin bilgi ölçer.\n\nBu ders, tüm havacılık rolleri için en sık sınanan güvenlik ekipmanı terimlerini kapsar.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛡️ Kabin Güvenlik Ekipmanları',
        body:
            '**Portable oxygen unit** — portable O₂ bottle for crew use\n**Drop-down oxygen mask** — passenger masks, auto-deploys above 10,000 ft cabin alt\n**Life vest / Life jacket** — under-seat flotation device\n**Emergency exit** — floor-level lighting marks the path\n**Escape slide** — inflatable slide for rapid evacuation\n**Fire extinguisher** — Halon type in cockpit, water/CO₂ in cabin\n**ELT** — Emergency Locator Transmitter (activates on impact)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔧 Teknik Güvenlik Ekipmanları',
        body:
            '**Circuit breaker (CB)** — protects electrical circuits from overload\n**Fire detector** — senses smoke/heat in engine, APU, cargo compartment\n**Fire suppression system** — discharges extinguisher agent into engine nacelle\n**Overheat detector** — warns of bleed air duct overheating\n**TCAS** — Traffic Collision Avoidance System\n**GPWS/EGPWS** — Ground Proximity Warning System',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Kullanımda Güvenlik Ekipmanları',
        examples: [
          ExampleSentence(
            sentence: 'Oxygen masks will drop down automatically if cabin altitude exceeds 10,000 feet.',
            highlight: 'drop down automatically',
            translation: 'Kabin irtifası 10.000 fiti aşarsa oksijen maskeleri otomatik olarak düşer.',
          ),
          ExampleSentence(
            sentence: 'The fire suppression system discharged successfully into the engine nacelle.',
            highlight: 'fire suppression system',
            translation: 'Yangın bastırma sistemi motor kovanına başarıyla deşarj edildi.',
          ),
          ExampleSentence(
            sentence: 'All cabin crew must demonstrate the life vest donning procedure to passengers.',
            highlight: 'donning procedure',
            translation: 'Tüm kabin ekibi yolculara can yeleği giyinme prosedürünü göstermelidir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Güvenlik ekipmanı ile kullanılan temel fiiller:\n• **don** = giymek (can yeleği, oksijen maskesi) — resmi havacılık terimi\n• **deploy** = otomatik etkinleştirmek (tahliye kayalğı, oksijen maskesi)\n• **arm** = otomatik açılım moduna ayarlamak (kapı kayalğı)\n• **discharge** = söndürücü maddeyi salmak\n• **arm/disarm** kapılar = kalkış öncesi/varış sonrası kabin ekibi eylemi\n\nResmi sınav yanıtlarında "put on" yerine her zaman **don** kullanın.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -140, category: QuestionCategory.vocabulary, originalNumber: 270, questionText: 'The correct aviation term for "putting on" a life vest or oxygen mask is:', options: ['Wearing', 'Donning', 'Fitting', 'Applying'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -141, category: QuestionCategory.vocabulary, originalNumber: 271, questionText: 'TCAS stands for:', options: ['Traffic Control and Safety System', 'Traffic Collision Avoidance System', 'Terminal Control Area Separation', 'Tactical Course Alerting System'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -142, category: QuestionCategory.vocabulary, originalNumber: 272, questionText: 'At what cabin altitude do passenger oxygen masks automatically deploy?', options: ['8,000 feet', '10,000 feet', '14,000 feet', '12,000 feet'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -143, category: QuestionCategory.vocabulary, originalNumber: 273, questionText: 'What is the purpose of the ELT?', options: ['Provide emergency lighting', 'Transmit location signal after an accident', 'Activate the fire suppression system', 'Alert crew to engine overheat'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON B8 — Pre-flight Checklist Language
  // ─────────────────────────────────────────────────────────────
  static const _preflightChecklist = LessonContent(
    id: 'fill_2',
    title: 'Uçuş Öncesi Kontrol Listesi Dili',
    subtitle: 'Kontrol listesi ifadelerini doğru tamamlama',
    categoryId: 'fill_blanks',
    estimatedTime: '9 dk',
    emoji: '📝',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Kontrol listeleri sabit dil kalıplarını takip eder',
        body:
            'Havacılık kontrol listeleri son derece standartlaştırılmış bir dil yapısı kullanır. Günlük İngilizcenin aksine, kontrol listesi dili **sıkıştırılmış ve kesin**tir — her kelime doğruluk ve kısalık için seçilmiştir.\n\nBoşluk doldurma soruları, her kontrol listesi öğesi için doğru teknik terim veya ifadeyi bilip bilmediğinizi sınar.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Kontrol Listesi Dil Kalıpları',
        body:
            'Kontrol listeleri üç ana kalıp kullanır:\n\n**Soru / Yanıt (Challenge / Response):**\n"PARKING BRAKE — **SET**"\n"SEAT BELTS — **ON**"\n"FUEL QUANTITY — **CHECKED**"\n\n**Eylem maddeleri:**\n"…………… the altimeters to QNH"\n"…………… the ILS frequency and course"\n"…………… the transponder to 2000"\n\nYaygın eylem fiilleri: **set, check, confirm, select, arm, position, verify, engage**',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Bağlamda Kontrol Listesi İfadeleri',
        examples: [
          ExampleSentence(
            sentence: 'Set the altimeter to the current QNH of 1013 hectopascals.',
            highlight: 'Set',
            translation: 'Altimetreyi mevcut QNH değeri olan 1013 hektopaskal\'a ayarlayın.',
          ),
          ExampleSentence(
            sentence: 'Arm the ground spoilers and confirm flap setting for takeoff.',
            highlight: 'Arm',
            translation: 'Yer frenlerini aktif konuma getirin ve kalkış için flap ayarını doğrulayın.',
          ),
          ExampleSentence(
            sentence: 'Verify that all doors are closed and armed before pushback.',
            highlight: 'Verify',
            translation: 'Geri itme öncesinde tüm kapıların kapalı ve kilitlendiğini doğrulayın.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Kontrol listesi fiil ayrımları:\n• **Set** = belirli bir değere ayarlamak ("set altimeter to 1013")\n• **Check** = mevcut durumu değiştirmeden doğrulamak\n• **Verify** = belirli bir koşulun sağlandığını onaylamak\n• **Confirm** = diğer mürettebat üyesinden onay almak\n• **Arm** = otomatik aktivasyon moduna almak\n• **Select** = mevcut seçeneklerden birini seçmek ("select flaps 5")',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -150, category: QuestionCategory.fillBlanks, originalNumber: 760, questionText: '………… the parking brake before starting engine start procedures.', options: ['Activate', 'Set', 'Apply', 'Lock'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -151, category: QuestionCategory.fillBlanks, originalNumber: 761, questionText: 'Doors and slides — ………… and cross-checked.', options: ['armed', 'locked', 'verified', 'activated'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -152, category: QuestionCategory.fillBlanks, originalNumber: 762, questionText: '………… the standby altimeter to the current field elevation.', options: ['Verify', 'Check', 'Set', 'Calibrate'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -153, category: QuestionCategory.fillBlanks, originalNumber: 763, questionText: 'After engine start, ………… the engine oil pressure is within normal limits.', options: ['set', 'verify', 'arm', 'select'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON E3 — Emergency Vocabulary
  // ─────────────────────────────────────────────────────────────
  static const _emergencyVocab = LessonContent(
    id: 'vocab_5',
    title: 'Acil Durum Terminolojisi',
    subtitle: 'Anormal durumlarda kullanılan kelimeler ve ifadeler',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '🚨',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Acil durum dili tam olarak öğrenilmelidir',
        body:
            'Gerçek acil durumlarda ve sınav sorularında doğru kelimeyi kullanmak kritik fark yaratabilir. ICAO standartları acil durumlar için belirli terimler tanımlar — bunlar farklı ifadeyle anlatılamaz.\n\nBu ders, acil durumla ilgili sınav sorularında en sık karşılaşılan kelime bilgisine odaklanır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🚨 Acil Durum Sınıflandırması',
        body:
            '**Distress** — state of being threatened by serious and/or imminent danger, requiring immediate assistance (MAYDAY)\n\n**Urgency** — condition concerning the safety of an aircraft or other vehicle, or of some person on board or in sight, but not requiring immediate assistance (PAN-PAN)\n\n**Emergency** — broad term covering both distress and urgency situations\n\n**Incident** — occurrence other than an accident associated with flight operation\n**Accident** — occurrence resulting in death, injury, or substantial aircraft damage',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔥 Acil Durum Eylem Kelime Bilgisi',
        body:
            '**Declare** — formally announce an emergency state\n**Divert** — change destination to an alternate airport\n**Squawk** — set transponder code\n**Dump fuel** — jettison fuel to reduce landing weight (on equipped aircraft)\n**Depressurize** — controlled or rapid loss of cabin pressure\n**Evacuate** — rapid exit of passengers and crew\n**Ditch** — emergency landing on water\n**Abort** — discontinue a takeoff roll',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Acil Durum İletişimi',
        examples: [
          ExampleSentence(
            sentence: 'The captain declared a MAYDAY due to rapid decompression at FL350.',
            highlight: 'declared a MAYDAY',
            translation: 'Kaptan, FL350\'de hızlı basınç kaybı nedeniyle MAYDAY ilan etti.',
          ),
          ExampleSentence(
            sentence: 'The crew was forced to divert to Valencia after a hydraulic failure.',
            highlight: 'divert',
            translation: 'Ekip, hidrolik arızasının ardından Valencia\'ya yön değiştirmek zorunda kaldı.',
          ),
          ExampleSentence(
            sentence: 'Following the gear malfunction, the captain decided to abort the landing.',
            highlight: 'abort',
            translation: 'İniş takımı arızasının ardından kaptan inişi iptal etmeye karar verdi.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            '"Incident" ve "Accident" arasındaki fark sık sorulan bir sınav konusudur:\n• **Incident (Olay)**: bir şey oldu ama kimse ölmedi ve büyük bir hasar oluşmadı\n• **Accident (Kaza)**: ölüm, ağır yaralanma YA DA önemli hasar meydana geldi\n\n"Distress" ve "Urgency" farkı:\n• **Distress (MAYDAY)**: HEMEN yardım gerekiyor — hayati tehlike\n• **Urgency (PAN-PAN)**: ciddi endişe, ancak ani hayati tehlike yok',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -160, category: QuestionCategory.vocabulary, originalNumber: 310, questionText: 'An occurrence involving an aircraft that results in fatal injury or substantial damage is defined as a/an:', options: ['Incident', 'Accident', 'Emergency', 'Distress'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -161, category: QuestionCategory.vocabulary, originalNumber: 311, questionText: 'Which word means "to formally announce that an emergency exists"?', options: ['Report', 'Declare', 'Signal', 'Request'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -162, category: QuestionCategory.vocabulary, originalNumber: 312, questionText: 'A PAN-PAN call indicates a condition of:', options: ['Immediate danger requiring emergency services', 'Urgency requiring priority handling', 'Minor technical issue for information only', 'Navigation uncertainty'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -163, category: QuestionCategory.vocabulary, originalNumber: 313, questionText: 'The term "ditch" in aviation means:', options: ['Land on a taxiway', 'Make an emergency water landing', 'Abandon the aircraft on ground', 'Dump excess fuel'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON E6 — Approach & Landing Phraseology
  // ─────────────────────────────────────────────────────────────
  static const _approachLanding = LessonContent(
    id: 'fill_3',
    title: 'Yaklaşma & İniş',
    subtitle: 'Kritik son faz için ifade kalıpları',
    categoryId: 'fill_blanks',
    estimatedTime: '10 dk',
    emoji: '🛬',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Yaklaşma ifade kalıpları yüksek düzeyde yapılandırılmıştır',
        body:
            'Yaklaşma ve iniş fazı, havacılıkta en çok düzenlenen ifade kalıplarını kullanır. Yaklaşma sırasındaki yanlış anlaşılmalar kazalara neden olduğundan kesin dil şarttır.\n\nBu alandaki boşluk doldurma soruları, tam ICAO ifadelerine ve doğru edatlarla anahtar kelimelerine ilişkin bilgiyi ölçer.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛬 Yaklaşma Klirans İfadeleri',
        body:
            '"Cleared **ILS approach** runway 36R"\n"Cleared **visual approach** runway 18L"\n"Cleared **RNAV(GPS) approach** runway 05"\n"**Descend** on the glide path"\n"**Established** on localizer / on the ILS"\n"**Report** outer marker / FAF / visual"\n"**Missed approach** — go around, climb to 4000 feet"\n"**Wind check**: 270/15, **cleared to land**"',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📏 Yaklaşma Mesafesi & Yüksekliği',
        body:
            '**Final approach** — last straight segment to runway\n**Short final** — within 4nm of runway threshold\n**Glide slope** — vertical guidance component of ILS\n**Localizer** — horizontal guidance component of ILS\n**Decision altitude (DA)** — height at which missed approach must be initiated if no visual contact\n**Minimum Descent Altitude (MDA)** — minimum height in non-precision approach\n**Touch-down zone** — first 3,000 feet of runway used for landing',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Yaklaşma İfadeleri',
        examples: [
          ExampleSentence(
            sentence: 'THY123, report established on the ILS runway 36R.',
            highlight: 'established',
            translation: 'THY123, pist 36R ILS\'inde kurulduğunuzda bildirin.',
          ),
          ExampleSentence(
            sentence: 'Continue approach, wind 280 degrees 12 knots, cleared to land.',
            highlight: 'cleared to land',
            translation: 'Yaklaşmaya devam edin, rüzgar 280 derece 12 knot, inişe yetkilendirildiniz.',
          ),
          ExampleSentence(
            sentence: 'Go around, I say again, go around — obstructions on runway.',
            highlight: 'Go around',
            translation: 'Tırmanış yapın, tekrar ediyorum, tırmanış yapın — piste engel.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Temel Edatlar',
        body:
            'Yaklaşma ifade kalıplarında edatlar sıkça sınanır:\n• Cleared **for** ILS approach ("to" değil)\n• Established **on** the localizer ("in" değil)\n• Descend **to** 3.000 feet ("until" değil)\n• Report **at** the outer marker ("on" değil)\n• Cleared **to land** (iki kelime, ICAO standardında "for landing" değil)\n\nEzberleme: **"Cleared for approach"** vs. **"Cleared to land"** — farklı ifadeler!',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -170, category: QuestionCategory.fillBlanks, originalNumber: 770, questionText: 'THY123, ………… ILS approach runway 36L.', options: ['cleared to', 'cleared for', 'approved for', 'authorized to'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -171, category: QuestionCategory.fillBlanks, originalNumber: 771, questionText: 'Report ………… on the localizer runway 18R.', options: ['positioned', 'established', 'confirmed', 'settled'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -172, category: QuestionCategory.fillBlanks, originalNumber: 772, questionText: 'At Decision Altitude, if no visual contact is established, the crew must execute a ………….', options: ['go-around', 'missed approach', 'holding pattern', 'Both A and B'], correctIndex: 3, difficulty: Difficulty.medium),
          QuestionModel(id: -173, category: QuestionCategory.fillBlanks, originalNumber: 773, questionText: 'The ………… is the vertical guidance beam of the ILS system.', options: ['Localizer', 'DME', 'Glide slope', 'Marker beacon'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON E7 — METAR Translation
  // ─────────────────────────────────────────────────────────────
  static const _metarTranslation = LessonContent(
    id: 'translation_2',
    title: 'METAR Çevirisi',
    subtitle: 'Hava raporlarını doğru Türkçeye çevirme',
    categoryId: 'translation',
    estimatedTime: '11 dk',
    emoji: '📊',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Her METAR unsurunun kesin bir anlamı vardır',
        body:
            'Çeviri soruları çoğunlukla METAR veya TAF kodlarını yorumlamanızı ve düz dille ifade etmenizi — ya da bir hava gözleminin doğru Türkçe çevirisini belirlemenizi ister.\n\nBir METAR\'in her unsuru sabit sırayla gelir ve kesin bir anlam taşır. Sırayı karıştırmak veya bir kısaltmayı yanlış yorumlamak puan kaybettirir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🌦️ METAR Unsur Sırası',
        body:
            '**METAR** LTBA **120850Z** **35015KT** **9999** **FEW030** **18/08** **Q1013** **NOSIG**\n\n1. Station ICAO code: LTBA (Istanbul)\n2. Date/Time: 12th at 08:50 UTC\n3. Wind: 350°/15 knots\n4. Visibility: 9999 = 10km or more\n5. Cloud: FEW at 3,000ft AGL\n6. Temp/Dewpoint: 18°C / 8°C\n7. QNH: 1013 hPa\n8. Trend: NOSIG = no significant change',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '☁️ Bulut Örtüsü Kodları',
        body:
            '**FEW** — 1–2 oktas (1/8–2/8 coverage)\n**SCT (Scattered)** — 3–4 oktas\n**BKN (Broken)** — 5–7 oktas\n**OVC (Overcast)** — 8 oktas (full coverage)\n**NSC** — No Significant Cloud\n**NCD** — No Cloud Detected (auto station)\n\nHeight is given in hundreds of feet AGL:\n"BKN015" = broken cloud at 1,500 feet AGL\n"OVC008" = overcast at 800 feet AGL',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Çeviri Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'OVC008 means overcast cloud at 800 feet above aerodrome level.',
            highlight: 'overcast',
            translation: 'OVC008, taşıt alanı seviyesinin 800 feet üzerinde tam kapalı bulut anlamına gelir.',
          ),
          ExampleSentence(
            sentence: 'TSRA in a METAR indicates thunderstorm with rain in the vicinity.',
            highlight: 'TSRA',
            translation: 'METAR\'daki TSRA, civarda şimşekli yağış olduğunu gösterir.',
          ),
          ExampleSentence(
            sentence: 'BECMG 0912 SCT020 means cloud will gradually become scattered at 2,000 feet between 09 and 12 UTC.',
            highlight: 'BECMG',
            translation: 'BECMG 0912 SCT020, bulutun 09–12 UTC arasında kademeli olarak 2000 feet\'te parçalı hale geleceği anlamına gelir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'En yaygın METAR çeviri hataları:\n• **9999** = 10 km veya daha fazla görüş (YANLIŞ: "tam 9.999 metre")\n• **FEW030** = 3.000 ft\'te bulut (METAR bulut yüksekliğinin sonuna iki sıfır ekle)\n• **18/08** = sıcaklık 18°C, çiğ noktası 8°C (YANLIŞ: "18\'den 8\'e")\n• **NOSIG** = önümüzdeki 2 saat için önemli değişiklik beklenmiyor (YANLIŞ: "sinyal yok")\n• Rüzgar "35015KT" = 350°\'DEN geliyor, hız 15 knot (yön, rüzgarın NEREDEN geldiğini gösterir)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -180, category: QuestionCategory.translation, originalNumber: 440, questionText: 'In a METAR, "BKN015" means:', options: ['Blue sky with no clouds at 1,500 feet', 'Broken cloud layer at 1,500 feet AGL', 'Blocked visibility below 1,500 feet', 'Best conditions at 1,500 feet'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -181, category: QuestionCategory.translation, originalNumber: 441, questionText: '"35015KT" in a METAR means the wind is:', options: ['From 035° at 015 knots', 'From 350° at 15 knots', 'To 350° at 15 knots', 'Variable at 35–015 knots'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -182, category: QuestionCategory.translation, originalNumber: 442, questionText: 'What does "TEMPO" mean in a TAF forecast?', options: ['Permanent change expected', 'Temporary fluctuations lasting less than 1 hour, less than half the forecast period', 'Temperature forecast', 'Terminal aerodrome meteorological observation'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -183, category: QuestionCategory.translation, originalNumber: 443, questionText: '"9999" in the visibility field of a METAR means:', options: ['Exactly 9,999 meters visibility', '10 kilometers or more visibility', 'Visibility not available', 'Visibility reduced to minimum'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON E8 — ATIS Reading Comprehension
  // ─────────────────────────────────────────────────────────────
  static const _atisReading = LessonContent(
    id: 'reading_3',
    title: 'ATIS Mesajları',
    subtitle: 'Terminal bilgilerini okuma ve anlama',
    categoryId: 'reading',
    estimatedTime: '9 dk',
    emoji: '📻',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'ATIS kritik uçuş öncesi bilgileri sunar',
        body:
            'ATIS (Otomatik Terminal Bilgi Servisi) güncel havalimanı bilgilerini kesintisiz yayınlar. Pilotlar ATC ile temasa geçmeden önce güncel ATIS bilgisini almalı ve ATIS harfiyle (Alfa, Bravo, Charlie…) aldıklarını teyit etmelidir.\n\nOkuma anlama soruları çoğunlukla ATIS tarzı metinler kullanarak belirli bilgileri çıkarmanızı ister.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📻 Standart ATIS İçeriği',
        body:
            'Bir ATIS yayını şu sırayla bilgileri içerir:\n1. Havalimanı adı ve ATIS bilgi harfi\n2. Gözlem saati\n3. Kullanılan aktif pist(ler)\n4. Kullanılan yaklaşma tipi (ILS/VOR/Visual)\n5. Rüzgar yönü ve hızı\n6. Görüş\n7. Hava olayları\n8. Bulut katmanları\n9. Sıcaklık ve çiğ noktası\n10. QNH\n11. NOTAM\'lar/özel duyurular\n12. "Advise on initial contact you have information [letter]"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnek ATIS Metni',
        examples: [
          ExampleSentence(
            sentence: 'Istanbul Atatürk information Alpha. Time 0650 UTC. Runway in use: 36L for landing, 36R for takeoff.',
            highlight: 'information Alpha',
            translation: 'İstanbul Atatürk, bilgi Alfa. Saat 0650 UTC. Kullanılan pist: iniş için 36L, kalkış için 36R.',
          ),
          ExampleSentence(
            sentence: 'ILS approach in use for runway 36L. Transition level: FL60.',
            highlight: 'Transition level',
            translation: 'Pist 36L için ILS yaklaşması kullanılmaktadır. Geçiş seviyesi: FL60.',
          ),
          ExampleSentence(
            sentence: 'Advise on initial contact you have information Alpha.',
            highlight: 'initial contact',
            translation: 'İlk temasta Alfa bilgisine sahip olduğunuzu belirtin.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Okuma Stratejisi',
        body:
            'ATIS türü okuma soruları için:\n• **ATIS harfi** her 30-60 dakikada değişir — sorular "Bravo ne anlama gelir?" diye sorabilir\n• **Kullanılan pist** varışlar ve kalkışlar için farklı olabilir\n• **Geçiş seviyesi** = geçiş irtifasının üzerindeki en düşük kullanılabilir uçuş seviyesi\n• Sondaki **özel bildirimler** çoğunlukla sınanan ayrıntıyı içerir\n• Sorular genellikle "ATIS\'e göre … için hangi pist kullanılabilir?" diye sorar',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        body: 'Read the ATIS below:\n\n"Istanbul Atatürk information Bravo. Time 0820 UTC. Runway 18R in use for arrivals and departures. ILS approach in use. Wind 190 degrees 8 knots. Visibility 6 kilometers in mist. Cloud BKN012. Temperature 14, dewpoint 13. QNH 1009. Runway 18L closed for maintenance. Advise on initial contact you have information Bravo."',
        practiceQuestions: [
          QuestionModel(id: -190, category: QuestionCategory.reading, originalNumber: 620, questionText: 'According to the ATIS, which runway is currently available for arrivals?', options: ['18L', '36R', '18R', 'Both 18L and 18R'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -191, category: QuestionCategory.reading, originalNumber: 621, questionText: 'What is the cloud condition reported in the ATIS?', options: ['Overcast at 1,200 feet', 'Broken cloud at 1,200 feet', 'Scattered cloud at 12,000 feet', 'Few clouds at 1,200 feet'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -192, category: QuestionCategory.reading, originalNumber: 622, questionText: 'Why is runway 18L unavailable?', options: ['It is reserved for military use', 'Strong crosswind', 'It is closed for maintenance', 'FOD inspection in progress'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -193, category: QuestionCategory.reading, originalNumber: 623, questionText: 'What should the pilot state when first contacting ATC after receiving this ATIS?', options: ['That they received the wind information', 'That they have information Bravo', 'Their aircraft type and destination', 'The QNH setting they have set'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON I3 — Articles in Aviation Texts
  // ─────────────────────────────────────────────────────────────
  static const _articlesAviation = LessonContent(
    id: 'grammar_6',
    title: 'Havacılıkta Artikeller',
    subtitle: 'a, an, the — ve sıfır artikel ne zaman kullanılır',
    categoryId: 'grammar',
    estimatedTime: '10 dk',
    emoji: '📖',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Artikeller belirlilik ve bağlamı gösterir',
        body:
            'Artikeller basit görünse de, teknik belgeler, kılavuzlar ve ATC iletişimleri belirli artikel kullanım kalıplarını izlediğinden havacılık İngilizcesinde en sık sınanan dilbilgisi noktalarından biridir.\n\nYanlış bir artikel anlamı değiştirir: "**a** hydraulic pump" (herhangi bir hidrolik pompa) vs. "**the** hydraulic pump" (konuştuğumuz belirli bir pompa).',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Artikel kullanım kılavuzu',
        animationType: GrammarAnimationType.articleUsage,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Artikel Kuralları',
        body:
            '**"a / an"** — indefinite: first mention, one of many, job/type\n→ "A hydraulic pump pressurizes the fluid."\n→ "He is a licensed aircraft engineer."\n\n**"the"** — definite: previously mentioned, unique, specific system\n→ "The hydraulic pump (mentioned before) failed."\n→ "The captain (there is only one) made the decision."\n\n**Zero article** — general statements, uncountable nouns, proper names\n→ "Aviation safety depends on training." (general)\n→ "ILS runway 36L is available." (proper name)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Teknik Metinlerde Artikeller',
        examples: [
          ExampleSentence(
            sentence: 'The aircraft is equipped with a hydraulic system that powers the flight controls.',
            highlight: 'a hydraulic system',
            translation: 'Uçak, uçuş kontrollerini güçlendiren bir hidrolik sistemle donatılmıştır.',
          ),
          ExampleSentence(
            sentence: 'An ELT must be installed on all aircraft operating under IFR.',
            highlight: 'An ELT',
            translation: 'IFR altında uçuş yapan tüm uçaklarda bir ELT bulunmalıdır.',
          ),
          ExampleSentence(
            sentence: 'Aviation fuel must be free of contaminants before being loaded.',
            highlight: 'Aviation fuel',
            translation: 'Havacılık yakıtı yüklenmeden önce kirleticilerden arındırılmış olmalıdır.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Ünlü **seslerden** önce "a" değil "an" kullanın — yalnızca ünlü harflerden değil:\n• **an** ILS approach (I = ünlü ses)\n• **an** RNAV procedure (R = ünsüz harf, ama "RNAV" "ar" ünlü sesiyle başlar)\n• **a** NOTAM (N = ünsüz ses)\n• **a** VOR (V = ünsüz ses)\n\nGenel bağlamda havacılık sistemleriyle sıfır artikel:\n✓ "Hydraulic systems are used in..." ("The hydraulic systems" değil)\n✓ "ILS provides guidance" ("The ILS provides" değil)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -200, category: QuestionCategory.grammar, originalNumber: 220, questionText: 'The aircraft is fitted with ………… auxiliary power unit.', options: ['a', 'an', 'the', '—'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -201, category: QuestionCategory.grammar, originalNumber: 221, questionText: '………… captain must complete a pre-flight inspection before every departure.', options: ['A', 'An', 'The', '—'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -202, category: QuestionCategory.grammar, originalNumber: 222, questionText: '………… aviation safety is a global priority.', options: ['A', 'An', 'The', '—'], correctIndex: 3, difficulty: Difficulty.medium),
          QuestionModel(id: -203, category: QuestionCategory.grammar, originalNumber: 223, questionText: 'We need to replace ………… hydraulic pump that failed during yesterday\'s flight.', options: ['a', 'an', 'the', '—'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON I4 — Instrument & Navigasyon Sistemleri
  // ─────────────────────────────────────────────────────────────
  static const _instrumentSystems = LessonContent(
    id: 'vocab_6',
    title: 'Enstrüman Sistemleri',
    subtitle: 'Aviyonik ve navigasyon enstrümanı kelime bilgisi',
    categoryId: 'vocabulary',
    estimatedTime: '11 dk',
    emoji: '🎛️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Modern uçaklar karmaşık enstrüman sistemlerine dayanır',
        body:
            'Aviyonik kelime bilgisi okuma anlama, kelime doldurma ve cümle tamamlama sorularında karşınıza çıkar. Her enstrümanın ne yaptığını ve kılavuzlarda nasıl tanımlandığını anlamak orta ve ileri düzey için şarttır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '✈️ Temel Uçuş Enstrümanları',
        body:
            '**ADI (Attitude Director Indicator)** — shows pitch and bank\n**HSI (Horizontal Situation Indicator)** — combined heading + navigation\n**VSI (Vertical Speed Indicator)** — rate of climb/descent in feet per minute\n**ASI (Airspeed Indicator)** — shows IAS in knots\n**Altimeter** — shows altitude using static pressure\n**Turn & Slip Indicator** — shows rate of turn and coordination',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛰️ Navigasyon Sistemleri',
        body:
            '**FMS (Flight Management System)** — computerized navigation, flight planning, and performance\n**GPS (Global Positioning System)** — satellite-based positioning\n**IRS/INS (Inertial Reference System)** — self-contained navigation using accelerometers\n**DME (Distance Measuring Equipment)** — ground-based range measurement\n**ADF (Automatic Direction Finder)** — homes to NDB stations\n**TCAS II** — provides Resolution Advisories (RA) to avoid traffic',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Bağlamda Navigasyon Sistemleri',
        examples: [
          ExampleSentence(
            sentence: 'The FMS automatically calculates the most fuel-efficient cruise altitude.',
            highlight: 'FMS',
            translation: 'FMS, en yakıt verimli seyir irtifasını otomatik olarak hesaplar.',
          ),
          ExampleSentence(
            sentence: 'A TCAS Resolution Advisory directed the crew to climb immediately.',
            highlight: 'Resolution Advisory',
            translation: 'Bir TCAS Çözüm Tavsiyesi, ekibi hemen tırmanmaya yöneltti.',
          ),
          ExampleSentence(
            sentence: 'The IRS requires an alignment period of approximately 10 minutes before departure.',
            highlight: 'alignment period',
            translation: 'IRS, kalkıştan önce yaklaşık 10 dakikalık bir hizalama süresi gerektirir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Sınavda sık karıştırılan çiftler:\n• **IAS** (Gösterge Hava Hızı) vs. **TAS** (Gerçek Hava Hızı) — TAS irtifayla artar\n• **FMS** tüm rotayı yönetir | **otopilot** uçağı kontrol eder\n• **TCAS RA** = zorunlu kaçınma manevrası | **TCAS TA** = Trafik Tavsiyesi (yalnızca farkındalık)\n• **DME** **eğim mesafesini** ölçer (yer mesafesi değil)\n• **IRS** bağımsızdır (dış sinyal gerekmez) | **GPS** uyduları gerektirir',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -210, category: QuestionCategory.vocabulary, originalNumber: 320, questionText: 'What does VSI measure?', options: ['Vertical separation from terrain', 'Rate of climb or descent in feet per minute', 'Vertical speed of ground traffic', 'Variance in static pressure'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -211, category: QuestionCategory.vocabulary, originalNumber: 321, questionText: 'A TCAS Resolution Advisory (RA) requires the crew to:', options: ['Monitor the traffic only', 'Take immediate evasive action as directed', 'Contact ATC for guidance', 'Reduce speed only'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -212, category: QuestionCategory.vocabulary, originalNumber: 322, questionText: 'Which system uses accelerometers and gyroscopes for self-contained navigation?', options: ['GPS', 'DME', 'IRS/INS', 'VOR'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -213, category: QuestionCategory.vocabulary, originalNumber: 323, questionText: 'DME measures:', options: ['Direction to a station', 'Slant range distance to a ground station', 'Horizontal distance only', 'Time since last waypoint'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON I5 — Flight Plan Documents
  // ─────────────────────────────────────────────────────────────
  static const _flightPlanReading = LessonContent(
    id: 'reading_4',
    title: 'Uçuş Planı Belgeleri',
    subtitle: 'ICAO uçuş planı formlarını ve OFP\'leri okuma',
    categoryId: 'reading',
    estimatedTime: '12 dk',
    emoji: '📋',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Uçuş planları kritik operasyonel veri içerir',
        body:
            'ICAO uçuş planı formları (ICAO Doc 4444, Ek 2) ve Operasyonel Uçuş Planları (OFP\'ler) yoğun kodlanmış bilgi içerir. Bu düzeydeki okuma anlama soruları, bu belgelerden belirli verileri çıkarmanızı ve yapılarını anlamanızı gerektirir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 ICAO Uçuş Planı Alanları',
        body:
            '**Field 7** — Aircraft ID (call sign): "THY123"\n**Field 8** — Flight rules (I=IFR, V=VFR) and type (S=scheduled): "IS"\n**Field 9** — Number and type of aircraft / wake turbulence: "B738/M"\n**Field 10** — Equipment: "SDFGRY/S" (comms/nav/approach/SSR)\n**Field 15** — Route: SID + airways + waypoints + STAR\n**Field 16** — Destination + EET + alternates\n**Field 18** — Other information (PBN, DAT, SUR, etc.)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚠️ İz Türbülanssı Kategorileri',
        body:
            '**J — Super** (A380, AN-124): wingspan >80m\n**H — Heavy** (B747, B777, A330): MTOW >136,000kg\n**M — Medium** (B737, A320): MTOW 7,000–136,000kg\n**L — Light** (Cessna, DA-42): MTOW <7,000kg\n\nSeparation minima increase behind heavier aircraft:\n• H behind J: 6nm\n• M behind H: 5nm\n• L behind H: 6nm\n\nWake turbulence is most severe at **low speed, high angle of attack** (on approach)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Uçuş Planı Verisi',
        examples: [
          ExampleSentence(
            sentence: 'B738/M in the flight plan means Boeing 737-800 with Medium wake turbulence category.',
            highlight: '/M',
            translation: 'Uçuş planındaki B738/M, Boeing 737-800 ve Orta ağırlık kategorisi anlamına gelir.',
          ),
          ExampleSentence(
            sentence: 'EET/LTAA0123 means the estimated elapsed time to the LTAA FIR boundary is 1 hour 23 minutes.',
            highlight: 'EET',
            translation: 'EET/LTAA0123, LTAA FIR sınırına tahmini geçiş süresinin 1 saat 23 dakika olduğu anlamına gelir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Uçuş planı soruları genellikle şunlara odaklanır:\n• **Uçak tipi / iz türbülanssı kategorisi** — ICAO uçak tanımlayıcılarını bilin\n• **EET** (Tahmini Geçen Süre) vs. **ETA** (Tahmini Varış Saati)\n• **Yedek havalimanı** gereksinimleri — ne zaman gerekli?\n• Alan 18\'deki **PBN** (Performansa Dayalı Seyrsüsefer) kodları\n\nYaygın tuzak: "EOBT" = Tahmini Blok Ayrılış Saati (geri itme başladığında), KALKIŞ saati değil.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -220, category: QuestionCategory.reading, originalNumber: 630, questionText: 'In an ICAO flight plan, "H" in the wake turbulence field means:', options: ['High altitude aircraft', 'Heavy aircraft (MTOW > 136,000 kg)', 'Helicopter', 'High-speed aircraft'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -221, category: QuestionCategory.reading, originalNumber: 631, questionText: 'Field 15 of an ICAO flight plan contains:', options: ['Aircraft identification', 'The planned route', 'Equipment capabilities', 'Emergency information'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -222, category: QuestionCategory.reading, originalNumber: 632, questionText: 'Wake turbulence is most hazardous when the generating aircraft is:', options: ['At high speed and low angle of attack', 'At low speed and high angle of attack', 'In cruise at high altitude', 'During takeoff roll'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -223, category: QuestionCategory.reading, originalNumber: 633, questionText: 'EOBT in a flight plan stands for:', options: ['Estimated On-Block Time', 'Estimated Off-Block Time', 'Engine Operating Base Time', 'Expected Outbound Tracking'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON I6 — Engine Failure Procedure Language
  // ─────────────────────────────────────────────────────────────
  static const _engineFailureLanguage = LessonContent(
    id: 'fill_4',
    title: 'Motor Arızası Prosedürleri',
    subtitle: 'Anormal ve acil kontrol listelerindeki dil kalıpları',
    categoryId: 'fill_blanks',
    estimatedTime: '10 dk',
    emoji: '🔥',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Anormal kontrol listelerinin sabit dil kalıpları vardır',
        body:
            'Motor arızası ve diğer anormal/acil durum kontrol listeleri havacılıktaki en kesin dili kullanır. Bu alandan gelen boşluk doldurma soruları hem teknik bilgiyi hem de kelime doğruluğunu sınar.\n\nDoğru prosedür fiili kritik öneme sahiptir — yanlış eylem kelimesi kullanmak havacılıkta asla kabul edilemez.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔥 Motor Arızası Kelime Bilgisi',
        body:
            '**Thrust lever** — controls engine power (throttle)\n**Fuel control lever** — starts/stops fuel to engine\n**Engine fire handle** — emergency shut-off and fire suppression control\n**HP fuel cock / Shutoff valve** — high-pressure fuel control\n**N1 / N2** — fan speed (%) / core speed (%)\n**EGT** — Exhaust Gas Temperature\n**ITT** — Interstage Turbine Temperature\n**Surge** — compressor stall; loud bang, rpm fluctuation',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Kontrol Listesi Eylem Kalıpları',
        body:
            'Motor arızası kontrol listesi sırası şu kesin ifadeleri kullanır:\n\n"Engine fire, failure or severe damage — **ECAM ACTIONS**… **PERFORM**"\n"Thrust lever — **IDLE**"\n"Motor iyileşmiyorsa — engine **MASTER switch** — **OFF**"\n"Engine fire pushbutton — **PUSH**"\n"Yangın sönmezse — ikinci ajanı **DISCHARGE** et"\n"En yakın uygun havalimanına in — **CONSIDER**"\n\nAnahtar kalıp fiilleri: **idle, push, pull, discharge, confirm, verify, cross-check**',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Anormal Kontrol Listesi Dili',
        examples: [
          ExampleSentence(
            sentence: 'In the event of an engine fire, the crew must pull the engine fire handle.',
            highlight: 'pull the engine fire handle',
            translation: 'Motor yangını durumunda ekip, motor yangın kolunu çekmelidir.',
          ),
          ExampleSentence(
            sentence: 'If the fire is not extinguished, discharge the second fire extinguisher agent.',
            highlight: 'discharge',
            translation: 'Yangın söndürülemezse ikinci söndürücü maddesini deşarj edin.',
          ),
          ExampleSentence(
            sentence: 'Cross-check the affected engine number before taking any action.',
            highlight: 'Cross-check',
            translation: 'Herhangi bir işlem yapmadan önce etkilenen motor numarasını çapraz kontrol edin.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Sınanan kontrol listesi eylem fiilleri:\n• **Pull** fire handle ("activate" veya "turn" değil — yangın kolunu **çek**)\n• **Discharge** extinguisher ("release" veya "fire" değil — söndürücüyü **deşarj et**)\n• **Cross-check** — sınavda bu adımı asla atlama\n• **Monitor** vs. **Check**: izleme süreklidir; kontrol tek bir eylemdir\n• "Land at nearest suitable" ≠ "hemen saptır" — ekip "uygunluğu" değerlendirmelidir',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -230, category: QuestionCategory.fillBlanks, originalNumber: 780, questionText: 'In the event of an engine fire, the fire handle should be ………… after engine shutdown.', options: ['pushed', 'pulled', 'turned', 'activated'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -231, category: QuestionCategory.fillBlanks, originalNumber: 781, questionText: 'Before performing any engine shutdown action, the crew should ………… the affected engine.', options: ['turn off', 'confirm', 'cross-check', 'identify'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -232, category: QuestionCategory.fillBlanks, originalNumber: 782, questionText: 'If the first fire extinguisher agent does not extinguish the fire, the crew should ………… the second bottle.', options: ['activate', 'fire', 'discharge', 'release'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -233, category: QuestionCategory.fillBlanks, originalNumber: 783, questionText: 'A compressor stall in a jet engine is also known as a compressor ………….', options: ['stall', 'surge', 'failure', 'seizure'], correctIndex: 1, difficulty: Difficulty.hard),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON I7 — Operations Manual Translation
  // ─────────────────────────────────────────────────────────────
  static const _opsManualTranslation = LessonContent(
    id: 'translation_3',
    title: 'Operasyon Kılavuzu Dili',
    subtitle: 'Resmi operasyon ve bakım metinlerini çevirme',
    categoryId: 'translation',
    estimatedTime: '11 dk',
    emoji: '📕',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Resmi havacılık belgelerinin özel dil kalıpları vardır',
        body:
            'Operasyon kılavuzları, bakım kılavuzları (AMM) ve uçuşa elverişlilik direktifleri, kesin hukuki ve teknik çıkarımlar içeren resmi İngilizce kullanır. Bu düzeydeki çeviri soruları, yalnızca kelimeleri değil, arkarındaki **düzenleyici amacı** da anlamayı gerektirir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📕 Düzenleyici Dil',
        body:
            '**Shall** — mandatory requirement (legal obligation in ICAO documents)\n**Should** — recommended practice (not legally binding, but expected)\n**May** — permitted (optional)\n**Must** — mandatory (operational context, not formal ICAO legal text)\n\n**Compliance** — acting in accordance with a regulation\n**In accordance with (IAW)** — following specified requirements\n**Subject to** — conditional upon something\n**Notwithstanding** — despite; even though\n**Hereinafter** — from this point forward in the document',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Kılavuz Dili Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'All maintenance shall be carried out by qualified personnel in accordance with the approved data.',
            highlight: 'shall be carried out',
            translation: 'Tüm bakım işlemleri, onaylı veriye uygun olarak nitelikli personel tarafından yapılmalıdır.',
          ),
          ExampleSentence(
            sentence: 'Subject to operational requirements, the interval may be extended by not more than 10 flight hours.',
            highlight: 'Subject to',
            translation: 'Operasyonel gerekliliklere bağlı olarak, interval en fazla 10 uçuş saati uzatılabilir.',
          ),
          ExampleSentence(
            sentence: 'Notwithstanding the above, the captain retains full authority over the safe conduct of the flight.',
            highlight: 'Notwithstanding',
            translation: 'Yukarıdakilerle birlikte, kaptan uçuşun güvenli yürütülmesi konusunda tam yetkisini korur.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Çeviri İpuçları',
        body:
            'Önemli çeviri ayrımları:\n• ICAO belgelerinde "**shall**" ≠ "will" (gelecek) — **zorunlu** anlamına gelir\n• "**notwithstanding**" ≠ "noting" — **rağmen** veya **ne olursa olsun** anlamına gelir\n• "**in the event of**" = "eğer … olursa/durumunda" (şartlı)\n• "**prior to**" = "…dan önce" (before ifadesinin resmi hali)\n• "**subsequent to**" = "…dan sonra" (after ifadesinin resmi hali)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -240, category: QuestionCategory.translation, originalNumber: 450, questionText: '"All crew members shall complete the emergency training" — "shall" in this context means:', options: ['Will possibly complete', 'Are encouraged to complete', 'Must complete (mandatory)', 'Should ideally complete'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -241, category: QuestionCategory.translation, originalNumber: 451, questionText: '"Notwithstanding the MEL entry, the captain must assess airworthiness" correctly translates as:', options: ['Because of the MEL entry, the captain must assess', 'Despite the MEL entry, the captain must still assess', 'The MEL entry prevents the captain from assessing', 'After the MEL entry, the captain will assess'], correctIndex: 1, difficulty: Difficulty.hard),
          QuestionModel(id: -242, category: QuestionCategory.translation, originalNumber: 452, questionText: '"Prior to engine start, all doors must be closed and armed." The phrase "prior to" means:', options: ['Immediately after', 'At the same time as', 'Before', 'In preparation for'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -243, category: QuestionCategory.translation, originalNumber: 453, questionText: '"In accordance with" in an operations manual means:', options: ['Similar to', 'According to and following', 'Despite', 'Approximately matching'], correctIndex: 1, difficulty: Difficulty.easy),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON A1 — Complex Sentence Structures
  // ─────────────────────────────────────────────────────────────
  static const _complexStructures = LessonContent(
    id: 'grammar_7',
    title: 'Karmaşık Cümle Yapıları',
    subtitle: 'Sıfat cümleleri, ortaçlar ve devrik yapılar',
    categoryId: 'grammar',
    estimatedTime: '13 dk',
    emoji: '🧩',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'İleri metinler karmaşık dilbilgisi yapıları kullanır',
        body:
            'Havacılık belgeleri, kaza raporları ve ICAO yayınları, birden fazla yan cümleyi bir araya getiren karmaşık cümle yapıları kullanır. İleri düzeyde, hem anlama hem de üretim sorularında bunları doğru bir şekilde ele almalısınız.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Sıfat Cümleleri',
        body:
            '**Defining** (no commas): identifies which one\n→ "The component **that failed** was the hydraulic pump."\n\n**Non-defining** (with commas): adds extra information\n→ "The hydraulic pump, **which had just been serviced**, failed."\n\n**Reduced relative clause** (participle phrase):\n→ "The pilot **flying the aircraft** reported vibration." (= who was flying)\n→ "The component **installed last week** is defective." (= that was installed)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Ortaç İfadeleri & Devrik Yapı',
        body:
            '**Present participle** (active, simultaneous):\n→ "**Having received** the clearance, the crew began the takeoff roll."\n\n**Past participle** (passive, completed first):\n→ "**Notified by ATC**, the pilot diverted to the alternate."\n\n**Negative inversion** (formal/reports):\n→ "**Under no circumstances should** the aircraft depart without a clearance."\n→ "**Not until the checks were completed** did the captain approve departure."',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Karmaşık Yapı Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'The maintenance technician, having completed all required inspections, signed the aircraft log.',
            highlight: 'having completed',
            translation: 'Bakım teknisyeni, gerekli tüm denetimleri tamamladıktan sonra uçak kütüğünü imzaladı.',
          ),
          ExampleSentence(
            sentence: 'Under no circumstances should flight crew members operate the aircraft beyond approved limits.',
            highlight: 'Under no circumstances should',
            translation: 'Uçuş ekibi üyeleri hiçbir koşulda uçağı onaylanan limitler dışında kullanmamalıdır.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Sınav sorularında devrik yapı işaretleri:\n• "Under no circumstances…" → yardımcı fiil özneden önce gelmelidir\n• "Not until…" → ana cümlede did/could özneden önce gelir\n• "Only after…" → ana cümlede devrik yapı\n\nOrtaç ifadeler — özneyi kontrol edin:\n• "**Having landed**, the aircraft was directed to the gate." ✓ (aircraft indi)\n• "**Having landed**, the gate was assigned." ✗ (gate inmedi — sarkan ortaç)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -250, category: QuestionCategory.grammar, originalNumber: 230, questionText: 'The hydraulic pump ………… last week has already failed.', options: ['that installed', 'installed', 'which installed', 'installing'], correctIndex: 1, difficulty: Difficulty.hard),
          QuestionModel(id: -251, category: QuestionCategory.grammar, originalNumber: 231, questionText: 'Under no circumstances ………… crew members disable the fire detection system.', options: ['crew members should', 'should crew members', 'do crew members', 'crew members must'], correctIndex: 1, difficulty: Difficulty.hard),
          QuestionModel(id: -252, category: QuestionCategory.grammar, originalNumber: 232, questionText: '………… the pre-departure checks, the captain authorised the pushback.', options: ['Having completed', 'Completed', 'After completing to', 'Being completed'], correctIndex: 0, difficulty: Difficulty.hard),
          QuestionModel(id: -253, category: QuestionCategory.grammar, originalNumber: 233, questionText: 'The system which ………… most frequently in this aircraft type is the hydraulic actuator.', options: ['fails', 'is failed', 'failing', 'has fail'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON A2 — Expert ICAO Vocabulary
  // ─────────────────────────────────────────────────────────────
  static const _expertVocab = LessonContent(
    id: 'vocab_7',
    title: 'İleri ICAO Kelime Bilgisi',
    subtitle: 'Yüksek frekanslı ileri havacılık terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '12 dk',
    emoji: '🏆',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'İleri kelime bilgisi iyiyi mükemmelden ayırır',
        body:
            'ICAO Seviye 5 ve 6 yeterliği, az kullanılan ancak yüksek öneme sahip teknik sözcüklere hakim olmayı gerektirir. Bu ders, ileri düzey adayları ayırt eden ve en zor sınav sorularında sıkça karşılaşılan terimleri kapsar.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🏆 İleri Operasyonel Terimler',
        body:
            '**EDTO/ETOPS** — Extended Diversion Time Operations (flying far from alternate airports)\n**RVSM** — Reduced Vertical Separation Minima (300m / 1,000ft between FL290–FL410)\n**PBN** — Performance-Based Navigation (RNP, RNAV specs)\n**MNPS** — Minimum Navigation Performance Specification (oceanic)\n**MEL** — Minimum Equipment List (approved deferred defects)\n**CDL** — Configuration Deviation List (approved structural deviations)\n**AOG** — Aircraft on Ground (urgent unserviceable aircraft)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚠️ Güvenlik Kritik Kelime Bilgisi',
        body:
            '**Controlled flight into terrain (CFIT)** — aircraft in controlled flight strikes terrain\n**Loss of control in-flight (LOC-I)** — most fatal accident category\n**Runway incursion** — unauthorized presence on runway\n**Airspace infringement** — entering controlled airspace without clearance\n**Human factors** — study of human performance in aviation systems\n**Crew Resource Management (CRM)** — effective use of all resources\n**Threat and Error Management (TEM)** — proactive safety model',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Bağlamda Uzman Kelime Bilgisi',
        examples: [
          ExampleSentence(
            sentence: 'The accident was classified as CFIT — the crew was unaware of the proximity to terrain.',
            highlight: 'CFIT',
            translation: 'Kaza, CFIT olarak sınıflandırıldı — ekip, araziye olan yakınlığından habersizdi.',
          ),
          ExampleSentence(
            sentence: 'Under RVSM, vertical separation between FL290 and FL410 is reduced to 1,000 feet.',
            highlight: 'RVSM',
            translation: 'RVSM kapsamında, FL290 ile FL410 arasındaki dikey ayırma 1.000 fite indirilmiştir.',
          ),
          ExampleSentence(
            sentence: 'The aircraft was dispatched on the MEL, with one hydraulic pump deferred.',
            highlight: 'MEL',
            translation: 'Uçak, bir hidrolik pompa ertelenmiş olarak MEL\'e göre hava aracı olarak gönderildi.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav Stratejisi',
        body:
            'İleri düzey sözcük soruları için:\n• **EDTO/ETOPS** = yedek havalimanlarına ne kadar uzak uçabileceğiniz (okyanus/uzak operasyonlar)\n• **MEL** = bozukken uçabilecekleriniz; **CDL** = onaylanmış eksik yapısal parçalar\n• **PBN** hem **RNAV** hem **RNP** kapsamındadır (RNP bordo izleme + uyarı sistemi gerektirir)\n• **Runway incursion** ile **airspace infringement** — her ikisi ciddi güvenlik olayları; farklı alanları ilgilendirir\n• **CRM** **mevcut kaynakları kullanmakla** ilgilidir — yalnızca iletişim değil',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -260, category: QuestionCategory.vocabulary, originalNumber: 330, questionText: 'CFIT stands for:', options: ['Crew Fatigue Incident Tracking', 'Controlled Flight Into Terrain', 'Cockpit Flight Information Terminal', 'Critical Flight Instrument Test'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -261, category: QuestionCategory.vocabulary, originalNumber: 331, questionText: 'Under RVSM, what is the minimum vertical separation between FL290 and FL410?', options: ['2,000 feet', '500 meters', '1,000 feet', '600 meters'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -262, category: QuestionCategory.vocabulary, originalNumber: 332, questionText: 'An "AOG" status means:', options: ['Aircraft is on its way to the gate', 'Aircraft is grounded due to an unserviceable condition', 'Aircraft is authorized to operate with deferred defects', 'Aircraft has been overhauled'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -263, category: QuestionCategory.vocabulary, originalNumber: 333, questionText: 'Runway incursion is defined as:', options: ['Aircraft landing on wrong runway', 'Any unauthorized presence on the runway', 'Runway excursion due to brake failure', 'ATC error causing runway conflict'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON A3 — SID/STAR Procedure Reading
  // ─────────────────────────────────────────────────────────────
  static const _sidStarReading = LessonContent(
    id: 'reading_5',
    title: 'SID/STAR Prosedürleri',
    subtitle: 'Kalkış ve varış prosedür belgelerini okuma',
    categoryId: 'reading',
    estimatedTime: '13 dk',
    emoji: '🗺️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Prosedür belgeleri teknik bilgi ile doludur',
        body:
            'Standart Enstrüman Kalkışları (SID) ve Standart Terminal Variş Rotaları (STAR), irtifalar, hızlar, ara noktalar ve kısıtlamalar içeren belgelenmiş prosedürlerdir. İleri düzey okuma anlama soruları bu belgelerden alıntı kullanır ve kesin yorumlama gerektirir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛫 SID — Kalkış Prosedürü',
        body:
            'A SID (Standart Enstrüman Kalkış Prosedürü) şunları sağlar:\n• Pistden en-route yapısına rotalama\n• İrtifa kısıtlamaları ("at or above 3,000 ft at waypoint TURPO")\n• Hız kısıtlamaları ("250 KIAS below 10,000 ft")\n• Geçiş kodları (RNAV, geleneksel)\n\n**İrtifa kodlaması:**\n• **"A030+"** = 3.000 ft veya üzeri\n• **"A050-"** = 5.000 ft veya altı\n• **"A060B080"** = 6.000 ile 8.000 ft arası\n• **"S220"** = 220 KIAS veya altında hız koru',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛬 STAR — Varış Prosedürü',
        body:
            'Bir STAR (Standart Terminal Variş Rotası) şunları sağlar:\n• en-route yapısından terminal alanına/yaklaşmaya rotalama\n• Hız azaltma profili\n• IAF noktasına (Başlangıç Yaklaşma Noktası) geçiş\n\n**Yaygın STAR terminolojisi:**\n• **IAF** — Başlangıç Yaklaşma Noktası\n• **IF** — Orta Nokta\n• **FAF** — Son Yaklaşma Noktası\n• **MAP** — Yanlış Yaklaşma Karar Noktası\n• **Published hold** — prosedürdeki bekleme döngüsü\n• **"Expect vectors"** — ATC radar yönlendirmesi verecek',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Prosedür Dili',
        examples: [
          ExampleSentence(
            sentence: 'At or above 6,000 feet at TURPO waypoint before turning left to intercept the final approach course.',
            highlight: 'At or above',
            translation: 'Final yaklaşma pistine girilmeden önce TURPO noktasında 6.000 ft veya üzerinde olmak zorunludur.',
          ),
          ExampleSentence(
            sentence: 'Maintain 250 knots or less until 10 DME from the airport.',
            highlight: 'Maintain 250 knots or less',
            translation: 'Havalimanından 10 DME mesafeye kadar 250 knot veya daha düşük hız koruyun.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Prosedür belgelerinde "At or above" / "at or below":\n• "A030+" = 3.000 ft veya **üzeri** (artı işareti = daha yüksek)\n• "A050-" = 5.000 ft veya **altı** (eksi işareti = daha alçak)\n\nBir ara noktada hem hız hem irtifa kısıtlaması varsa, **her ikisine** eş zamanlı uyulmalıdır.\n\nBir STAR\'daki "Expect vectors", ATC\'nin her zaman vektör vereceği anlamına gelmez — pilot beklemelidir (vektör verilmezse yayımlanmış prosedürü uygulayın).',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -270, category: QuestionCategory.reading, originalNumber: 640, questionText: 'In a SID procedure document, "A040+" means the aircraft must be:', options: ['At 4,000 ft exactly', 'At or above 4,000 ft', 'At or below 4,000 ft', 'Between 4,000 and 4,500 ft'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -271, category: QuestionCategory.reading, originalNumber: 641, questionText: 'The FAF (Final Approach Fix) marks:', options: ['The beginning of the missed approach', 'The start of the final approach segment', 'The runway threshold', 'The IAF position'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -272, category: QuestionCategory.reading, originalNumber: 642, questionText: '"Expect vectors" on a STAR means:', options: ['Vectors will definitely be given by ATC', 'The pilot should anticipate radar vectors but fly published procedure if not given', 'Vectors are not available on this route', 'The pilot may request vectors'], correctIndex: 1, difficulty: Difficulty.hard),
          QuestionModel(id: -273, category: QuestionCategory.reading, originalNumber: 643, questionText: 'If a SID shows "S220" at a waypoint, the crew must:', options: ['Climb to speed 220 knots', 'Maintain 220 KIAS or less', 'Set Mach 0.220', 'Not exceed 220 feet per minute climb'], correctIndex: 1, difficulty: Difficulty.hard),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON A5 — CAT III Approach Phraseology Completion
  // ─────────────────────────────────────────────────────────────
  static const _cat3Completion = LessonContent(
    id: 'completion_3',
    title: 'CAT III Yaklaşma Prosedürleri',
    subtitle: 'Düşük görüş operasyonları ve tamamlama ifadeleri',
    categoryId: 'sentence_completion',
    estimatedTime: '12 dk',
    emoji: '🌫️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Düşük görüş operasyonları kesin dil gerektirir',
        body:
            'CAT II ve CAT III yaklaşmaları otomatik indiş sistemleri kullanılarak çok düşük görüş koşullarında gerçekleştirilir. Bu prosedürlerdeki ifadeler, uyarılar ve sözlü bildirimler havacılık İngilizcesinin en kesin tanımlı ifadeleri arasındadır.\n\nBu alandaki cümle tamamlama soruları, prosedür terminolojisinin tam bilgisini gerektirir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🌫️ ILS Kategorileri',
        body:
            '**CAT I** — DH ≥200ft, RVR ≥550m (standard ILS)\n**CAT II** — DH 100–200ft, RVR ≥300m (needs specific aircraft/crew cert)\n**CAT IIIA** — DH <100ft OR no DH, RVR ≥200m\n**CAT IIIB** — DH <50ft OR no DH, RVR 50–200m\n**CAT IIIC** — No DH, No RVR limit (still not in service)\n\n**LVP** — Low Visibility Procedures (activated by airport when RVR <600m)\n**LVT** — Low Visibility Takeoff',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📢 CAT III Sözlü Bildirimleri',
        body:
            'Standart CAT III yaklaşma sözlü bildirimleri (sırayla):\n1. "**Localizer alive**" — ILS localizer yakalandı\n2. "**Glide slope alive**" — dikey rehberlik yakalandı\n3. "**Land 3**" — otomatik indiş modu onaylandı (A320 ailesi)\n4. "**1,000 feet**" — standart kontrol irtifası\n5. "**500 feet**" — istikrar kontrolü\n6. "**100 feet**" — görsel veya etrafta dönüş kararı\n7. "**50, 40, 30, 20, 10**" — radyo altimetre çağrıları\n8. "**Touchdown**" → "**Decelerate**" → "**Vacate**"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'CAT III Tamamlama Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'During LVP, ground movement must be strictly controlled to prevent runway incursion.',
            highlight: 'LVP',
            translation: 'LVP sırasında pist ihlalini önlemek için yer hareketi kesinlikle kontrol edilmelidir.',
          ),
          ExampleSentence(
            sentence: 'At Decision Height, if the required visual reference is not established, a go-around must be executed.',
            highlight: 'Decision Height',
            translation: 'Karar İrtifasında, gerekli görsel referans sağlanamazsa tırmanış prosedürü uygulanmalıdır.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Sınavlar için CAT II/III temel ayrımları:\n• **DH** = Karar İrtifası (radyo altimetre tabanlı, CAT II/III)\n• **DA** = Karar Yüksekliği (barometre tabanlı, CAT I)\n• **RVR** = Pist Görüş Mesafesi (transmissometre ile ölçülür)\n• Otomatik taksi/fren kullanılabilirse CAT IIIB yaklaşma **Karar İrtifası olmadan** yapılabilir\n• LVP, düşük görüşlü kalkışları otomatik olarak iptal etmez — ayrı LVT minimumlari vardır\n• CAT III için "zorunlu görsel referans" CAT I\'e göre **daha azdır** (yalnızca pist kenar ışıkları yeterli olabilir)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -280, category: QuestionCategory.sentenceCompletion, originalNumber: 980, questionText: 'A CAT III approach uses ………… altitude as the reference point for the go-around decision.', options: ['Minimum Descent', 'Decision Height', 'Decision Altitude', 'Obstacle Clearance'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -281, category: QuestionCategory.sentenceCompletion, originalNumber: 981, questionText: 'LVP (Low Visibility Procedures) are normally activated when RVR drops below ………….', options: ['800 meters', '1,000 meters', '600 meters', '400 meters'], correctIndex: 2, difficulty: Difficulty.hard),
          QuestionModel(id: -282, category: QuestionCategory.sentenceCompletion, originalNumber: 982, questionText: 'For a CAT IIIA approach, the minimum RVR is ………….', options: ['550 meters', '300 meters', '200 meters', '100 meters'], correctIndex: 2, difficulty: Difficulty.hard),
          QuestionModel(id: -283, category: QuestionCategory.sentenceCompletion, originalNumber: 983, questionText: 'The autoland system callout "LAND 3" on an Airbus A320 indicates:', options: ['Third approach attempt', 'Autoland is armed and all three redundant systems are active', 'Landing gear is down and locked', 'CAT III clearance received'], correctIndex: 1, difficulty: Difficulty.hard),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON A6 — Advanced ATC Clearances Fill-in
  // ─────────────────────────────────────────────────────────────
  static const _advancedAtcClearances = LessonContent(
    id: 'fill_5',
    title: 'İleri ATC Klirensları',
    subtitle: 'Karmaşık klirens yapıları ve okyanus ifade kalıpları',
    categoryId: 'fill_blanks',
    estimatedTime: '12 dk',
    emoji: '🗼',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'İleri klirenslar birden fazla unsuru birleştirir',
        body:
            'İleri düzeyde, ATC kliransları tek bir iletimde irtifa, yön, hız, frekans ve transponder gibi birden fazla eş zamanlı talimat içerir. Bunları doğru analiz etmek ve tamamlamak, uzman düzey sınavlarda test edilen üst düzey bir beceridir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🗼 Okyanus & Karmaşık Klirans Unsurları',
        body:
            '**Oceanic clearance:** "THY1 is cleared to New York JFK via track Bravo, flight level 360, Mach 0.84, squawk 2341"\n\n**Complex enroute:** "THY456, cross TURPO at or above FL280, then direct EMEVI, reduce to Mach 0.80"\n\n**Conditional clearance:** "Behind the departing B777, line up runway 34L and wait"\n— Always read back: **type of aircraft + condition + instruction**\n\n**SELCAL** — Selective Calling system for oceanic comms\n**HF** — High Frequency radio (used in oceanic areas beyond VHF range)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔄 Bekleme Klirans Dili',
        body:
            '"THY123, hold at TURPO as published, expect approach in 20 minutes"\n"………… to the right on the 150 radial, 1-minute legs"\n\n**Key holding terms:**\n• **Inbound course** — heading toward the fix during holding\n• **Outbound leg** — time/distance spent flying away from fix\n• **Expect further clearance (EFC)** — time pilot can expect to leave the hold\n• **Published hold** — charted holding pattern; use standard values\n• "**Left / right turns**" — direction of turns in the hold',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'İleri Klirans Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'THY123, cross TURPO at or above FL260, then direct EMEVI, Mach 0.82.',
            highlight: 'cross TURPO at or above',
            translation: 'THY123, TURPO\'yu FL260 veya üzerinde geçin, ardından EMEVI\'ye direkt, Mach 0.82.',
          ),
          ExampleSentence(
            sentence: 'Behind the departing A330, line up runway 18L and wait.',
            highlight: 'Behind the departing',
            translation: 'Kalkan A330\'un arkasında, pist 18L\'ye sıraya girin ve bekleyin.',
          ),
          ExampleSentence(
            sentence: 'Hold at VESAS on the 270 radial, right turns, 1-minute legs, expect approach at 1430.',
            highlight: 'Hold at',
            translation: 'VESAS\'ta 270 radyal üzerinde, sağ turlar, 1 dakikalık bacaklar, saat 14:30\'da yaklaşma bekleniyor.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ İleri Sınav İpuçları',
        body:
            'Koşulllu kliranslar — her zaman şunları belirleyin:\n1. **Koşul** — hangi uçak / ne zaman\n2. **Talimat** — ne yapılacak\n3. **Tekrar** koşulu içermelidir: "Behind the B777 on final, cleared to land, THY456"\n\nOkyanus kliransları her zaman şunları içerir: track harfi + FL + Mach numarası + squawk\n\nEFC (Expect Further Clearance) bekleme döngüsünden ayrılma kliransı **değildir** — pilot gerçek kliransı beklemelidir.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -290, category: QuestionCategory.fillBlanks, originalNumber: 790, questionText: '"………… the A330 on final, line up runway 34L and wait." — The missing word is:', options: ['After', 'Following', 'Behind', 'When'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -291, category: QuestionCategory.fillBlanks, originalNumber: 791, questionText: 'An oceanic clearance always includes the assigned ………… number as the track speed reference.', options: ['Knots', 'IAS', 'Mach', 'TAS'], correctIndex: 2, difficulty: Difficulty.hard),
          QuestionModel(id: -292, category: QuestionCategory.fillBlanks, originalNumber: 792, questionText: '"Hold at TURPO, ………… turns, 1-minute legs, expect clearance at 1520."', options: ['left or right', 'standard', 'right', 'left'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -293, category: QuestionCategory.fillBlanks, originalNumber: 793, questionText: '"THY456, cross EMEVI ………… FL240." — The missing phrase is:', options: ['at or above', 'at minimum', 'maintaining', 'no lower than'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON A7 — Accident Investigation Translation
  // ─────────────────────────────────────────────────────────────
  static const _accidentTranslation = LessonContent(
    id: 'translation_4',
    title: 'Kaza Soruşturma Raporları',
    subtitle: 'ICAO Ek 13 soruşturma dilini çevirme',
    categoryId: 'translation',
    estimatedTime: '13 dk',
    emoji: '📰',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Kaza raporları kesin hukuki ve teknik dil kullanır',
        body:
            'ICAO Ek 13 kaza araştırma raporları, havacılıktaki en dilbilimsel açıdan zorlayıcı belgeler arasındadır. Tek bir metinde hukuki kesinliği, edilgen yapıları, teknik doğruluğu ve nedensellik analizini bir araya getirirler.\n\nBu raporlardan çeviri soruları, hem teknik anlamı hem de her ifadenin hukuki sonuçlarını anlamayı gerektirir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚠️ Nedensellik Dili',
        body:
            '**Probable cause** — the primary factor judged to have produced the accident\n**Contributing factor** — a condition that increased risk but was not the primary cause\n**Causal factor** — any element in the cause chain\n\nCausal verbs and phrases:\n• "**led to**" = caused/resulted in (direct chain)\n• "**attributed to**" = judged as the cause\n• "**resulted in**" = produced this outcome\n• "**was a factor in**" = contributed but not sole cause\n• "**was consistent with**" = evidence matches this explanation',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Soruşturma Bulguları Dili',
        body:
            '"The investigation **found** that…" → formal finding\n"Evidence **indicated** that…" → supported but not proven\n"**It could not be determined** whether…" → insufficient evidence\n"The crew **failed to**…" → did not perform required action\n"**Contrary to** the standard operating procedure…" → SOP violation\n"The accident **is survivable** / **was not survivable**" → survivability finding\n"**Safety recommendation**" → formal advisory to prevent recurrence',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Rapor Metni Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'The probable cause of the accident was the crew\'s failure to monitor fuel quantity.',
            highlight: 'probable cause',
            translation: 'Kazanın muhtemel nedeni, ekibin yakıt miktarını izlememesiydi.',
          ),
          ExampleSentence(
            sentence: 'It could not be determined whether the crew had received the updated weather information.',
            highlight: 'It could not be determined',
            translation: 'Ekibin güncellenmiş hava durumu bilgisini alıp almadığı belirlenemedi.',
          ),
          ExampleSentence(
            sentence: 'The investigation attributed the loss of situational awareness to crew fatigue and inadequate CRM.',
            highlight: 'attributed to',
            translation: 'Soruşturma, durum farkındalığının kaybını mürettebat yorgunluğuna ve yetersiz EKY\'ye bağladı.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Çeviri Sınav Stratejisi',
        body:
            'Kaza raporu çeviri soruları için:\n• "**Probable cause**" ≠ "possible cause" — tespit edilen EN MUHTEMEL nedendir\n• "**Contributing factor**" ≠ "main reason" — ikincil, ağırlaştırıcı bir koşuldur\n• "**Crew failed to**" = zorunlu bir eylem yapılmadı — doğrudan ihmal anlamı taşımaz\n• "**It could not be determined**" = yetersiz kanıt — "bilinmiyor" olarak çevirmeyin\n• "**Contrary to SOP**" = prosedür ihlali — raporlarda her zaman ciddidir',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(id: -300, category: QuestionCategory.translation, originalNumber: 460, questionText: '"The accident was attributed to controlled flight into terrain." This means:', options: ['The accident was caused by an out-of-control aircraft hitting terrain', 'The aircraft was in controlled flight when it struck terrain', 'The crew controlled the aircraft into terrain intentionally', 'The terrain was controlled by ATC when the accident occurred'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -301, category: QuestionCategory.translation, originalNumber: 461, questionText: '"Contrary to standard operating procedures" means:', options: ['In accordance with SOPs', 'Violating or not following SOPs', 'Similar to SOPs in other companies', 'An improvement over SOPs'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -302, category: QuestionCategory.translation, originalNumber: 462, questionText: '"A contributing factor was the inadequate crew rest period." This means:', options: ['The main cause was crew rest', 'Crew rest was one element that made the accident more likely', 'Crew rest alone caused the accident', 'The crew rested adequately'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -303, category: QuestionCategory.translation, originalNumber: 463, questionText: '"It could not be determined whether…" in a report means:', options: ['It is confirmed that', 'There was not enough evidence to establish', 'It is unlikely that', 'The investigation did not examine'], correctIndex: 1, difficulty: Difficulty.hard),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON A8 — Airworthiness Directives
  // ─────────────────────────────────────────────────────────────
  static const _airworthinessDirectives = LessonContent(
    id: 'reading_6',
    title: 'Uçuşa Elverişlilik Direktifleri',
    subtitle: 'Zorunlu güvenlik bildirimlerini okuma ve yorumlama',
    categoryId: 'reading',
    estimatedTime: '13 dk',
    emoji: '📜',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'ADs are mandatory safety compliance documents',
        body:
            'Uçuşa Elverişlilik Direktifi (AD), belirli bir uçak tipindeki güvenli olmayan bir durumu gidermek amacıyla sivil havacılık otoritesi tarafından zorunlu eylem gerektiren yasal bağlayıcı bir belgedir. Uyumsuzluk yasadışıdır ve işletme sertifikasının askıya alınmasına yol açabilir.\n\nAD dili havacılıktaki en kesin düzenleyici dildir — her kelimenin yasal ağırlığı vardır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📜 AD Yapısı',
        body:
            'Tipik bir AD şunları içerir:\n1. **Uygulanabilirlik** — hangi uçak/motor/parçalar etkileniyor\n2. **Güvensiz durum** — çözülecek tehlike\n3. **Gerekli eylem** — ne yapılması gerekiyor\n4. **Uyumluluk süresi** — ne zamana kadar yapılmalı (ör. "50 uçuş saati içinde")\n5. **Yöntem** — nasıl uyulur (servis bülteni, özel prosedür)\n6. **Alternatif Uyumluluk Yöntemi (AMOC)** — onaylanmış alternatif\n7. **Maliyetler** — tahmini uyumluluk maliyeti',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚠️ Uyumluluk Süresi Dili',
        body:
            '**"Within 50 flight hours after the effective date"** — must be done before 50 more hours\n**"At the next scheduled maintenance"** — at next A/B/C check\n**"Before further flight"** — aircraft must not fly until complied with\n**"At first opportunity"** — as soon as practical (not as urgent as "before further flight")\n**"Repetitive inspection every 200 FH"** — not a one-time action; must be repeated\n**"Terminating action"** — permanently satisfies the AD (no more repetitive checks needed)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'AD Dili Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'This AD requires repetitive inspections of the fuselage skin every 500 flight cycles.',
            highlight: 'repetitive inspections',
            translation: 'Bu AD, her 500 uçuş çevriminde gövde kaplamasının tekrarlı denetimlerini gerektirmektedir.',
          ),
          ExampleSentence(
            sentence: 'The applicability of this AD extends to all Boeing 737-800 aircraft with serial numbers 35201 through 41234.',
            highlight: 'applicability',
            translation: 'Bu AD\'nin uygulanabilirliği, 35201 ile 41234 arasındaki seri numaralarına sahip tüm Boeing 737-800 uçaklarını kapsamaktadır.',
          ),
          ExampleSentence(
            sentence: 'Compliance is required before further flight after the effective date.',
            highlight: 'before further flight',
            translation: 'Yürürlük tarihinden sonra daha fazla uçuştan önce uyum zorunludur.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ İleri Okuma Stratejisi',
        body:
            'AD okuma anlama soruları için:\n• **Uygulanabilirlik** bölümü hangi uçakların etkilendiğini söyler — bunu önce kontrol edin\n• "**Before further flight**" = en acil uyumluluk süresi — uçak YER\'DE KALMALIDIR\n• "**Terminating action**" = bir kez yapıldığında tekrar edici denetim gerekmez\n• **AMOC** = alternatif uyumluluk yöntemi — otorite tarafından onaylanmalıdır\n• "**At the next scheduled**" "isteğe bağlı" anlamına gelmez — o noktada zorunludur\n• Tarihlere dikkat edin: "after the effective date" ile "from the date of manufacture"',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        body: 'Read the following AD extract:\n\n"This Airworthiness Directive is applicable to all Airbus A320-200 aircraft, serial numbers 3001 through 5500. The unsafe condition is potential fatigue cracking of the forward fuselage frame. Required action: Perform a detailed visual inspection of the forward fuselage frame assembly. Compliance time: Within 100 flight cycles after the effective date of this AD. Repetitive inspection interval: Every 500 flight cycles thereafter. Terminating action: Replacement of the frame assembly with Part Number A320-FR-9902 permanently terminates the repetitive inspection requirement."',
        practiceQuestions: [
          QuestionModel(id: -310, category: QuestionCategory.reading, originalNumber: 650, questionText: 'Which aircraft are affected by this AD?', options: ['All Airbus A320 variants', 'A320-200 with serial numbers 3001–5500', 'A320-200 manufactured after the effective date', 'All Airbus narrowbody aircraft'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -311, category: QuestionCategory.reading, originalNumber: 651, questionText: 'How often must the repetitive inspection be performed?', options: ['Every 100 flight cycles', 'Once only', 'Every 500 flight cycles', 'At every annual check'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -312, category: QuestionCategory.reading, originalNumber: 652, questionText: 'What action permanently eliminates the need for repetitive inspections?', options: ['Performing 10 consecutive inspections with no findings', 'Replacing the frame assembly with Part Number A320-FR-9902', 'Operating the aircraft for 5,000 flight cycles', 'Obtaining an AMOC from the authority'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -313, category: QuestionCategory.reading, originalNumber: 653, questionText: 'The first inspection must be completed:', options: ['Before the next annual check', 'Within 100 flight cycles after the effective date', 'Before the next 500 flight cycles', 'At first opportunity after receiving the AD'], correctIndex: 1, difficulty: Difficulty.easy),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // LESSON 12 — Advanced Sentence Completion
  // ─────────────────────────────────────────────────────────────
  static const _advancedCompletion = LessonContent(
    id: 'completion_2',
    title: 'İleri Düzey Tamamlama',
    subtitle: 'Karmaşık teknik cümle tamamlama',
    categoryId: 'sentence_completion',
    estimatedTime: '12 dk',
    emoji: '🎯',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'İleri düzey tamamlama tam bağlam anlayışı gerektirir',
        body:
            'İleri düzeyde cümle tamamlama soruları, birden fazla seçeneğin dilbilgisel olarak doğru görünebildiği karmaşık teknik cümleler içerir. Doğru cevap hem dilbilgisi **hem de** havacılık teknik bilgisi gerektirmektedir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚙️ Teknik Öbek Kalıpları',
        body:
            'Havacılık teknik yazımı, her zaman birlikte kullanılan sabit öbekler içerir:\n\n• perform/carry out/conduct (**a maintenance check**) — "make" veya "do" değil\n• comply with (**regulations**) — "follow to" değil\n• in accordance with (**AMM/CMM**) — standart ifade\n• prior to/following (**departure**) — resmi zaman ifadeleri\n• serviceability of (**equipment**) — uuçuşa elverişlilik terimi\n• within the limits (**specified in**) — uyumluluk dili',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📐 Kesinlik Dili',
        body:
            'Havacılık İngilizcesi zarafet yerine **kesinliğe** değer verir. Kelimeler birbirinin yerine kullanılamaz:\n• **inspect** = görsel inceleme | **test** = işlevsel doğrulama | **check** = durumu onaylama\n• **fault** = belirli arıza | **failure** = tam fonksiyon kaybı | **malfunction** = kısmi/aralıklı arıza\n• **serviceable** = kullanıma uygun | **unserviceable** = kullanıma uygun değil (teknik terim)\n• **advise** = bildir/tavsiye et | **instruct** = zorunlu yön ver',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Advanced Completion Examples',
        examples: [
          ExampleSentence(
            sentence: 'All repairs must be carried out __________ the Aircraft Maintenance Manual.',
            highlight: 'in accordance with',
            translation: 'Tüm onarımlar Uçak Bakım El Kitabına uygun olarak yapılmalıdır.',
          ),
          ExampleSentence(
            sentence: 'The component was declared __________ after a detailed visual inspection.',
            highlight: 'unserviceable',
            translation: 'Parça, ayrıntılı görsel incelemenin ardından kullanılamaz ilan edildi.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Final Sınav Stratejisi',
        body:
            'İleri düzey tamamlama için:\n1. **Teknik bağlamı** belirleyin (bakım, operasyon, ATC)\n2. **Dil düzeyini** kontrol edin — resmi belge mi yoksa iletişim mi?\n3. **Dilbilgisel işlevi** kontrol edin — hangi konuşma parçası uyuyor?\n4. Havacılık **teknik sözcüğünü** kullanın — genel İngilizce kelime havacılıkta yanlış olabilir\n5. İki seçenek doğru görünüyorsa **daha spesifik/teknik** olanı seçin',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -110,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 1901,
            questionText: 'All maintenance must be ………… in accordance with the approved data.',
            options: ['made', 'done', 'carried out', 'fulfilled'],
            correctIndex: 2,
            difficulty: Difficulty.hard,
          ),
          QuestionModel(
            id: -111,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 1902,
            questionText: 'The component was found to be ………… and was removed from service.',
            options: ['broken', 'unserviceable', 'damaged slightly', 'not working'],
            correctIndex: 1,
            difficulty: Difficulty.hard,
          ),
          QuestionModel(
            id: -112,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 1903,
            questionText: 'The captain decided to ………… to the alternate airport due to severe turbulence ahead.',
            options: ['redirect', 'divert', 'turn', 'fly'],
            correctIndex: 1,
            difficulty: Difficulty.hard,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // CABIN 1 — Safety Announcements
  // ─────────────────────────────────────────────────────────────
  static const _cabin1SafetyAnnouncements = LessonContent(
    id: 'cabin_1',
    title: 'Güvenlik Anonsları',
    subtitle: 'Standart kabin duyuruları ve kalıpları',
    categoryId: 'cabin',
    estimatedTime: '10 dk',
    emoji: '📢',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Neden standart ifadeler önemlidir',
        body:
            'Kabin güvenlik anonsları **düzenleyici kurumlar tarafından onaylanmış** sabit ifadeler içerir. IATA ve havayollarının kendi prosedürleri, yolcuların her uçuşta aynı mesajı anlamasını sağlamak için belirli kelimeler kullanır.\n\nBu kalıpları ezberlemek, baskı altında bile doğru ve net iletişim kurmanızı sağlar.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Temel Anonslardaki Kalıplar',
        body:
            '**Kalkış öncesi:**\n• "Please ensure your seatbelt is fastened and your seat is in the upright position."\n• "All portable electronic devices must be switched off or set to flight mode."\n• "Please direct your attention to the cabin crew for the safety demonstration."\n\n**Türbülans:**\n• "The captain has turned on the fasten seatbelt sign. Please return to your seats immediately."\n\n**İniş:**\n• "Cabin crew, please prepare for landing."\n• "We are beginning our descent into [city]."\n\n**Anahtar fiiller:** *ensure, fasten, secure, remain, proceed, direct*',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnek Anonslar',
        examples: [
          ExampleSentence(
            sentence: 'Ladies and gentlemen, please ensure all carry-on baggage is stowed in the overhead bins or under the seat in front of you.',
            highlight: 'ensure … is stowed',
            translation: 'Bayanlar ve baylar, lütfen tüm el bagajlarınızın üstteki bagaj bölmelerinde veya önünüzdeki koltuğun altında yerleştirildiğinden emin olun.',
          ),
          ExampleSentence(
            sentence: 'We remind you that this is a non-smoking flight. Smoking is prohibited throughout the aircraft, including the lavatories.',
            highlight: 'is prohibited',
            translation: 'Bu uçuşun sigara içilmeyen bir uçuş olduğunu hatırlatırız. Tuvaletler dahil olmak üzere uçak içinde sigara içmek yasaktır.',
          ),
          ExampleSentence(
            sentence: 'In the event of a sudden loss of cabin pressure, oxygen masks will drop from above. Pull the mask towards you, place it over your nose and mouth, and breathe normally.',
            highlight: 'In the event of',
            translation: 'Kabin basıncında ani bir düşüş olması durumunda, oksijen maskeleri yukarıdan düşecektir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -120,
            category: QuestionCategory.vocabulary,
            originalNumber: 2001,
            questionText: 'Which phrase correctly completes the safety announcement: "Please ………… your seatbelt is securely fastened"?',
            options: ['check', 'ensure', 'verify', 'confirm'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -121,
            category: QuestionCategory.vocabulary,
            originalNumber: 2002,
            questionText: 'In a standard cabin announcement, "the upright position" refers to:',
            options: ['standing position', 'seat back position', 'tray table', 'armrest'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -122,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2003,
            questionText: '"Cabin crew, please ………… for landing." — What is the standard word?',
            options: ['prepare', 'ready', 'arrange', 'set'],
            correctIndex: 0,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // CABIN 2 — Passenger Communication
  // ─────────────────────────────────────────────────────────────
  static const _cabin2PassengerComm = LessonContent(
    id: 'cabin_2',
    title: 'Yolcu İletişimi',
    subtitle: 'Nazik istek kalıpları ve hizmet dili',
    categoryId: 'cabin',
    estimatedTime: '10 dk',
    emoji: '🤝',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Hizmet dili neden özel bir beceridir',
        body:
            'Kabin görevlileri hem **hizmet veren** hem de **otorite temsilcisi** rolündedir. Bu nedenle yolcularla kurulan iletişimde hem nazik hem de net olmak gerekir.\n\nFarklı durumlara göre farklı dil düzeyleri kullanılır: normal hizmet için yumuşak istekler, güvenlik kuralları için daha doğrudan ifadeler.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '💬 İstek ve Yönerge Kalıpları',
        body:
            '**Nazik istekler (hizmet):**\n• "Would you like …?" — teklif\n• "Could I get you …?" — teklif\n• "Would you mind …?" — rica\n• "I\'m afraid …" — olumsuz yanıt verme\n\n**Doğrudan yönergeler (güvenlik):**\n• "Please return to your seat."\n• "I need you to fasten your seatbelt now."\n• "Sir/Ma\'am, this item must be stowed."\n\n**Şikayet yönetimi:**\n• "I understand your concern, and I apologize for the inconvenience."\n• "I\'ll do my best to …"\n• "Allow me to …"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Diyalog Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'I\'m afraid we\'ve run out of the chicken option. Would the pasta be acceptable?',
            highlight: "I'm afraid … Would … be acceptable",
            translation: 'Maalesef tavuk seçeneğimiz tükendi. Makarna uygun olur mu?',
          ),
          ExampleSentence(
            sentence: 'Sir, I need you to return to your seat and fasten your seatbelt. The captain has switched on the fasten seatbelt sign.',
            highlight: 'I need you to',
            translation: 'Efendim, yerinize dönüp emniyet kemerinizi bağlamanız gerekiyor. Kaptan emniyet kemeri işaretini açtı.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -123,
            category: QuestionCategory.vocabulary,
            originalNumber: 2004,
            questionText: 'A passenger complains about seat discomfort. The most professional response begins with:',
            options: ['That\'s not my problem.', 'I understand your concern, and I apologize for the inconvenience.', 'You should have chosen a different seat.', 'Please wait.'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -124,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2005,
            questionText: '"………… you like another drink?" — Choose the correct form.',
            options: ['Do', 'Would', 'Can', 'Shall'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -125,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2006,
            questionText: 'When asking a passenger to move a bag from an aisle: "I\'m afraid this bag ………… be stowed in the overhead bin."',
            options: ['can', 'will', 'must', 'should'],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // CABIN 3 — Emergency Procedures
  // ─────────────────────────────────────────────────────────────
  static const _cabin3EmergencyProc = LessonContent(
    id: 'cabin_3',
    title: 'Acil Durum İletişimi',
    subtitle: 'Tahliye, brace ve acil anons dili',
    categoryId: 'cabin',
    estimatedTime: '12 dk',
    emoji: '🚨',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Acil durumda dil kesinliği hayat kurtarır',
        body:
            'Acil durum komutları **kısa, net ve tereddütsüz** olmalıdır. Normal hizmet dilinin aksine, acil durumlarda "please" veya "would you mind" kullanılmaz — doğrudan emir kipi tercih edilir.\n\nEACCS (Emergency Aircraft Crew Communication System) standartlarına göre acil durum anonsları uluslararası standart ifadeler içerir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚠️ Standart Acil Durum Komutları',
        body:
            '**Brace komutu:**\n• "Brace! Brace! Brace!" — acil iniş pozisyonu\n• "Head down! Stay down!"\n\n**Tahliye komutları:**\n• "Release seatbelts! Come this way!"\n• "Leave everything! Get out!"\n• "Jump and slide!" (kaydıraklarda)\n\n**Yangın/duman:**\n• "There is smoke in the cabin. Please remain calm and follow crew instructions."\n\n**Tıbbi:**\n• "Is there a doctor or medical professional on board?"\n\n**Kapı güvenliği:**\n• "Doors to manual and cross-check" / "Doors to automatic and cross-check"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Acil Anonslara Örnekler',
        examples: [
          ExampleSentence(
            sentence: 'Attention, this is an emergency. Fasten your seatbelts, put your seat backs and tray tables in their upright positions, and brace for impact.',
            highlight: 'brace for impact',
            translation: 'Dikkat, bu bir acil durumdur. Emniyet kemerlerinizi bağlayın, koltuk arkalıklarınızı ve tepsi masalarınızı dik konuma getirin ve çarpma için hazır olun.',
          ),
          ExampleSentence(
            sentence: 'All passengers must evacuate the aircraft immediately. Leave all hand baggage behind and proceed to the nearest exit.',
            highlight: 'Leave all hand baggage behind',
            translation: 'Tüm yolcular uçaktan derhal tahliye edilmelidir. Tüm el bagajlarınızı geride bırakın ve en yakın çıkışa doğru ilerleyin.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -126,
            category: QuestionCategory.vocabulary,
            originalNumber: 2007,
            questionText: 'The command "Brace! Brace! Brace!" is given to:',
            options: ['begin service', 'prepare passengers for a crash landing', 'open emergency exits', 'call for medical help'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -127,
            category: QuestionCategory.vocabulary,
            originalNumber: 2008,
            questionText: '"Doors to automatic and cross-check" is said:',
            options: ['during service', 'before departure', 'during evacuation', 'at cruising altitude'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -128,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2009,
            questionText: 'During evacuation, "Leave ………… behind" means passengers should not take their bags.',
            options: ['everything', 'nothing', 'someone', 'anyone'],
            correctIndex: 0,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // CABIN 4 — CRM & Crew Briefing
  // ─────────────────────────────────────────────────────────────
  static const _cabin4CrmBriefing = LessonContent(
    id: 'cabin_4',
    title: 'CRM ve Ekip İletişimi',
    subtitle: 'Ekip kaynak yönetimi ve brifing dili',
    categoryId: 'cabin',
    estimatedTime: '12 dk',
    emoji: '🧑‍✈️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'CRM neden hayati önem taşır',
        body:
            '**Crew Resource Management (CRM)**, kaza önlemede kritik bir faktördür. Araştırmalar, uçak kazalarının büyük çoğunluğunun teknik arızadan değil **iletişim ve ekip koordinasyonu** yetersizliğinden kaynaklandığını göstermektedir.\n\nEtkili CRM dili şunları içerir: açık çağrı yöntemi, challenge-response, sterile cockpit kuralına uyum ve güvenlik endişelerini iletebilme.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔄 CRM İletişim Teknikleri',
        body:
            '**Closed-loop communication (kapalı döngü iletişim):**\n• Gönderici mesajı iletir\n• Alıcı mesajı tekrarlar\n• Gönderici onaylar\n\n**Assertiveness (iddialı iletişim):**\n• "I am concerned about …" — endişeyi bildirme\n• "I recommend we …" — öneri\n• "I need to advise you that …" — uyarı\n\n**Sterile cockpit:**\n• "Sterile cockpit is now in effect" — uçuşun kritik fazlarında\n• Yalnızca güvenlikle ilgili iletişim\n\n**Pre-flight briefing:**\n• "Today\'s senior cabin crew is …"\n• "Our emergency equipment locations are …"\n• "In the event of …, our procedure is …"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'CRM Diyalog Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'Captain, I am concerned that a passenger in row 14 appears to be extremely intoxicated and may pose a safety risk.',
            highlight: 'I am concerned that … may pose a safety risk',
            translation: 'Kaptan, 14. sıradaki bir yolcunun aşırı sarhoş göründüğü ve güvenlik riski oluşturabileceği konusunda endişeliydim.',
          ),
          ExampleSentence(
            sentence: 'Cross-check complete. All doors are armed and confirmed.',
            highlight: 'Cross-check complete',
            translation: 'Çapraz kontrol tamamlandı. Tüm kapılar devrede ve onaylandı.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -129,
            category: QuestionCategory.vocabulary,
            originalNumber: 2010,
            questionText: '"Sterile cockpit" means:',
            options: ['the cockpit is clean', 'only safety-related communication is allowed', 'the crew is on break', 'passengers must be silent'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -130,
            category: QuestionCategory.vocabulary,
            originalNumber: 2011,
            questionText: 'In CRM, "closed-loop communication" refers to:',
            options: ['sending encrypted messages', 'repeating back a received message to confirm understanding', 'communicating only with the captain', 'using an interphone'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -131,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2012,
            questionText: '"I am ………… about the amount of fuel remaining" — assertive CRM language.',
            options: ['worried', 'concerned', 'afraid', 'nervous'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // CABIN 5 — Medical Terminology
  // ─────────────────────────────────────────────────────────────
  static const _cabin5MedicalTerms = LessonContent(
    id: 'cabin_5',
    title: 'Tıbbi Terminoloji',
    subtitle: 'Uçuş içi tıbbi durum bildirme dili',
    categoryId: 'cabin',
    estimatedTime: '12 dk',
    emoji: '🏥',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Uçuşta tıbbi acil yönetimi',
        body:
            'Kabin görevlileri ilk yardım eğitimi almış olsa da tıbbi bir acil durumda doktor veya sağlık profesyoneliyle iletişim kurmak için **doğru terminolojiyi** kullanmak gerekir.\n\nAyrıca yer kontrolü veya MEDLINK hizmetiyle iletişimde belirtileri doğru İngilizce ile aktarmak kritik önem taşır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🩺 Temel Tıbbi Terimler',
        body:
            '**Bilinç durumu:**\n• conscious / unconscious — bilinçli / bilinçsiz\n• responsive / unresponsive — tepki veriyor / vermiyor\n• disoriented — dezoryantasyon\n\n**Belirtiler:**\n• chest pain — göğüs ağrısı\n• shortness of breath / dyspnea — nefes darlığı\n• nausea / vomiting — bulantı / kusma\n• seizure — nöbet\n• anaphylaxis — anafilaksi (ciddi alerjik reaksiyon)\n• hypoglycemia — hipoglisemi (düşük kan şekeri)\n\n**Müdahale:**\n• administer oxygen — oksijen ver\n• AED (Automated External Defibrillator) — otomatik harici defibrilatör\n• first aid kit — ilk yardım çantası\n• Is there a doctor or medical professional on board?',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Tıbbi Durum Bildirimi',
        examples: [
          ExampleSentence(
            sentence: 'The passenger is conscious but unresponsive. She is breathing, but her pulse is weak and irregular.',
            highlight: 'conscious but unresponsive … pulse is weak and irregular',
            translation: 'Yolcu bilinçli ancak tepkisiz. Nefes alıyor, ancak nabzı zayıf ve düzensiz.',
          ),
          ExampleSentence(
            sentence: 'The passenger is experiencing severe chest pain radiating to his left arm. We suspect a cardiac event.',
            highlight: 'radiating to … cardiac event',
            translation: 'Yolcu sol koluna yayılan şiddetli göğüs ağrısı yaşıyor. Kardiyak bir olay şüpheleniyoruz.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -132,
            category: QuestionCategory.vocabulary,
            originalNumber: 2013,
            questionText: 'A passenger who is "unresponsive" means they:',
            options: ['are sleeping', 'do not react to stimuli', 'are refusing service', 'are speaking a foreign language'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -133,
            category: QuestionCategory.vocabulary,
            originalNumber: 2014,
            questionText: '"Anaphylaxis" in a medical report refers to:',
            options: ['a broken bone', 'a severe allergic reaction', 'loss of consciousness', 'a heart attack'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -134,
            category: QuestionCategory.vocabulary,
            originalNumber: 2015,
            questionText: 'What does "AED" stand for?',
            options: ['Aircraft Emergency Device', 'Automated External Defibrillator', 'Advanced Emergency Doctor', 'Aviation Emergency Directive'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // CABIN 6 — Dangerous Goods Language
  // ─────────────────────────────────────────────────────────────
  static const _cabin6DangerousGoods = LessonContent(
    id: 'cabin_6',
    title: 'Tehlikeli Madde Dili',
    subtitle: 'DG kategorileri ve mevzuat ifadeleri',
    categoryId: 'cabin',
    estimatedTime: '14 dk',
    emoji: '⚠️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Tehlikeli madde farkındalığı neden zorunludur',
        body:
            'ICAO Technical Instructions ve IATA DGR (Dangerous Goods Regulations) uyarınca kabin ekibi tehlikeli madde tanımlama ve bildirme konusunda eğitim almalıdır.\n\nTehlikeli maddeler uçak güvenliğine ciddi tehdit oluşturabilir. Doğru tanımlama ve hızlı bildirim çok önemlidir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🏷️ IATA DG Kategorileri',
        body:
            '**9 Ana Tehlike Sınıfı:**\n• Class 1: Explosives — Patlayıcılar\n• Class 2: Gases — Gazlar\n• Class 3: Flammable liquids — Yanıcı sıvılar\n• Class 4: Flammable solids — Yanıcı katılar\n• Class 5: Oxidizing substances — Oksitleyici maddeler\n• Class 6: Toxic substances — Toksik maddeler\n• Class 7: Radioactive material — Radyoaktif materyal\n• Class 8: Corrosives — Aşındırıcılar\n• Class 9: Miscellaneous — Çeşitli tehlikeli maddeler (lityum piller dahil)\n\n**Yasaklı kalemler bildirimi:**\n• "This item is a prohibited article under IATA regulations."\n• "This item cannot be carried on board."',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'DG İletişim Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'I noticed a passenger attempting to board with a pressurized spray can that exceeds the permitted volume. I have removed it from the cabin.',
            highlight: 'pressurized … exceeds the permitted volume',
            translation: 'İzin verilen hacmi aşan basınçlı bir sprey kutusuyla binmeye çalışan bir yolcu fark ettim. Kabinden kaldırdım.',
          ),
          ExampleSentence(
            sentence: 'Lithium batteries in quantities exceeding the permitted limit are classified as Class 9 dangerous goods and must be declared.',
            highlight: 'must be declared',
            translation: 'İzin verilen sınırı aşan lityum piller Sınıf 9 tehlikeli madde olarak sınıflandırılır ve beyan edilmelidir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -135,
            category: QuestionCategory.vocabulary,
            originalNumber: 2016,
            questionText: 'Lithium batteries in excess quantities are classified under IATA Class:',
            options: ['Class 3', 'Class 6', 'Class 9', 'Class 1'],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -136,
            category: QuestionCategory.vocabulary,
            originalNumber: 2017,
            questionText: '"Corrosives" in the IATA DG classification refers to Class:',
            options: ['5', '6', '7', '8'],
            correctIndex: 3,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -137,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2018,
            questionText: '"This item cannot be ………… on board" — complete the standard DG phrase.',
            options: ['taken', 'carried', 'brought', 'loaded'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // AMT 1 — AMM Language
  // ─────────────────────────────────────────────────────────────
  static const _amt1AmmLanguage = LessonContent(
    id: 'amt_1',
    title: 'AMM Dili',
    subtitle: 'Uçak Bakım El Kitabı okuma ve anlama',
    categoryId: 'amt',
    estimatedTime: '12 dk',
    emoji: '📖',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'AMM neden standart bir dil kullanır',
        body:
            'Aircraft Maintenance Manual (AMM), teknik prosedürlerin evrensel olarak anlaşılmasını sağlamak için **ASD-STE100 (Simplified Technical English)** standardını kullanır.\n\nBu standart: kısa cümleler, aktif fiil kullanımı, belirsiz olmayan teknik terimler ve onaylı kelime listesi içerir. AMM\'yi doğru okumak; güvenli bakım, EASA/FAA uyumluluğu ve kaza önleme açısından kritiktir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔧 AMM Temel Yapıları',
        body:
            '**Zorunluluk dili (Modal verbs):**\n• "must" — zorunlu eylem (EASA/FAA şartı)\n• "shall" — resmi zorunluluk\n• "should" — tavsiye\n• "may" — izin verilen eylem\n\n**Prosedür fiilleri:**\n• inspect — görsel kontrol yap\n• remove/install — söküp/takma\n• torque to — belirtilen tork değerine sık\n• apply — uygula (torque, lubricant, sealant)\n• verify — doğrula\n• record — kayıt al\n\n**Uyarı seviyeleri:**\n• WARNING — kişisel yaralanma veya ölüm riski\n• CAUTION — ekipman hasarı riski\n• NOTE — prosedür bilgisi',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'AMM Prosedür Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'WARNING: Do not open the hydraulic reservoir cap until system pressure is fully released. Failure to comply may result in serious injury.',
            highlight: 'WARNING … must … Failure to comply',
            translation: 'UYARI: Sistem basıncı tamamen düşürülmeden hidrolik rezervuar kapağını açmayın. Uyulmaması ciddi yaralanmaya neden olabilir.',
          ),
          ExampleSentence(
            sentence: 'Torque the bolts to 25 Nm in a cross pattern. Apply Loctite 243 to the threads prior to installation.',
            highlight: 'Torque … Apply … prior to installation',
            translation: 'Cıvataları çapraz düzende 25 Nm\'ye sıkın. Montajdan önce dişlere Loctite 243 uygulayın.',
          ),
          ExampleSentence(
            sentence: 'Inspect the brake assembly for wear, cracks, and fluid leakage. Replace any components that do not meet the serviceability limits.',
            highlight: 'serviceability limits',
            translation: 'Fren tertibatını aşınma, çatlak ve sıvı sızıntısı için inceleyin. Kullanılabilirlik sınırlarını karşılamayan parçaları değiştirin.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -150,
            category: QuestionCategory.vocabulary,
            originalNumber: 2019,
            questionText: 'In an AMM, "WARNING" indicates:',
            options: ['a note about procedure sequence', 'risk of equipment damage only', 'risk of personal injury or death', 'a recommended but optional step'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -151,
            category: QuestionCategory.vocabulary,
            originalNumber: 2020,
            questionText: '"Torque to 25 Nm" in an AMM procedure means:',
            options: ['apply 25 Nm of force in any direction', 'tighten the fastener to exactly 25 Nm using a torque wrench', 'use a 25 mm wrench', 'tighten firmly without measuring'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -152,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2021,
            questionText: 'In AMM language, "must" indicates a ………… action required by regulation.',
            options: ['recommended', 'optional', 'mandatory', 'prohibited'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // AMT 2 — Technical Abbreviations
  // ─────────────────────────────────────────────────────────────
  static const _amt2Abbreviations = LessonContent(
    id: 'amt_2',
    title: 'Teknik Kısaltmalar',
    subtitle: 'Havacılık bakım terminolojisindeki kısaltmalar',
    categoryId: 'amt',
    estimatedTime: '12 dk',
    emoji: '🔤',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Kısaltmalar neden önemlidir',
        body:
            'Havacılık bakım dokümanları yüzlerce kısaltma içerir. Bu kısaltmaları yanlış anlamak **ciddi bakım hatalarına** yol açabilir.\n\nÖzellikle MEL, SB, AD, NDT ve CMM gibi terimler günlük iş akışında sıkça kullanılır ve doğru anlaşılmaları zorunludur.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Kritik Bakım Kısaltmaları',
        body:
            '**Dokümanlar:**\n• AMM — Aircraft Maintenance Manual\n• CMM — Component Maintenance Manual\n• IPC — Illustrated Parts Catalog\n• MEL — Minimum Equipment List\n• DDG — Dispatch Deviation Guide\n• SB — Service Bulletin (üretici önerileri)\n• AD — Airworthiness Directive (zorunlu direktif)\n\n**Teknik:**\n• NDT — Non-Destructive Testing\n• LRU — Line Replaceable Unit\n• BRT — Bench Run Test\n• ENG — Engine\n• APU — Auxiliary Power Unit\n• HYD — Hydraulics\n• BITE — Built-In Test Equipment\n\n**Durum:**\n• U/S — Unserviceable\n• S/B — Serviceable\n• AOG — Aircraft on Ground (acil durum)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Kısaltmaların Kullanımı',
        examples: [
          ExampleSentence(
            sentence: 'The LRU was found U/S during preflight inspection. An AOG message was sent to maintenance control.',
            highlight: 'LRU … U/S … AOG',
            translation: 'Uçuş öncesi incelemede LRU kullanılamaz durumda bulundu. Bakım kontrolüne AOG mesajı gönderildi.',
          ),
          ExampleSentence(
            sentence: 'Refer to the CMM for detailed overhaul procedures. NDT inspection is required at every major check.',
            highlight: 'CMM … NDT',
            translation: 'Detaylı revizyon prosedürleri için CMM\'ye bakın. Her büyük bakımda NDT muayenesi gereklidir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -153,
            category: QuestionCategory.vocabulary,
            originalNumber: 2022,
            questionText: '"AOG" in aircraft maintenance means:',
            options: ['Aircraft Overhaul Guide', 'Aircraft on Ground', 'Annual Overhaul Grading', 'Airworthiness Operations Group'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -154,
            category: QuestionCategory.vocabulary,
            originalNumber: 2023,
            questionText: '"MEL" stands for:',
            options: ['Maintenance Engineering Log', 'Minimum Equipment List', 'Manual Engine Limit', 'Maintenance Error Log'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -155,
            category: QuestionCategory.vocabulary,
            originalNumber: 2024,
            questionText: '"NDT" in aircraft maintenance refers to:',
            options: ['Normal Duty Time', 'Non-Destructive Testing', 'Night Departure Time', 'Navigation Display Terminal'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // AMT 3 — Airworthiness Directives Language
  // ─────────────────────────────────────────────────────────────
  static const _amt3Airworthiness = LessonContent(
    id: 'amt_3',
    title: 'Uçuşa Elverişlilik Direktifleri',
    subtitle: 'AD okuma ve uyumluluk dili',
    categoryId: 'amt',
    estimatedTime: '14 dk',
    emoji: '📜',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Airworthiness Directive (AD) nedir',
        body:
            'Airworthiness Directives (ADs), havacılık otoriteleri (EASA, FAA, SHGM) tarafından yayımlanan **zorunlu bakım direktifleridir**. Belirli bir güvenlik sorunu tespit edildiğinde yayımlanır ve uyum **yasal zorunluluktur**.\n\nBir AD\'yi okuyamayan veya yanlış yorumlayan bir teknisyen hem uçağı hem de kariyerini tehlikeye atar.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 AD Yapısı ve Anahtar İfadeler',
        body:
            '**Tipik AD bölümleri:**\n• Applicability — hangi uçak/motor tiplerine uygulanır\n• Reason — direktifin nedeni\n• Description of action — yapılacak işlem\n• Compliance — uyum süresi ve koşulları\n• Alternative Methods of Compliance (AMOC) — alternatif uyum yöntemi\n\n**Uyumluluk ifadeleri:**\n• "This AD requires …" — zorunlu eylem\n• "Within [X] flight hours after the effective date" — uyum süresi\n• "Before further flight" — acil, bir sonraki uçuştan önce\n• "At each [check type] interval" — periyodik\n• "Unless already accomplished" — daha önce yapılmışsa geçerli',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'AD Metinden Örnekler',
        examples: [
          ExampleSentence(
            sentence: 'This AD requires inspection of the wing spar attachment fittings within 500 flight hours after the effective date of this AD.',
            highlight: 'requires … within 500 flight hours after the effective date',
            translation: 'Bu AD, bu AD\'nin yürürlük tarihinden itibaren 500 uçuş saati içinde kanat lonjeronunun bağlantı parçalarının muayenesini gerektirmektedir.',
          ),
          ExampleSentence(
            sentence: 'Before further flight, replace the fuel pump with a serviceable unit in accordance with the AMM.',
            highlight: 'Before further flight … in accordance with the AMM',
            translation: 'Bir sonraki uçuştan önce, yakıt pompasını AMM\'ye uygun olarak kullanılabilir bir üniteyle değiştirin.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -156,
            category: QuestionCategory.vocabulary,
            originalNumber: 2025,
            questionText: '"Before further flight" in an AD means:',
            options: ['within 100 hours', 'at the next scheduled check', 'the action must be done before the next flight', 'within one calendar year'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -157,
            category: QuestionCategory.vocabulary,
            originalNumber: 2026,
            questionText: 'The "Applicability" section of an AD describes:',
            options: ['the cost of compliance', 'which aircraft types or serial numbers are affected', 'how to request an AMOC', 'the history of the safety issue'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -158,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2027,
            questionText: '"Unless already ………… " in an AD means the action is not required if it was previously done.',
            options: ['accomplished', 'inspected', 'recorded', 'approved'],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // AMT 4 — Regulatory Language (EASA/SHGM)
  // ─────────────────────────────────────────────────────────────
  static const _amt4RegulatoryLang = LessonContent(
    id: 'amt_4',
    title: 'Mevzuat Dili',
    subtitle: 'EASA Part-66 / Part-145 ve SHGM ifadeleri',
    categoryId: 'amt',
    estimatedTime: '14 dk',
    emoji: '⚖️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Neden mevzuat İngilizcesi öğrenilmeli',
        body:
            'EASA yönetmelikleri (Part-66, Part-145, Part-M) İngilizce olarak yayımlanır ve Türk SHGM mevzuatı da bu belgelere atıf yapar.\n\nBir teknisyen olarak lisans yenileme, yetki kazanma ve denetim süreçlerinde bu belgeleri okuyup anlayabilmek zorunludur. "Shall", "may", "must" gibi modal fiillerin mevzuattaki anlamları günlük İngilizceden farklıdır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📐 Mevzuatta Modal Fiil Hiyerarşisi',
        body:
            '**Zorunluluk seviyeleri (EASA/ICAO standartları):**\n• **shall** — kesin yasal zorunluluk (en güçlü)\n• **must** — zorunluluk (düzenleyici şart)\n• **should** — tavsiye edilen iyi uygulama\n• **may** — izin verilen seçenek\n\n**Dikkat:** Günlük İngilizcede "shall" eski moda; mevzuatta ise **zorunlu**dur.\n\n**Part-66 anahtar terimleri:**\n• holder of a licence — lisans sahibi\n• certifying staff — onaylayıcı personel\n• scope of work — iş kapsamı\n• authorisation — yetki\n• compliance — uyumluluk\n• findings — bulgular\n• corrective action — düzeltici faaliyet',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Mevzuat Metinden Örnekler',
        examples: [
          ExampleSentence(
            sentence: 'The holder of a Part-66 licence shall ensure that the licence is accessible when performing maintenance.',
            highlight: 'shall ensure',
            translation: 'Part-66 lisansının sahibi, bakım gerçekleştirirken lisansın erişilebilir olmasını sağlamalıdır (yasal zorunluluk).',
          ),
          ExampleSentence(
            sentence: 'Certifying staff shall not certify maintenance they have not performed or directly supervised.',
            highlight: 'shall not certify',
            translation: 'Onaylayıcı personel, bizzat gerçekleştirmediği veya doğrudan denetlemediği bakımı onaylamamalıdır.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -159,
            category: QuestionCategory.vocabulary,
            originalNumber: 2028,
            questionText: 'In EASA regulations, "shall" indicates:',
            options: ['a recommendation', 'a permitted option', 'a mandatory legal requirement', 'a prohibition'],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -160,
            category: QuestionCategory.vocabulary,
            originalNumber: 2029,
            questionText: '"Certifying staff" in Part-145 refers to:',
            options: ['staff who issue certificates to passengers', 'personnel authorized to certify that maintenance has been carried out', 'EASA inspectors', 'training instructors'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -161,
            category: QuestionCategory.vocabulary,
            originalNumber: 2030,
            questionText: '"Corrective action" in a regulatory context means:',
            options: ['a punishment', 'disciplinary action against a technician', 'action taken to fix a finding or non-compliance', 'a type of inspection'],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // AMT 5 — Defect Reporting
  // ─────────────────────────────────────────────────────────────
  static const _amt5DefectReporting = LessonContent(
    id: 'amt_5',
    title: 'Arıza Raporlama',
    subtitle: 'Teknik kayıt ve arıza raporu yazma dili',
    categoryId: 'amt',
    estimatedTime: '12 dk',
    emoji: '📝',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Neden doğru arıza kaydı kritiktir',
        body:
            'Teknik Log (Aircraft Technical Log) ve arıza raporları **yasal belgelerdir**. Bir arızanın yanlış veya eksik kaydedilmesi uçuş güvenliğini tehlikeye atar ve ciddi yasal sonuçlar doğurur.\n\nDoğru arıza kaydı: nedeni açıkça belirtir, yapılan işlemi doğru fiillerle anlatır ve yetkili onayı içerir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '✏️ Arıza Raporu Yazım Kuralları',
        body:
            '**Arıza tanımında kullanılan fiiller:**\n• found — bulundu (pasif keşif)\n• observed — gözlemlendi\n• reported — raporlandı / bildirildi\n• indicated — gösterge gösterdi\n• failed — arızalandı\n• leaked — sızdı\n\n**Düzeltici faaliyet fiilleri:**\n• replaced — değiştirildi\n• inspected — muayene edildi\n• cleaned and reinstalled — temizlendi ve yeniden takıldı\n• tested — test edildi\n• adjusted — ayarlandı\n• deferred in accordance with MEL — MEL kapsamında ertelendi\n\n**Kapanış ifadesi:**\n• "Aircraft released to service" / "Component released serviceable"\n• "Certified in accordance with AMM [chapter]"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Arıza Kayıt Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'Defect: No. 2 engine oil pressure found low during post-flight inspection. Action: Checked oil level — found 2 qts low. Added oil per AMM 79-00-00. Oil pressure normal on ground run.',
            highlight: 'found … Added … per AMM',
            translation: 'Arıza: Uçuş sonrası muayenede 2 no\'lu motor yağ basıncı düşük bulundu. İşlem: Yağ seviyesi kontrol edildi — 2 litre eksik bulundu. AMM 79-00-00\'a göre yağ ilave edildi. Yer çalıştırmasında yağ basıncı normal.',
          ),
          ExampleSentence(
            sentence: 'Defect deferred in accordance with MEL item 29-01. Aircraft released to service. Next required action within 3 flight days.',
            highlight: 'deferred in accordance with MEL … released to service',
            translation: 'Arıza MEL madde 29-01 kapsamında ertelendi. Uçak servise alındı. Bir sonraki gerekli işlem 3 uçuş günü içinde.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -162,
            category: QuestionCategory.vocabulary,
            originalNumber: 2031,
            questionText: '"Deferred in accordance with MEL" means:',
            options: ['the repair is cancelled permanently', 'the defect is postponed as permitted by the Minimum Equipment List', 'the aircraft is grounded', 'the defect was not found'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -163,
            category: QuestionCategory.vocabulary,
            originalNumber: 2032,
            questionText: 'Which phrase correctly closes a technical log entry?',
            options: ['Work is complete.', 'Aircraft released to service.', 'Defect fixed.', 'Done.'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -164,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2033,
            questionText: 'In a defect report: "Hydraulic fluid ………… from the main landing gear actuator seal."',
            options: ['dropped', 'leaked', 'spilled', 'came'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // AMT 6 — Work Order & Job Card Language
  // ═══════════════════════════════════════════════════════════
  // ── YENİ BEGINNER DERSLERİ ────────────────────────────────
  // ═══════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────
  // NATO Phonetic Alphabet & Numbers
  // ─────────────────────────────────────────────────────────────
  static const _natoAlphabet = LessonContent(
    id: 'grammar_8',
    title: 'NATO Fonetik Alfabesi ve Sayılar',
    subtitle: 'Telsiz haberleşmesinde harf ve rakam telaffuzu',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '🔤',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Neden fonetik alfabe kullanılır?',
        body:
            'Havacılık telsiz haberleşmesinde benzer seslerin karıştırılmaması kritiktir. "B" ve "D", "M" ve "N" gibi harfler gürültülü bir ortamda kolayca karışabilir.\n\nNATO fonetik alfabesi, her harfe özgün bir kelime atayarak bu sorunu çözer. ICAO tarafından standartlaştırılmıştır ve tüm havacılar tarafından kullanılır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔤 NATO Fonetik Alfabe',
        body:
            '**A** Alpha  **B** Bravo  **C** Charlie  **D** Delta  **E** Echo\n**F** Foxtrot  **G** Golf  **H** Hotel  **I** India  **J** Juliett\n**K** Kilo  **L** Lima  **M** Mike  **N** November  **O** Oscar\n**P** Papa  **Q** Quebec  **R** Romeo  **S** Sierra  **T** Tango\n**U** Uniform  **V** Victor  **W** Whiskey  **X** X-ray  **Y** Yankee  **Z** Zulu\n\n**Sayı telaffuzu (ICAO):**\n0 → ZE-RO  1 → WUN  2 → TOO  3 → TREE\n4 → FOW-ER  5 → FIFE  6 → SIX  7 → SEV-EN\n8 → AIT  9 → NIN-ER\n\n**Uçuş kodu örneği:** THY 234 → "Turkish TOO TREE FOW-ER"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Gerçek ATC Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"Squawk 4732" → "Squawk FOW-ER SEV-EN TREE TOO"',
            highlight: 'FOW-ER SEV-EN TREE TOO',
            translation: 'Transponder kodu 4732\'yi gir.',
          ),
          ExampleSentence(
            sentence: '"Taxi to runway 27L via Alpha Bravo" → taksirut A-B üzerinden pist 27L\'ye',
            highlight: 'Alpha Bravo',
            translation: 'Alpha = A taksiyolu, Bravo = B taksiyolu',
          ),
          ExampleSentence(
            sentence: '"Flight level WUN FIFE ZE-RO" = FL150',
            highlight: 'WUN FIFE ZE-RO',
            translation: 'Uçuş seviyesi 150',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Sorularda fonetik alfabe genellikle **taksiyolu tanımlamalarında** geçer ("taxi via Alpha, hold short of Charlie"). Harf karşılıklarını ezberlemek yerine bağlamdan çıkarmayı dene.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -200,
            category: QuestionCategory.vocabulary,
            originalNumber: 2100,
            questionText: 'In aviation radio communication, the letter "N" is spoken as:',
            options: ['Nancy', 'November', 'Norway', 'Neutral'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -201,
            category: QuestionCategory.vocabulary,
            originalNumber: 2101,
            questionText: 'The ICAO standard pronunciation of the number "9" is:',
            options: ['Nine', 'Niner', 'Nin-er', 'NIN-ER'],
            correctIndex: 3,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -202,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2102,
            questionText: '"Taxi to runway 18 via ………… " — the taxiway letter C is spoken as:',
            options: ['Cobra', 'Charlie', 'Cedar', 'Corona'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -203,
            category: QuestionCategory.vocabulary,
            originalNumber: 2103,
            questionText: 'Flight level 350 is read over the radio as:',
            options: ['Three Five Zero', 'TREE FIFE ZE-RO', 'Three-five-oh', 'Thirty-five zero'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // Basic ATC Instructions
  // ─────────────────────────────────────────────────────────────
  static const _basicAtcInstructions = LessonContent(
    id: 'vocab_8',
    title: 'Temel ATC Talimatları',
    subtitle: 'Climb, descend, maintain, turn — temel kontrol kelimeleri',
    categoryId: 'vocabulary',
    estimatedTime: '9 dk',
    emoji: '📻',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'ATC talimatlarının yapısı',
        body:
            'ATC (Air Traffic Control) talimatları kısa, net ve standart fiillerle verilir. Pilotlar bu talimatları tam olarak "readback" (geri okuma) yapmalıdır. Yanlış anlama veya eksik readback, uçuş emniyetini doğrudan tehdit eder.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Temel ATC Fiilleri ve Kullanımları',
        body:
            '**Yükseklik:**\n• **Climb to / Climb and maintain** → tırman / tırmanarak koru\n• **Descend to / Descend and maintain** → alçal / alçalarak koru\n• **Maintain** → koru (yükseklik/hız)\n• **Level off at** → seviyeye gel\n\n**Yön:**\n• **Turn left/right heading** → sola/sağa belirtilen yöne dön\n• **Fly heading** → yön uç\n• **Continue present heading** → mevcut yönde devam et\n• **Track** → rotayı takip et\n\n**Hız:**\n• **Reduce speed to** → hızı azalt\n• **Increase speed to** → hızı artır\n• **Resume normal speed** → normal hıza dön\n\n**Genel:**\n• **Cleared** → onaylandı / izin verildi\n• **Report** → bildir\n• **Proceed** → devam et / ilerle\n• **Hold** → bekle / tur at',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'ATC İletişim Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"Turkish 234, climb and maintain flight level 350."',
            highlight: 'climb and maintain',
            translation: 'Turkish 234, tırmanarak FL350\'yi koru.',
          ),
          ExampleSentence(
            sentence: '"Speedbird 47, turn right heading 090, descend to 3000 feet."',
            highlight: 'turn right heading … descend to',
            translation: 'Speedbird 47, sağa 090 yönüne dön, 3000 fite alçal.',
          ),
          ExampleSentence(
            sentence: '"Emirates 001, reduce speed to 250 knots, report passing FL200."',
            highlight: 'reduce speed … report passing',
            translation: 'Emirates 001, hızı 250 knota düşür, FL200\'ü geçerken bildir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -204,
            category: QuestionCategory.vocabulary,
            originalNumber: 2104,
            questionText: '"Climb and maintain flight level 280" means the pilot should:',
            options: [
              'climb to FL280 then stop climbing',
              'climb to and hold FL280',
              'maintain current level until FL280',
              'descend to FL280',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -205,
            category: QuestionCategory.vocabulary,
            originalNumber: 2105,
            questionText: 'The instruction "report passing 5000 feet" means:',
            options: [
              'stop at 5000 feet',
              'inform ATC when the aircraft reaches 5000 feet',
              'maintain 5000 feet',
              'turn at 5000 feet',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -206,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2106,
            questionText: '"……… speed to 180 knots" — the correct ATC word to complete this instruction is:',
            options: ['Drop', 'Slow', 'Reduce', 'Lower'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -207,
            category: QuestionCategory.vocabulary,
            originalNumber: 2107,
            questionText: 'When ATC says "proceed direct to the VOR", it means:',
            options: [
              'hold at the VOR',
              'fly directly to the VOR without following airways',
              'descend to the VOR',
              'report at the VOR',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // Runway & Taxiway Vocabulary
  // ─────────────────────────────────────────────────────────────
  static const _runwayTaxiway = LessonContent(
    id: 'vocab_9',
    title: 'Pist ve Taksiyolu Terminolojisi',
    subtitle: 'Hold short, line up, backtrack, vacate',
    categoryId: 'vocabulary',
    estimatedTime: '8 dk',
    emoji: '🛬',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Yer hareketi neden kritiktir?',
        body:
            'Havalimanı yer hareketi, uçuş emniyeti açısından en riskli fazlardan biridir. Pist ihlalleri (runway incursions) dünya genelinde ciddi kazalara neden olmaktadır. Bu nedenle yer hareketiyle ilgili talimatların tam olarak anlaşılması hayati önem taşır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛬 Temel Yer Hareketi Talimatları',
        body:
            '**Piste giriş/çıkış:**\n• **Line up** (UK) / **Position** (US) → piste gir ve kalk pozisyonuna geç\n• **Line up and wait** → piste gir, bekle (hâlâ kalkış onayı yok)\n• **Cleared for take-off** → kalkış onaylandı\n• **Vacate** → pisti terk et (inis sonrası)\n• **Backtrack** → pist üzerinde geri git\n\n**Taksiyolu talimatları:**\n• **Taxi to** → taksilen git\n• **Hold short of runway XX** → XX pistinin kenarında dur (piste girme)\n• **Hold position** → olduğun yerde dur\n• **Give way to** → yol ver\n• **Cross runway XX** → XX pistini geç\n\n**Dikkat edilecekler:**\n• "Hold short of runway" → **piste girilmez**, onay beklenir\n• Tüm pist talimatları readback yapılmalıdır',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Yer Hareketi Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"Turkish 101, taxi to holding point runway 35L via taxiway Alpha, hold short of runway 35L."',
            highlight: 'hold short of runway 35L',
            translation: 'Turkish 101, A taksiyolu üzerinden pist 35L bekleme noktasına taksile. Pist 35L\'de dur.',
          ),
          ExampleSentence(
            sentence: '"Lufthansa 453, line up and wait runway 28R."',
            highlight: 'line up and wait',
            translation: 'Lufthansa 453, pist 28R\'ye girin ve bekleyin (kalkış onayı bekleniyor).',
          ),
          ExampleSentence(
            sentence: '"Ryanair 7865, vacate runway left, contact ground 121.9."',
            highlight: 'vacate runway left',
            translation: 'Ryanair 7865, pisti soldan terk edin, 121.9\'da yer kontrolü ile temas kurun.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -208,
            category: QuestionCategory.vocabulary,
            originalNumber: 2108,
            questionText: '"Hold short of runway 09" means the pilot must:',
            options: [
              'stop on runway 09',
              'cross runway 09 quickly',
              'stop before entering runway 09',
              'maintain speed on runway 09',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -209,
            category: QuestionCategory.vocabulary,
            originalNumber: 2109,
            questionText: '"Line up and wait" instructs the pilot to:',
            options: [
              'take off immediately',
              'enter the runway and wait for take-off clearance',
              'hold short of the runway',
              'taxi to the apron',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -210,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2110,
            questionText: 'After landing, ATC instructs: "………… the runway at the first available exit."',
            options: ['Exit', 'Leave', 'Vacate', 'Escape'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -211,
            category: QuestionCategory.vocabulary,
            originalNumber: 2111,
            questionText: '"Backtrack runway 36" means:',
            options: [
              'turn around and taxi back along runway 36',
              'land on runway 36',
              'take off from runway 36',
              'hold short of runway 36',
            ],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ═══════════════════════════════════════════════════════════
  // ── YENİ ELEMENTARY DERSLERİ ──────────────────────────────
  // ═══════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────
  // Position Reports
  // ─────────────────────────────────────────────────────────────
  static const _positionReports = LessonContent(
    id: 'grammar_9',
    title: 'Pozisyon Raporları',
    subtitle: 'Standart pozisyon raporu formatı ve ifadeleri',
    categoryId: 'grammar',
    estimatedTime: '9 dk',
    emoji: '📍',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Pozisyon raporu nedir?',
        body:
            'Radar kapsamı olmayan sahalarda (okyanuslar, uzak bölgeler) pilotlar ATC\'ye konumlarını ses veya veri bağlantısı üzerinden iletirler. Bu "pozisyon raporu" hem emniyet hem de trafik yönetimi açısından kritiktir.\n\nStandart format sayesinde ATC dünya genelinde aynı şekilde yorumlayabilir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Standart Pozisyon Raporu Formatı',
        body:
            '**ICAO standart sırası:**\n1. **Aircraft identification** — uçak kimliği\n2. **Position** — mevcut nokta/fix\n3. **Time** — geçiş zamanı (UTC)\n4. **Flight level / altitude** — yükseklik\n5. **Next position** — sonraki nokta\n6. **Estimated time** — tahmini geçiş zamanı\n7. **Ensuing significant point** (isteğe bağlı) — sonraki önemli nokta\n\n**Yaygın ifadeler:**\n• "Over [fix]" → [nokta] üzerindeyiz\n• "Estimating [fix] at [time]" → [noktayı] [zamanda] tahmin ediyoruz\n• "Abeam [fix]" → [noktanın] hizasındayız\n• "Passing [altitude]" → [yüksekliği] geçiyoruz',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Pozisyon Raporu Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"Shanwick, Turkish 5, position MIMKU at 1423, flight level 350, estimating DOLIR at 1456."',
            highlight: 'position … at … estimating … at',
            translation: 'Shanwick, Turkish 5, 14:23\'te MIMKU konumundayız, FL350, DOLIR\'i 14:56\'da tahmin ediyoruz.',
          ),
          ExampleSentence(
            sentence: '"Passing flight level 230, climbing to flight level 350."',
            highlight: 'Passing … climbing to',
            translation: 'FL230\'u geçiyoruz, FL350\'ye tırmanıyoruz.',
          ),
          ExampleSentence(
            sentence: '"Estimating top of climb at 1430 UTC."',
            highlight: 'Estimating top of climb',
            translation: 'Tırmanma tepesini 14:30 UTC\'de tahmin ediyoruz.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -212,
            category: QuestionCategory.grammar,
            originalNumber: 2112,
            questionText: 'In a position report, "estimating ALPHA at 1540" means:',
            options: [
              'the aircraft is currently at fix ALPHA',
              'the aircraft expects to reach fix ALPHA at 1540',
              'the aircraft passed ALPHA at 1540',
              'the aircraft will climb at ALPHA',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -213,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2113,
            questionText: '"Position ROMEO ………… 1320, flight level 390" — which word correctly fills the blank?',
            options: ['over', 'at', 'in', 'by'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -214,
            category: QuestionCategory.vocabulary,
            originalNumber: 2114,
            questionText: '"Abeam BRAVO" in a position report means:',
            options: [
              'directly over fix BRAVO',
              'at the same latitude as fix BRAVO but off course',
              'approaching fix BRAVO',
              'past fix BRAVO',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -215,
            category: QuestionCategory.grammar,
            originalNumber: 2115,
            questionText: 'What is the correct order in a standard ICAO position report?',
            options: [
              'Position → Aircraft ID → FL → Time → Next fix',
              'Aircraft ID → Position → Time → FL → Next fix',
              'Time → Aircraft ID → FL → Position → Next fix',
              'Aircraft ID → FL → Position → Time → Next fix',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // Weather Phenomena in English
  // ─────────────────────────────────────────────────────────────
  static const _weatherPhenomena = LessonContent(
    id: 'vocab_10',
    title: 'Hava Durumu Fenomenleri',
    subtitle: 'VFR, IFR, turbulans ve hava koşulları İngilizcesi',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '🌦️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Neden hava vokabüleri önemlidir?',
        body:
            'Hava koşulları ATC iletişiminin, METAR/TAF okumalarının ve PIREP\'lerin temelini oluşturur. Yanlış yorumlama, yanlış karar almaya yol açar. Bu ders hem ATC hem de sınav İngilizcesi için temel kelimeleri kapsar.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🌦️ Temel Hava Fenomeni Kelimeleri',
        body:
            '**Görüş ve uçuş kuralları:**\n• **VFR** (Visual Flight Rules) → görsel uçuş kuralları\n• **IFR** (Instrument Flight Rules) → aletli uçuş kuralları\n• **IMC** (Instrument Meteorological Conditions) → aletli met koşulları\n• **VMC** (Visual Meteorological Conditions) → görsel met koşulları\n• **CAVOK** → görüş, bulut ve diğer koşullar uygun\n\n**Türbülans:**\n• **Light turbulence** → hafif türbülans\n• **Moderate turbulence** → orta turbülans\n• **Severe turbulence** → şiddetli türbülans\n• **Clear air turbulence (CAT)** → net hava türbülansı\n\n**Diğer fenomenler:**\n• **Wind shear** → rüzgar kayması\n• **Icing** → buz tutma / buzlanma\n• **Cumulonimbus (CB)** → kümülonimbüs bulutları\n• **Thunderstorm (TS)** → gök gürültülü fırtına\n• **Precipitation** → yağış (rain/snow/hail)\n• **Fog** → sis  **Mist** → pus  **Haze** → sis perdesi',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Hava Bildirim Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"Pilot reported moderate turbulence and light icing between FL180 and FL220."',
            highlight: 'moderate turbulence … light icing',
            translation: 'Pilot FL180-FL220 arası orta türbülans ve hafif buzlanma bildirdi.',
          ),
          ExampleSentence(
            sentence: '"Expect IMC conditions on approach due to low ceilings and reduced visibility in fog."',
            highlight: 'IMC conditions … low ceilings … visibility in fog',
            translation: 'Düşük tavan ve sis nedeniyle yaklaşmada IMC koşulları bekleyin.',
          ),
          ExampleSentence(
            sentence: '"Severe wind shear reported on final approach 3 nautical miles from threshold."',
            highlight: 'Severe wind shear … final approach',
            translation: 'Son yaklaşmada eşikten 3 deniz mili uzakta şiddetli rüzgar kayması bildirildi.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -216,
            category: QuestionCategory.vocabulary,
            originalNumber: 2116,
            questionText: '"CAVOK" in a METAR means:',
            options: [
              'ceiling and visibility are below minima',
              'cloud and visibility OK — no significant weather, visibility ≥10 km, no cloud below 5000 ft',
              'crosswind above limits',
              'caution: variable winds and overcast',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -217,
            category: QuestionCategory.vocabulary,
            originalNumber: 2117,
            questionText: '"CAT" in aviation weather reports stands for:',
            options: ['category', 'clear air turbulence', 'cloud and temperature', 'ceiling altitude threshold'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -218,
            category: QuestionCategory.vocabulary,
            originalNumber: 2118,
            questionText: 'IMC conditions require pilots to fly:',
            options: ['VFR', 'under IFR', 'without ATC clearance', 'at low altitude only'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -219,
            category: QuestionCategory.translation,
            originalNumber: 2119,
            questionText: '"Rüzgar kayması" is best translated as:',
            options: ['wind chill', 'wind shear', 'wind shift', 'wind gust'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // Holding Pattern Language
  // ─────────────────────────────────────────────────────────────
  static const _holdingPatterns = LessonContent(
    id: 'fill_6',
    title: 'Bekleme Tur Talimatları',
    subtitle: 'Hold instructions, EAT ve bekleme prosedürleri',
    categoryId: 'fill_blanks',
    estimatedTime: '9 dk',
    emoji: '⭕',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Bekleme turu neden önemlidir?',
        body:
            'ATC trafiği düzenlemek veya hava koşullarının iyileşmesini beklemek için uçakları "hold" (bekleme turu) komutuyla belirli bir bölgede uçurmaktadır. Hold talimatı birden fazla kritik bilgi içerir ve pilot bunların hepsini doğru anlamalıdır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⭕ Hold Talimati Bileşenleri',
        body:
            '**Standart hold talimatı şunları içerir:**\n• **Fix** → bekleme noktası (VOR, waypoint)\n• **Radial / course** → gelen yön\n• **Direction** → "right-hand turns" / "left-hand turns"\n• **Leg length** → tur uzunluğu (NM veya dakika)\n• **Altitude** → bekleme yüksekliği\n• **EAT** (Expected Approach Time) → beklenen yaklaşma zamanı\n\n**Yaygın ifadeler:**\n• "Hold over [fix]" → [noktada] bekleme turu yap\n• "Hold as published" → haritalardaki standartta tür\n• "Expect further clearance at [time]" → [zamanda] izin bekleniyor\n• "Expect approach at [time]" → [zamanda] yaklaşma bekleniyor\n• "Due to traffic/weather" → trafik/hava nedeniyle',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Hold Talimatı Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"Turkish 234, hold over ROMEO VOR on the 270 radial, right-hand turns, 10 mile legs, maintain flight level 110, expect approach at 1520."',
            highlight: 'hold over … radial … right-hand turns … expect approach at',
            translation: 'Turkish 234, ROMEO VOR\'un 270 radyali üzerinde sağ dönüşlerle 10 mil bacaklı bekleme turu yap, FL110\'u koru, yaklaşmayı 15:20\'de bekle.',
          ),
          ExampleSentence(
            sentence: '"Hold as published, expect further clearance at 1445."',
            highlight: 'Hold as published … expect further clearance',
            translation: 'Yayımlanan şekilde bekleme turu yap, 14:45\'te ek izin bekleniyor.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -220,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2120,
            questionText: '"Hold ………… LIMA, right-hand turns, maintain 7000 feet." — which word correctly fills the blank?',
            options: ['at', 'on', 'over', 'near'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -221,
            category: QuestionCategory.vocabulary,
            originalNumber: 2121,
            questionText: '"EAT" in a holding clearance stands for:',
            options: [
              'Estimated Arrival Time',
              'Expected Approach Time',
              'Emergency Alert Time',
              'En-route Average Time',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -222,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2122,
            questionText: '"Expect ………… clearance at 1530" — what is the missing word in a standard hold instruction?',
            options: ['arrival', 'further', 'final', 'approach'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -223,
            category: QuestionCategory.vocabulary,
            originalNumber: 2123,
            questionText: '"Hold as published" means:',
            options: [
              'hold as ATC instructs verbally',
              'hold according to the procedure shown on the chart',
              'hold at the published minimum altitude',
              'hold until published weather minima are met',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // Squawk & Transponder
  // ─────────────────────────────────────────────────────────────
  static const _squawkTransponder = LessonContent(
    id: 'translation_5',
    title: 'Transponder ve Squawk Dili',
    subtitle: 'Squawk kodları, IDENT ve Türkçe karşılıkları',
    categoryId: 'translation',
    estimatedTime: '8 dk',
    emoji: '📡',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Transponder neden önemlidir?',
        body:
            'Transponder, uçağın radar ekranında ATC tarafından tanınmasını sağlar. ATC her uçağa özgü bir "squawk" (transponder kodu) verir. Doğru kodu girmek ve ATC talimatlarını anlamak trafiğin güvenli yönetimi için zorunludur.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📡 Transponder Komutları ve Modları',
        body:
            '**Squawk komutları:**\n• **"Squawk [code]"** → transponderı [kod] numarasına ayarla\n• **"Squawk ident"** → tanımlama butonuna bas (ATC ekranda seni parlak görür)\n• **"Squawk standby"** → transponderı beklemede bırak\n• **"Squawk altitude"** → Mode C\'yi etkinleştir (irtifa bilgisi)\n• **"Confirm squawk"** → kodu doğrula\n\n**Acil durum kodları:**\n• **7700** → genel acil durum (emergency)\n• **7600** → telsiz arızası (radio failure)\n• **7500** → kaçırılma (hijack)\n\n**Türkçe çeviriler:**\n• Squawk → transponder kodu\n• Ident → tanımlama / kimlik bildirimi\n• Mode C → barometrik irtifa modu\n• Transponder → transponder / ikincil gözetleme radarı cevaplayıcı',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Squawk İletişim Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"Turkish 5, squawk 2347, squawk altitude."',
            highlight: 'squawk 2347 … squawk altitude',
            translation: 'Turkish 5, transponder kodunu 2347 yap, Mode C\'yi etkinleştir.',
          ),
          ExampleSentence(
            sentence: '"Speedbird 44, confirm squawk." — "Squawk confirmed 4153, Speedbird 44."',
            highlight: 'confirm squawk … Squawk confirmed',
            translation: 'Speedbird 44, kodu doğrula. — Kod 4153 doğrulandı, Speedbird 44.',
          ),
          ExampleSentence(
            sentence: '"Identified. Squawk ident." — aircraft presses IDENT button.',
            highlight: 'Squawk ident … Identified',
            translation: 'Tanımlama yap. — Pilot tanımlama butonuna basar. ATC görür.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -224,
            category: QuestionCategory.translation,
            originalNumber: 2124,
            questionText: '"Squawk 7700" is the transponder code for:',
            options: ['radio failure', 'general emergency', 'hijack', 'VFR flight'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -225,
            category: QuestionCategory.translation,
            originalNumber: 2125,
            questionText: '"Squawk ident" means the pilot should:',
            options: [
              'enter a new squawk code',
              'turn off the transponder',
              'press the IDENT button on the transponder',
              'confirm the squawk code verbally',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -226,
            category: QuestionCategory.translation,
            originalNumber: 2126,
            questionText: 'The phrase "squawk altitude" instructs the crew to:',
            options: [
              'report their altitude verbally',
              'climb to the assigned altitude',
              'activate Mode C to transmit pressure altitude',
              'set the altimeter to QNH',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -227,
            category: QuestionCategory.translation,
            originalNumber: 2127,
            questionText: 'A pilot experiencing a radio failure should squawk:',
            options: ['7500', '7600', '7700', '2000'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ═══════════════════════════════════════════════════════════
  // ── YENİ INTERMEDIATE DERSLERİ ────────────────────────────
  // ═══════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────
  // Full IFR Clearance Language
  // ─────────────────────────────────────────────────────────────
  static const _ifrClearance = LessonContent(
    id: 'reading_7',
    title: 'IFR Tahliye (Clearance) Okuma',
    subtitle: 'Tam IFR clearance mesajını anlama ve readback',
    categoryId: 'reading',
    estimatedTime: '11 dk',
    emoji: '📋',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'IFR clearance neden okunur?',
        body:
            'IFR (Instrument Flight Rules) uçuşlar için ATC, kalkıştan önce kapsamlı bir "clearance" mesajı verir. Bu mesaj, uçağın tüm rota bilgisini, kısıtlamaları ve prosedürleri içerir.\n\nPilotun clearance\'ı tam ve doğru şekilde "readback" (geri okuması) zorunludur — hata varsa ATC düzeltir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 CRAFT Formatı',
        body:
            'IFR clearance\'ı hatırlamak için **CRAFT** kısaltması kullanılır:\n\n**C** → **Clearance limit** (hedef havalimanı veya fix)\n**R** → **Route** (rota — SID + airways + STAR)\n**A** → **Altitude** (başlangıç yüksekliği / FL)\n**F** → **Frequency** (ilk frekans)\n**T** → **Transponder code** (squawk)\n\n**Yaygın ifadeler:**\n• "Cleared to [destination] via [route]" → rotayı ver\n• "Climb via SID" → SID ile tırman (irtifa kısıtlamaları dahil)\n• "Expect [FL] ten minutes after departure" → kalkıştan 10 dk sonra [FL] bekle\n• "Departure frequency [xxx.x]" → kalkış frekansı\n• "Readback correct" → geri okuma doğru',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnek IFR Clearance',
        examples: [
          ExampleSentence(
            sentence: '"Turkish 234, cleared to London Heathrow via KEMAL3A departure, then airways L602, Upper Blue 2, expect flight level 370 ten minutes after departure, departure frequency 119.1, squawk 2374."',
            highlight: 'cleared to … via … expect … departure frequency … squawk',
            translation: 'C=Heathrow, R=KEMAL3A+L602+UB2, A=başlangıç SID, bekle FL370, F=119.1, T=2374',
          ),
          ExampleSentence(
            sentence: '"Readback correct. Contact tower 118.3 when ready."',
            highlight: 'Readback correct',
            translation: 'Geri okuma doğru. Hazır olduğunuzda 118.3\'te kule ile temas kurun.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -228,
            category: QuestionCategory.reading,
            originalNumber: 2128,
            questionText: 'In the CRAFT format, what does "A" stand for?',
            options: ['Airways', 'Altitude', 'Approach', 'Airspeed'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -229,
            category: QuestionCategory.reading,
            originalNumber: 2129,
            questionText: '"Cleared to Frankfurt via KEMAL3A departure" — what is the clearance limit?',
            options: ['KEMAL3A', 'the departure runway', 'Frankfurt', 'the SID endpoint'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -230,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2130,
            questionText: '"………… flight level 350 ten minutes after departure" — which phrase correctly completes this IFR clearance element?',
            options: ['Maintain', 'Reach', 'Expect', 'Request'],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -231,
            category: QuestionCategory.reading,
            originalNumber: 2131,
            questionText: '"Readback correct" from ATC means:',
            options: [
              'the pilot should read back the clearance again',
              'the pilot\'s readback matched the clearance — no corrections needed',
              'the clearance has been amended',
              'the pilot should contact the next sector',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // Emergency Phraseology
  // ─────────────────────────────────────────────────────────────
  static const _emergencyPhraseology = LessonContent(
    id: 'vocab_11',
    title: 'Acil Durum Terimleri',
    subtitle: 'MAYDAY, PAN-PAN ve standart acil durum ifadeleri',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '🆘',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Acil durum terimleri neden kritiktir?',
        body:
            'Acil durumlarda doğru terminolojiyi bilmek hayat kurtarır. Pilot stres altında olsa bile standart ifadeler, ATC\'nin anında doğru prosedürü başlatmasını sağlar. ICAO, acil durum iletişimi için net bir hiyerarşi belirlemiştir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🆘 Acil Durum Hiyerarşisi',
        body:
            '**MAYDAY** (3 kez tekrar) → tehlike durumu (distress)\n• Can veya uçak tehlikede, acil yardım gerekiyor\n• "MAYDAY MAYDAY MAYDAY, [çağrı işareti], [pozisyon], [problem], [niyet], [can sayısı]"\n\n**PAN-PAN** (3 kez tekrar) → aciliyet durumu (urgency)\n• Tehlike yakın değil ama acil yardım veya öncelik gerekiyor\n• Format MAYDAY ile aynı\n\n**SECURITE** (3 kez tekrar) → emniyet mesajı\n• Navigasyon tehlikesi veya önemli meteoroloji uyarısı\n\n**Yaygın acil ifadeler:**\n• "Declaring emergency" → acil ilan ediyorum\n• "Minimum fuel" → minimum yakıt (çıkmıyor ama öncelik ister)\n• "Fuel emergency" → yakıt acil (can tehlikesi sınırı)\n• "Engine failure/fire/smoke in cabin"\n• "Returning to departure airport"\n• "Request immediate landing"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Acil Durum İletişim Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"MAYDAY MAYDAY MAYDAY, Turkish 234, 40 miles north of Istanbul, engine fire, descending to 10,000 feet, request immediate return, 189 souls on board."',
            highlight: 'MAYDAY … engine fire … request immediate return … souls on board',
            translation: 'Tam format: çağrı × 3 → uçak ID → pozisyon → problem → niyet → can.',
          ),
          ExampleSentence(
            sentence: '"PAN-PAN PAN-PAN PAN-PAN, Lufthansa 55, medical emergency on board, request priority landing, 2 crew 180 passengers."',
            highlight: 'PAN-PAN … medical emergency … priority landing',
            translation: 'Can tehlikesi yok ama tıbbi acil nedeniyle öncelikli iniş talep ediliyor.',
          ),
          ExampleSentence(
            sentence: '"Declaring minimum fuel, request direct routing to reduce flight time."',
            highlight: 'minimum fuel … direct routing',
            translation: 'Minimum yakıt bildirimi — acil değil ama öncelik istiyor.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -232,
            category: QuestionCategory.vocabulary,
            originalNumber: 2132,
            questionText: '"MAYDAY" is declared when:',
            options: [
              'there is a minor technical fault',
              'the aircraft or persons on board are in grave and imminent danger',
              'fuel is below normal reserves',
              'a medical passenger needs assistance',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -233,
            category: QuestionCategory.vocabulary,
            originalNumber: 2133,
            questionText: '"PAN-PAN" compared to "MAYDAY" indicates:',
            options: [
              'a more serious emergency',
              'an urgency condition — serious but not immediately life-threatening',
              'a routine maintenance issue',
              'a navigation warning for other aircraft',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -234,
            category: QuestionCategory.vocabulary,
            originalNumber: 2134,
            questionText: '"Minimum fuel" declaration means:',
            options: [
              'the aircraft has declared a fuel emergency',
              'the pilot informs ATC that fuel state requires priority handling but is not an emergency yet',
              'the aircraft must land immediately',
              'the aircraft cannot accept a hold',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -235,
            category: QuestionCategory.vocabulary,
            originalNumber: 2135,
            questionText: '"Souls on board" in an emergency call refers to:',
            options: [
              'only passengers',
              'only crew members',
              'total number of persons (crew + passengers)',
              'number of survivors',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // Conditional Structures in Emergencies
  // ─────────────────────────────────────────────────────────────
  static const _conditionalEmergency = LessonContent(
    id: 'grammar_10',
    title: 'Koşul Yapıları: Acil Senaryolar',
    subtitle: 'If/unless/provided that — karar ifadeleri',
    categoryId: 'grammar',
    estimatedTime: '10 dk',
    emoji: '⚡',
    sections: [
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚡ Havacılıkta Koşul Yapıları',
        body:
            '**Tip 1 (Gerçek koşul):** "If + present, will/shall + infinitive"\n→ "If the engine fails, the crew will initiate the emergency procedure."\n\n**Tip 2 (Varsayımsal):** "If + past simple, would + infinitive"\n→ "If the fuel ran out, we would have to divert immediately."\n\n**Tip 3 (Geçmişe ait):** "If + past perfect, would have + past participle"\n→ "If the warning had been detected earlier, the crew would have diverted in time."\n\n**Unless** = "if … not" → "Unless ATC clears the runway, the aircraft cannot land."\n\n**Provided that / As long as** = koşul bağlayıcılar\n→ "The approach may continue provided that visibility exceeds 550 metres."\n\n**Havacılıktaki bağlam:**\nAcil durum kontrol listeleri, teknik dokümanlar ve ATC talimatları sıklıkla koşul yapısı kullanır.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Koşul Yapısı Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"If the fire warning activates, the crew shall discharge the extinguisher and land as soon as possible."',
            highlight: 'If … activates … shall',
            translation: 'Yangın uyarısı etkinleşirse, mürettebat söndürücüyü devreye almalı ve mümkün olan en kısa sürede inmeli.',
          ),
          ExampleSentence(
            sentence: '"Unless the hydraulic pressure is restored, gear extension will be performed manually."',
            highlight: 'Unless … is restored … will be performed',
            translation: 'Hidrolik basınç geri gelmezse, iniş takımı manuel olarak indirilecek.',
          ),
          ExampleSentence(
            sentence: '"The landing may be continued provided that the reported RVR is not less than 550 metres."',
            highlight: 'provided that … is not less than',
            translation: 'Bildirilen RVR 550 metreden az olmadığı sürece iniş sürdürülebilir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -236,
            category: QuestionCategory.grammar,
            originalNumber: 2136,
            questionText: '"………… the engine fails, the crew will initiate the emergency checklist." — which word correctly fills the blank?',
            options: ['Although', 'Unless', 'If', 'Because'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -237,
            category: QuestionCategory.grammar,
            originalNumber: 2137,
            questionText: '"………… the runway is clear, the aircraft cannot land." — the missing word is:',
            options: ['If', 'Unless', 'Until', 'Because'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -238,
            category: QuestionCategory.grammar,
            originalNumber: 2138,
            questionText: '"The approach may be continued ………… visibility exceeds the minimum." — which phrase fits?',
            options: ['so that', 'provided that', 'even if', 'although'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -239,
            category: QuestionCategory.grammar,
            originalNumber: 2139,
            questionText: '"If the warning had activated earlier, the crew ………… diverted in time." — correct completion:',
            options: ['would divert', 'will have diverted', 'would have diverted', 'had diverted'],
            correctIndex: 2,
            difficulty: Difficulty.hard,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // ATIS Decoding (Intermediate)
  // ─────────────────────────────────────────────────────────────
  static const _atisDecoding = LessonContent(
    id: 'translation_6',
    title: 'ATIS Çözümleme',
    subtitle: 'Tam ATIS yayınını anlama ve çevirme',
    categoryId: 'translation',
    estimatedTime: '11 dk',
    emoji: '📻',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'ATIS nedir?',
        body:
            'ATIS (Automatic Terminal Information Service), havalimanı bilgilerini otomatik olarak yayınlayan ses sistemidir. Pilotlar ilk temas öncesinde ATIS\'i alarak havalimanının güncel bilgilerini öğrenirler.\n\nHer güncellenen ATIS\'e bir harf verilir (Alpha, Bravo... Zulu). Pilot ATC\'ye "information Charlie" gibi hangi ATIS\'i aldığını belirtir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📻 ATIS İçeriği ve Standart Format',
        body:
            '**Tipik ATIS içeriği (sırayla):**\n1. Airport name + ATIS designator (harf)\n2. Time of observation (UTC)\n3. Wind direction & speed\n4. Visibility\n5. Weather phenomena (rain, fog, etc.)\n6. Cloud cover & ceiling\n7. Temperature & dewpoint\n8. QNH (altimeter setting)\n9. Active runway(s)\n10. NOTAMs (gerekirse)\n11. ATIS designator tekrar ("this is information Charlie")\n\n**Kritik kelimeler:**\n• "Ceiling [X] feet broken/overcast" → bulut tavanı\n• "Visibility [X] metres/km" → görüş mesafesi\n• "Wind [dir] degrees [speed] knots gusting [X]" → rüzgar\n• "QNH [xxxx]" → basınç ayarı\n• "Expect ILS approach runway XX" → beklenen yaklaşma\n• "Caution: construction work / bird activity" → uyarı',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnek ATIS Yayını',
        examples: [
          ExampleSentence(
            sentence:
                '"Istanbul Ataturk information Delta, time 1400 UTC. Wind 220 degrees 12 knots. Visibility 6 kilometres, mist. Ceiling 1200 feet broken. Temperature 08, dewpoint 07. QNH 1012. Expect ILS approach runway 35L. Advise on first contact you have information Delta."',
            highlight: 'information Delta … Wind … Visibility … Ceiling … QNH … Expect ILS',
            translation:
                'Delta bilgisi: 220/12 rüzgar, 6 km görüş pus, 1200 ft kırık bulut, Sıcaklık 8/dp7, QNH 1012, ILS 35L yaklaşma bekleniyor.',
          ),
          ExampleSentence(
            sentence: 'Pilot response: "Turkish 5, information Delta received."',
            highlight: 'information Delta received',
            translation: 'Pilot ATIS\'i aldığını bildiriyor — ATC tekrar hava bilgisi vermez.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -240,
            category: QuestionCategory.translation,
            originalNumber: 2140,
            questionText: '"Ceiling 1500 feet broken" in an ATIS means:',
            options: [
              'cloud base at 1500 feet with 5-7 oktas coverage',
              'cloud base at 1500 feet with overcast (8 oktas)',
              'visibility is 1500 feet due to cloud',
              'fog ceiling at 1500 feet, land prohibited',
            ],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -241,
            category: QuestionCategory.translation,
            originalNumber: 2141,
            questionText: 'When a pilot says "information Bravo received", it means:',
            options: [
              'the pilot requests a new ATIS',
              'the pilot has listened to the ATIS designated Bravo',
              'the pilot confirms runway Bravo is available',
              'the pilot acknowledges a Bravo-level emergency',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -242,
            category: QuestionCategory.translation,
            originalNumber: 2142,
            questionText: 'In an ATIS, "QNH 1013" instructs pilots to:',
            options: [
              'set the altimeter to 1013 mb/hPa',
              'climb to 1013 feet',
              'expect landing at 1013 local time',
              'maintain 1013 ft above ground level',
            ],
            correctIndex: 0,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -243,
            category: QuestionCategory.translation,
            originalNumber: 2143,
            questionText: '"Wind 270 degrees 18 knots gusting 28" translates to:',
            options: [
              'rüzgar 270 derece 18 knot, ani artışlarla 28 knota çıkıyor',
              'rüzgar 270 derece 28 knot, minimum 18 knot',
              'rüzgar 270 derece 18 knot sabit',
              'rüzgar 270 derece 28 knot yavaşlayarak 18 knota düşüyor',
            ],
            correctIndex: 0,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ═══════════════════════════════════════════════════════════
  // ── YENİ ADVANCED DERSLERİ ────────────────────────────────
  // ═══════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────
  // Human Factors & CRM
  // ─────────────────────────────────────────────────────────────
  static const _humanFactorsCrm = LessonContent(
    id: 'reading_8',
    title: 'İnsan Faktörleri ve CRM Terimleri',
    subtitle: 'SHELL modeli, TEM, CRM İngilizcesi',
    categoryId: 'reading',
    estimatedTime: '12 dk',
    emoji: '🧠',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'CRM neden önemlidir?',
        body:
            'Havacılık kazalarının büyük çoğunluğu (yaklaşık %75) teknik arıza değil, **insan faktörü** kaynaklıdır. CRM (Crew Resource Management) eğitimi ve terminolojisi, ICAO ve EASA tarafından zorunlu tutulmakta; sınav sorularında da sıklıkla yer almaktadır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🧠 Temel CRM ve İnsan Faktörü Terimleri',
        body:
            '**SHELL Modeli bileşenleri:**\n• **S** — Software (prosedürler, kontrol listeleri)\n• **H** — Hardware (uçak, ekipman)\n• **E** — Environment (çevre koşulları)\n• **L** — Liveware (çekirdeği: insan/pilot)\n• İkinci **L** — Liveware (diğer insanlar: mürettebat, ATC)\n\n**TEM (Threat and Error Management):**\n• **Threat** — tehdit (dış kaynaklı risk)\n• **Error** — hata (insan kaynaklı)\n• **Undesired aircraft state** (UAS) — istenmeyen uçak durumu\n\n**CRM kavramları:**\n• **Situational awareness (SA)** → durum farkındalığı\n• **Workload management** → iş yükü yönetimi\n• **Assertiveness** → kendini ifade edebilme\n• **Crew coordination** → ekip koordinasyonu\n• **Briefing / Debriefing** → brifing / debrifing\n• **Sterile cockpit** → kritik fazda kokpitte sessizlik\n• **Go-around decision** → dalga geçme kararı',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'CRM Dili Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"Loss of situational awareness was identified as a contributing factor in the accident sequence."',
            highlight: 'Loss of situational awareness … contributing factor',
            translation: 'Durum farkındalığının kaybı, kaza seyrinde katkıda bulunan bir faktör olarak belirlendi.',
          ),
          ExampleSentence(
            sentence: '"The crew failed to complete the checklist due to high workload during the approach phase."',
            highlight: 'failed to complete the checklist … high workload',
            translation: 'Mürettebat, yaklaşma fazındaki yüksek iş yükü nedeniyle kontrol listesini tamamlayamadı.',
          ),
          ExampleSentence(
            sentence: '"Assertiveness training helps crew members speak up when they identify a threat."',
            highlight: 'Assertiveness … speak up … identify a threat',
            translation: 'Kendini ifade etme eğitimi, ekip üyelerinin bir tehdit fark ettiklerinde seslerini yükseltmelerine yardımcı olur.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -244,
            category: QuestionCategory.reading,
            originalNumber: 2144,
            questionText: 'In the SHELL model, the central "L" (Liveware) refers to:',
            options: ['aircraft systems', 'the pilot/human at the centre of the model', 'the regulatory environment', 'cockpit software'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -245,
            category: QuestionCategory.reading,
            originalNumber: 2145,
            questionText: '"Situational awareness" in CRM means:',
            options: [
              'awareness of weather conditions only',
              'accurate mental picture of all factors affecting the flight at a given moment',
              'awareness of company regulations',
              'monitoring fuel quantity continuously',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -246,
            category: QuestionCategory.vocabulary,
            originalNumber: 2146,
            questionText: '"Sterile cockpit" rule requires:',
            options: [
              'a medically sterile environment for flight crew',
              'no non-essential conversation during critical phases of flight',
              'all passengers remain silent during take-off',
              'automated checklist completion only',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -247,
            category: QuestionCategory.reading,
            originalNumber: 2147,
            questionText: 'In TEM, "UAS" stands for:',
            options: [
              'Unsafe Airspace System',
              'Undesired Aircraft State',
              'Unusual Approach Scenario',
              'Unexpected ATC Signal',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // Safety Management System Language
  // ─────────────────────────────────────────────────────────────
  static const _smsLanguage = LessonContent(
    id: 'vocab_12',
    title: 'Emniyet Yönetim Sistemi (SMS) Dili',
    subtitle: 'Risk, hazard, occurrence raporlama terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '11 dk',
    emoji: '🛡️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'SMS neden bilinmeli?',
        body:
            'ICAO, SMS (Safety Management System) uygulamasını zorunlu kılmaktadır. Tüm havacılık personeli SMS terminolojisini bilmeli; raporlama sistemlerine katkıda bulunmalıdır. Sınav sorularında da SMS kavramları giderek daha fazla yer almaktadır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛡️ Temel SMS Terimleri',
        body:
            '**Risk yönetimi:**\n• **Hazard** → tehlike kaynağı (risk oluşturabilecek durum/nesne)\n• **Risk** → tehlikenin gerçekleşme olasılığı × sonucunun şiddeti\n• **Severity** → şiddet (sonucun ciddiyeti)\n• **Likelihood / Probability** → olasılık\n• **Mitigation** → azaltma (riski düşürme önlemi)\n• **Residual risk** → kalan risk (önlem sonrası)\n\n**Raporlama:**\n• **Occurrence** → olay (kaza veya kaza öncesi durum)\n• **Incident** → ciddi olmayan olay\n• **Serious incident** → kaza sınırına yakın olay\n• **Accident** → kaza (hasar/yaralanma var)\n• **Near miss / AIRPROX** → ramak kala\n• **Mandatory occurrence report (MOR)** → zorunlu olay raporu\n• **Just culture** → suçlamadan öte, sistemi iyileştirmeye odaklı kültür',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'SMS Belgelerinden Örnekler',
        examples: [
          ExampleSentence(
            sentence: '"The hazard of bird strike was assessed with high severity and medium likelihood, resulting in a risk rating of HIGH."',
            highlight: 'hazard … severity … likelihood … risk rating',
            translation: 'Kuş çarpması tehlikesi yüksek şiddet ve orta olasılıkla değerlendirildi; risk derecesi YÜKSEK.',
          ),
          ExampleSentence(
            sentence: '"Pilots are encouraged to file occurrence reports under the just culture framework without fear of punitive action."',
            highlight: 'occurrence reports … just culture … without fear of punitive action',
            translation: 'Pilotlar cezalandırma korkusu olmadan adaletli kültür çerçevesinde olay raporları doldurmaya teşvik edilmektedir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -248,
            category: QuestionCategory.vocabulary,
            originalNumber: 2148,
            questionText: 'In SMS, a "hazard" is defined as:',
            options: [
              'a condition or object with the potential to cause injury or damage',
              'the probability that an event will occur',
              'a formal accident investigation report',
              'the residual risk after mitigation',
            ],
            correctIndex: 0,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -249,
            category: QuestionCategory.vocabulary,
            originalNumber: 2149,
            questionText: '"Residual risk" refers to:',
            options: [
              'the initial risk before any mitigation',
              'the risk remaining after safety measures have been applied',
              'risks that cannot be identified',
              'the most likely accident scenario',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -250,
            category: QuestionCategory.vocabulary,
            originalNumber: 2150,
            questionText: '"Just culture" in aviation SMS promotes:',
            options: [
              'anonymous reporting only',
              'punishing all errors to deter unsafe behaviour',
              'open reporting without fear, while distinguishing honest mistakes from negligence',
              'management accountability for all incidents',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -251,
            category: QuestionCategory.vocabulary,
            originalNumber: 2151,
            questionText: 'A "serious incident" in aviation is defined as one:',
            options: [
              'involving fatalities',
              'involving aircraft damage',
              'that nearly resulted in an accident',
              'reported to the regulator within 24 hours',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // EASA Regulatory Language
  // ─────────────────────────────────────────────────────────────
  static const _regulatoryLanguage = LessonContent(
    id: 'translation_7',
    title: 'Düzenleyici Kurum Dili',
    subtitle: 'EASA/ICAO mevzuat İngilizcesi: shall, must, may',
    categoryId: 'translation',
    estimatedTime: '12 dk',
    emoji: '⚖️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Yasal metin dili neden farklıdır?',
        body:
            'EASA yönetmelikleri, ICAO ekleri ve uçuş el kitapları belirli kalıp ifadeler kullanır. "Shall", "must", "may", "should" gibi modal fiiller farklı hukuki güce sahiptir. Bu farkı bilmek hem sınavda hem gerçek operasyonda kritiktir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚖️ Düzenleyici Dilde Modal Fiil Hiyerarşisi',
        body:
            '**SHALL** → zorunluluk (en güçlü bağlayıcı)\n→ "The operator shall ensure all crew hold valid licences."\n→ Türkçe: "… sağlamak zorundadır / mecburidir"\n\n**MUST** → zorunluluk (şart/gereklilik)\n→ "Pilots must complete recurrent training annually."\n→ Türkçe: "… zorunludur / yapmalıdır"\n\n**SHOULD** → tavsiye (zorunlu değil, beklenen)\n→ "Crews should conduct a threat and error briefing before departure."\n→ Türkçe: "… yapmalı (tavsiye edilir)"\n\n**MAY** → izin / olasılık\n→ "The commander may declare an emergency at his discretion."\n→ Türkçe: "… yapabilir / izinlidir"\n\n**IS REQUIRED TO** → zorunluluk (shall ile eşdeğer)\n**IS PERMITTED TO** → izin (may ile eşdeğer)\n**IS RECOMMENDED TO** → tavsiye (should ile eşdeğer)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'EASA/ICAO Metin Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"The commander shall satisfy himself that the aircraft is airworthy before commencing flight." (EASA ORO)',
            highlight: 'shall satisfy himself that … airworthy',
            translation: 'Komutan, uçuşa başlamadan önce uçağın uçuşa elverişli olduğundan emin olmak zorundadır.',
          ),
          ExampleSentence(
            sentence: '"Operators should implement fatigue risk management systems in accordance with Subpart FTL."',
            highlight: 'should implement … in accordance with',
            translation: 'İşleticilerin Subpart FTL\'ye uygun yorgunluk riski yönetim sistemi kurmaları tavsiye edilmektedir.',
          ),
          ExampleSentence(
            sentence: '"A commander may deviate from any rule to the extent necessary to meet an emergency situation." (ICAO Annex 2)',
            highlight: 'may deviate … to the extent necessary',
            translation: 'Komutan, acil durumla başa çıkmak için gerekli ölçüde herhangi bir kuraldan sapabilir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -252,
            category: QuestionCategory.translation,
            originalNumber: 2152,
            questionText: 'In EASA regulations, "shall" indicates:',
            options: [
              'a recommendation',
              'a permission',
              'a mandatory requirement',
              'a future possibility',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -253,
            category: QuestionCategory.translation,
            originalNumber: 2153,
            questionText: '"The pilot may request priority landing" — "may" here means:',
            options: [
              'the pilot is required to request priority',
              'the pilot is permitted to request priority',
              'the pilot should avoid requesting priority',
              'the pilot must always request priority',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -254,
            category: QuestionCategory.translation,
            originalNumber: 2154,
            questionText: '"Operators should implement a fatigue management system" — "should" means:',
            options: [
              'it is legally mandatory',
              'it is strictly prohibited',
              'it is recommended but not legally required',
              'it is optional based on operator preference',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -255,
            category: QuestionCategory.translation,
            originalNumber: 2155,
            questionText: 'Which modal verb carries the strongest legal obligation in ICAO and EASA documents?',
            options: ['may', 'should', 'shall', 'might'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // Accident Investigation Report Language
  // ─────────────────────────────────────────────────────────────
  static const _accidentInvestigation = LessonContent(
    id: 'reading_9',
    title: 'Kaza Soruşturma Raporu Dili',
    subtitle: 'NTSB/AAIB raporu okuma ve terim analizi',
    categoryId: 'reading',
    estimatedTime: '13 dk',
    emoji: '🔍',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Neden kaza raporu dili öğrenilmeli?',
        body:
            'Kaza soruşturma raporları (NTSB, AAIB, DGCA vb.) havacılık güvenliğinin temel belgelerindendir. Bu raporlar belirli bir dil kullanır: bulgular (findings), nedenler (causes), katkıda bulunan faktörler (contributing factors) ve güvenlik önerileri (safety recommendations).\n\nSınav soruları ve mesleki gelişim açısından bu dili anlamak kritiktir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔍 Kaza Raporu Terminolojisi',
        body:
            '**Temel terimler:**\n• **Probable cause** → olası neden (NTSB kullanır)\n• **Causal factor** → nedensel faktör\n• **Contributing factor** → katkıda bulunan faktör (doğrudan neden değil)\n• **Finding** → bulgu (soruşturmanın tespiti)\n• **Safety recommendation** → güvenlik önerisi\n• **Chain of events** → olaylar zinciri\n• **Accident sequence** → kaza sırası\n\n**Fiil kalıpları:**\n• "…was identified as contributing to…" → katkıda bulunan faktör olarak belirlendi\n• "…failed to…" → … yapmayı başaramadı\n• "…resulted in…" → … ile sonuçlandı\n• "…led to…" → … yol açtı\n• "…was a factor in…" → … bir etken oldu\n• "…in the absence of…" → … yokluğunda\n• "…exacerbated by…" → … tarafından ağırlaştırıldı',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Kaza Raporu Örnekleri',
        examples: [
          ExampleSentence(
            sentence: '"The probable cause of the accident was the flight crew\'s failure to maintain adequate airspeed during the approach, resulting in an aerodynamic stall."',
            highlight: 'probable cause … failure to maintain … resulting in',
            translation: 'Kazanın olası nedeni, uçuş mürettebatının yaklaşma sırasında yeterli hava hızını koruyamaması ve bunun sonucunda aerodinamik bir stola neden olmasıdır.',
          ),
          ExampleSentence(
            sentence: '"Contributing factors included crew fatigue, inadequate CRM, and the absence of a stabilised approach policy."',
            highlight: 'Contributing factors included … absence of',
            translation: 'Katkıda bulunan faktörler arasında mürettebat yorgunluğu, yetersiz CRM ve stabilize yaklaşma politikasının yokluğu sayılabilir.',
          ),
          ExampleSentence(
            sentence: '"The investigation identified a chain of events beginning with an undetected fuel leak that ultimately led to dual engine failure."',
            highlight: 'chain of events … undetected … ultimately led to',
            translation: 'Soruşturma, fark edilmemiş bir yakıt sızıntısıyla başlayan ve nihayetinde çift motor arızasına yol açan olaylar zincirini belirledi.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -256,
            category: QuestionCategory.reading,
            originalNumber: 2156,
            questionText: 'In an accident report, a "contributing factor" is:',
            options: [
              'the main direct cause of the accident',
              'a condition that increased risk but was not the direct cause',
              'a safety recommendation made after the accident',
              'an error made by ATC',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -257,
            category: QuestionCategory.reading,
            originalNumber: 2157,
            questionText: '"The accident resulted from the crew\'s failure to execute the go-around procedure." The phrase "resulted from" means:',
            options: [
              'was prevented by',
              'was caused by',
              'was reported after',
              'was unrelated to',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -258,
            category: QuestionCategory.reading,
            originalNumber: 2158,
            questionText: '"Safety recommendations" in an accident report are addressed to:',
            options: [
              'the accident crew only',
              'the aircraft manufacturer only',
              'relevant organisations to prevent recurrence',
              'passengers who witnessed the event',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -259,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2159,
            questionText: '"Loss of situational awareness ………… the crew\'s late recognition of the terrain warning." — which word best completes this finding?',
            options: ['prevented', 'contributed to', 'eliminated', 'reported'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  static const _amt6WorkOrder = LessonContent(
    id: 'amt_6',
    title: 'İş Emri ve Görev Kartı Dili',
    subtitle: 'Work order ve job card terminolojisi',
    categoryId: 'amt',
    estimatedTime: '12 dk',
    emoji: '🗂️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'İş emri sistemi neden öğrenilmeli',
        body:
            'Work Order (WO) ve Job Card (JC/Task Card), bakım planlaması ve takibinin temelini oluşturur. Part-145 onaylı organizasyonlarda tüm bakım faaliyetleri bir iş emrine bağlıdır.\n\nBir iş emrini doğru okumak: işin kapsamını, kullanılacak referans dokümanları, gerekli parça ve ekipmanı ve imza yetkinliklerini anlamayı gerektirir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 İş Emri Bölümleri ve Terimleri',
        body:
            '**Tipik Work Order bölümleri:**\n• Work scope — iş kapsamı\n• Reference documents — AMM, CMM, SB bölümleri\n• Man-hours — adam-saat tahmini\n• Materials required — gerekli malzeme listesi\n• Special tools — özel alet gereksinimleri\n• Zone — uçağın çalışma bölgesi\n• Sign-off — imza/onay\n\n**Job card fiilleri:**\n• Accomplish — gerçekleştir (formal)\n• Verify — doğrula\n• Ensure — emin ol\n• Record — kayıt al\n• Certify — onaylayıcı imzası ile onayla\n\n**Onay ifadeleri:**\n• "Signed and stamped by certifying staff"\n• "Work completed satisfactorily"\n• "Complies with [AMM chapter]"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Job Card Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'Task: Accomplish engine oil change in accordance with AMM 12-10-01. Record part numbers and batch numbers of oil used. Sign off upon completion.',
            highlight: 'Accomplish … in accordance with … Sign off upon completion',
            translation: 'Görev: AMM 12-10-01\'e uygun olarak motor yağı değişimini gerçekleştirin. Kullanılan yağın parça numaralarını ve seri numaralarını kaydedin. Tamamlandığında imzalayın.',
          ),
          ExampleSentence(
            sentence: 'Verify that all access panels are closed and secured prior to returning the aircraft to service.',
            highlight: 'Verify … prior to returning to service',
            translation: 'Uçağı servise geri döndürmeden önce tüm erişim panellerinin kapalı ve güvenli olduğunu doğrulayın.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -165,
            category: QuestionCategory.vocabulary,
            originalNumber: 2034,
            questionText: 'In a job card, "accomplish" is a formal word meaning:',
            options: ['check', 'carry out / perform', 'delay', 'cancel'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -166,
            category: QuestionCategory.vocabulary,
            originalNumber: 2035,
            questionText: '"Man-hours" in a work order refers to:',
            options: ['the number of workers', 'the estimated time required to complete the work', 'overtime payment', 'safety regulations for workers'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -167,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2036,
            questionText: '"Work completed ………… " is the standard sign-off phrase on a job card.',
            options: ['correctly', 'satisfactorily', 'successfully', 'properly'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — BEGINNER: Aviation Abbreviations
  // ─────────────────────────────────────────────────────────────
  static const _aviationAbbreviations = LessonContent(
    id: 'vocab_13',
    title: 'Temel Havacılık Kısaltmaları',
    subtitle: 'ATC, cockpit ve bakım belgelerinde en sık karşılaşılan kısaltmalar',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '🔤',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Neden önemlidir?',
        body:
            'Havacılık belgelerinde yüzlerce kısaltma yer alır. Bunları bilmek hem radyo iletişiminde hem de NOTAM, METAR ve teknik kitapları okurken hayat kurtarır.\n\nBu derste en kritik 20 kısaltmayı öğreneceksin.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Temel Kısaltmalar',
        body:
            '**Uçuş & ATC:**\n• ATC — Air Traffic Control\n• ATIS — Automatic Terminal Information Service\n• IFR — Instrument Flight Rules\n• VFR — Visual Flight Rules\n• SID — Standard Instrument Departure\n• STAR — Standard Terminal Arrival Route\n• ETA — Estimated Time of Arrival\n• ETD — Estimated Time of Departure\n\n**Hava Durumu:**\n• METAR — Meteorological Aerodrome Report\n• TAF — Terminal Aerodrome Forecast\n• QNH — Sea-level pressure setting\n• VMC — Visual Meteorological Conditions\n• IMC — Instrument Meteorological Conditions\n\n**Teknik / Bakım:**\n• AMM — Aircraft Maintenance Manual\n• MEL — Minimum Equipment List\n• AD — Airworthiness Directive\n• SB — Service Bulletin\n• AOG — Aircraft on Ground\n• ELT — Emergency Locator Transmitter\n• CVR — Cockpit Voice Recorder',
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'Kısaltmaları tam açılımıyla birlikte ezberle. Sınav soruları genellikle "What does ___ stand for?" veya açılımdan kısaltmaya sorma şeklinde gelir.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -170,
            category: QuestionCategory.vocabulary,
            originalNumber: 2040,
            questionText: 'What does "ATIS" stand for?',
            options: [
              'Air Traffic Instruction System',
              'Automatic Terminal Information Service',
              'Aviation Terminal Interface Standard',
              'Air Transport Identification Signal',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -171,
            category: QuestionCategory.vocabulary,
            originalNumber: 2041,
            questionText: 'The abbreviation "MEL" means:',
            options: [
              'Maximum Equipment List',
              'Minimum Equipment List',
              'Mandatory Equipment Limitation',
              'Mechanical Engineering Log',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -172,
            category: QuestionCategory.vocabulary,
            originalNumber: 2042,
            questionText: '"AOG" indicates that:',
            options: [
              'the aircraft is airborne on a glide path',
              'the aircraft is awaiting outbound gate',
              'the aircraft is grounded due to a technical issue',
              'the aircraft has obtained gate clearance',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -173,
            category: QuestionCategory.vocabulary,
            originalNumber: 2043,
            questionText: '"VMC" conditions mean that:',
            options: [
              'very marginal cloud cover is present',
              'visibility and cloud clearance meet visual flight criteria',
              'IFR flight is required',
              'the runway visual range is below minima',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — BEGINNER: Basic Weather Fill-in
  // ─────────────────────────────────────────────────────────────
  static const _basicWeatherFill = LessonContent(
    id: 'fill_7',
    title: 'Temel Hava Durumu: Boşluk Doldurma',
    subtitle: 'Wind, visibility, ceiling — temel hava durumu cümleleri',
    categoryId: 'fill',
    estimatedTime: '8 dk',
    emoji: '🌤️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Hava durumu iletişiminin temeli',
        body:
            'Pilot-ATC ve pilot-pilot iletişiminde hava durumu ifadeleri sürekli kullanılır. Standart kalıpları doğru doldurmak, yanlış anlaşılmaları önler.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Temel Kalıplar',
        examples: [
          ExampleSentence(
            sentence: 'Wind is 270 degrees at 15 knots.',
            highlight: 'Wind is',
            translation: 'Rüzgar 270 derecede 15 knot.',
          ),
          ExampleSentence(
            sentence: 'Visibility is 8 kilometres in light rain.',
            highlight: 'Visibility is',
            translation: 'Görüş hafif yağmurda 8 kilometre.',
          ),
          ExampleSentence(
            sentence: 'Ceiling is 1500 feet broken.',
            highlight: 'Ceiling is',
            translation: 'Tavan 1500 feet parçalı bulutlu.',
          ),
          ExampleSentence(
            sentence: 'QNH is 1013 hectopascals.',
            highlight: 'QNH is',
            translation: 'QNH 1013 hektopaskal.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -174,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2044,
            questionText: '"Wind ………… 180 degrees at 10 knots, gusting 20."',
            options: ['are', 'is', 'was', 'being'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -175,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2045,
            questionText: '"Visibility ………… reduced to 500 metres in fog."',
            options: ['are', 'has', 'is', 'will'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -176,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2046,
            questionText: '"Ceiling is 800 feet ………… ."',
            options: ['overcast', 'overcasted', 'overcasting', 'overcast\'s'],
            correctIndex: 0,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -177,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2047,
            questionText: '"Expect ………… conditions on approach."',
            options: ['IMC', 'INC', 'IMR', 'IRC'],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — ELEMENTARY: Departure Procedures
  // ─────────────────────────────────────────────────────────────
  static const _departureProcedures = LessonContent(
    id: 'vocab_14',
    title: 'Kalkış Prosedür Dili',
    subtitle: 'Pushback, startup, taxi ve clearance iletişim kalıpları',
    categoryId: 'vocabulary',
    estimatedTime: '12 dk',
    emoji: '🛫',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Kalkış öncesi süreç',
        body:
            'Her uçuşta pilot ve ATC arasında gerçekleşen standart iletişim sırası şöyledir:\n\n1. **ATIS dinle** — aktif pist ve hava durumunu öğren\n2. **Delivery\'den clearance al** — rota, transponder kodu, initial altitude\n3. **Ground\'dan taxi talimatı al** — hangi yoldan piste gidileceği\n4. **Tower\'dan kalkış izni al** — "cleared for takeoff"',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Standart Kalkış İfadeleri',
        body:
            '**Clearance request:**\n"Request IFR clearance to [destination], [aircraft type], [stand number]."\n\n**Readback:**\n"Cleared to [dest] via [SID], squawk [code], [callsign]."\n\n**Pushback & startup:**\n"Request pushback and startup, stand [X]."\n"Pushback and startup approved, face [direction]."\n\n**Taxi:**\n"Taxi to holding point runway [X] via [taxiways]."\n"Hold short of runway [X]."\n\n**Takeoff:**\n"Runway [X], cleared for takeoff, wind [X] degrees [X] knots."',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnek Diyalog',
        examples: [
          ExampleSentence(
            sentence: 'TK1234: "Istanbul Delivery, TK1234, request IFR clearance to Ankara, B738, stand 14."',
            highlight: 'request IFR clearance',
            translation: 'TK1234 İstanbul Teslim\'e Ankara\'ya IFR kalkış izni istiyor.',
          ),
          ExampleSentence(
            sentence: 'DEL: "TK1234, cleared to Ankara via GUVEN1A departure, squawk 2341."',
            highlight: 'cleared to',
            translation: 'Teslim birimi rota ve transponder kodunu onayladı.',
          ),
          ExampleSentence(
            sentence: 'TWR: "TK1234, runway 34R, cleared for takeoff, wind 330 degrees 12 knots."',
            highlight: 'cleared for takeoff',
            translation: 'Tower kalkış iznini verdi.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -178,
            category: QuestionCategory.vocabulary,
            originalNumber: 2048,
            questionText: 'Which phrase does ATC use to give takeoff permission?',
            options: [
              'Proceed to runway',
              'Cleared for takeoff',
              'Takeoff approved',
              'You may depart',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -179,
            category: QuestionCategory.vocabulary,
            originalNumber: 2049,
            questionText: '"Squawk 7700" means the pilot should:',
            options: [
              'select transponder code 7700 indicating emergency',
              'turn off the transponder',
              'select code 7700 for VFR flight',
              'report position to approach control',
            ],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -180,
            category: QuestionCategory.vocabulary,
            originalNumber: 2050,
            questionText: 'What does "hold short of runway 28" mean?',
            options: [
              'Enter runway 28 and wait',
              'Stop before entering runway 28',
              'Cross runway 28 quickly',
              'Line up on runway 28',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -181,
            category: QuestionCategory.vocabulary,
            originalNumber: 2051,
            questionText: '"Face south" in a pushback clearance means the aircraft nose should point:',
            options: ['north', 'east', 'south', 'west'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — ELEMENTARY: ATC Readback Drills
  // ─────────────────────────────────────────────────────────────
  static const _atcReadbackDrills = LessonContent(
    id: 'fill_8',
    title: 'ATC Readback Alıştırmaları',
    subtitle: 'Verilen ATC talimatlarını doğru tekrar etme',
    categoryId: 'fill',
    estimatedTime: '10 dk',
    emoji: '📻',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Readback nedir?',
        body:
            '**Readback** (geri okuma), ATC talimatlarının pilotlar tarafından tam olarak tekrar edilmesidir. ICAO standartlarına göre aşağıdaki bilgiler mutlaka readback yapılmalıdır:\n\n• Pist numarası (kalkış/iniş izinleri dahil)\n• Yön ve yükseklik talimatları\n• Transponder kodları\n• Rüzgar bilgisi ile birlikte verilen kalkış izinleri\n• Pist geçiş talimatları',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Readback Kuralları',
        body:
            '**DO readback (mutlaka tekrar et):**\n• ATC clearances (route, altitude, heading)\n• Runway crossing/entry instructions\n• Takeoff and landing clearances\n• QNH / altimeter settings\n• Frequency changes\n\n**Format:** [Talimat içeriği] + [Callsign]\nÖrnek: "Descend to 3000 feet, QNH 1018, TK1234."\n\n**Readback vermek yeterliliği onaylar** — yanlış anlaşılmayı önler.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -182,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2052,
            questionText: 'ATC says: "Descend to flight level 80." The correct readback is: "Descend to ………… 80, [callsign]."',
            options: ['level', 'altitude', 'flight level', 'height'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -183,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2053,
            questionText: 'ATC: "Turn left heading 270." Readback: "Turn ………… heading 270, [callsign]."',
            options: ['right', 'left', 'direct', 'onto'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -184,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2054,
            questionText: 'ATC: "Contact approach on 119.7." Readback: "………… approach on 119.7, [callsign]."',
            options: ['Calling', 'Contacting', 'Contact', 'Over to'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -185,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2055,
            questionText: 'Which item does NOT require a readback according to ICAO standards?',
            options: [
              'Runway crossing instructions',
              'Takeoff clearance',
              'General weather information only',
              'Transponder code',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — ELEMENTARY: Flight Phases Vocabulary
  // ─────────────────────────────────────────────────────────────
  static const _flightPhasesVocab = LessonContent(
    id: 'vocab_15',
    title: 'Uçuş Fazları Terminolojisi',
    subtitle: 'Taxi\'den iniş sonrasına kadar her faz ve anahtar kelimeler',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '✈️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Uçuşun aşamaları',
        body:
            'Her uçuş belirli fazlardan oluşur. Her fazın kendine özgü terminolojisi ve ATC iletişim kalıpları vardır. Bu terimleri bilmek hem sınavda hem de gerçek operasyonda kritik öneme sahiptir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Uçuş Fazları ve Anahtar Terimler',
        body:
            '**1. Pre-flight / Preflight**\n— walkaround, fuel check, NOTAMs, weight & balance\n\n**2. Taxi (Ground phase)**\n— taxiway, holding point, line up, backtrack\n\n**3. Takeoff**\n— rotate, V1 (decision speed), Vr (rotation speed), V2 (takeoff safety speed)\n\n**4. Climb (Departure)**\n— initial climb, SID, transition altitude, cruise climb\n\n**5. Cruise**\n— flight level, Mach number, step climb, drift down\n\n**6. Descent**\n— top of descent, STAR, speed restrictions\n\n**7. Approach**\n— ILS, localizer, glideslope, decision altitude (DA), MDA\n\n**8. Landing**\n— flare, touchdown, rollout, reverse thrust, exit vacate\n\n**9. Post-flight**\n— shutdown, parking, log entry, technical log',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -186,
            category: QuestionCategory.vocabulary,
            originalNumber: 2056,
            questionText: '"V1" in takeoff terminology is defined as:',
            options: [
              'the rotation speed',
              'the takeoff decision speed',
              'the takeoff safety speed',
              'the minimum control speed',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -187,
            category: QuestionCategory.vocabulary,
            originalNumber: 2057,
            questionText: '"Top of descent" refers to the point where:',
            options: [
              'the aircraft reaches cruise altitude',
              'the aircraft begins its descent from cruise level',
              'the approach briefing is completed',
              'ATC hands off to approach control',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -188,
            category: QuestionCategory.vocabulary,
            originalNumber: 2058,
            questionText: '"Decision altitude" (DA) on an ILS approach is the altitude at which:',
            options: [
              'the aircraft must land regardless of visibility',
              'flaps must be extended to full',
              'the pilot decides to continue or go around based on visual reference',
              'the ILS glideslope is intercepted',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -189,
            category: QuestionCategory.vocabulary,
            originalNumber: 2059,
            questionText: '"Backtrack" on a runway means:',
            options: [
              'an aborted takeoff procedure',
              'taxiing along the runway in the opposite direction of landing',
              'returning to the gate after engine start',
              'a go-around manoeuvre',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — INTERMEDIATE: Advanced Passive Voice
  // ─────────────────────────────────────────────────────────────
  static const _advancedPassiveVoice = LessonContent(
    id: 'grammar_11',
    title: 'İleri Düzey Edilgen Çatı',
    subtitle: 'Perfect passive, causative ve reporting structures',
    categoryId: 'grammar',
    estimatedTime: '14 dk',
    emoji: '⚙️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Edilgenin ileri formları',
        body:
            'Temel edilgen yapıyı biliyorsun. Şimdi havacılık belgelerinde sıkça karşılaşılan **perfect passive**, **causative** (have/get something done) ve **reporting structures** (It is reported that…) üzerine yoğunlaşacağız.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'İleri Yapılar',
        body:
            '**Perfect Passive:**\n• has/have been + V3 → "The engine has been inspected."\n• had been + V3 → "The part had been replaced before the flight."\n\n**Future Passive:**\n• will be + V3 → "The aircraft will be returned to service."\n• is going to be + V3 → "The runway is going to be closed."\n\n**Causative:**\n• have + object + V3 → "The airline had the engine overhauled."\n• get + object + V3 → "The crew got the fault rectified."\n\n**Reporting Passive:**\n• It is reported that… / It is believed that…\n• The aircraft is reported to have deviated from the assigned route.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Havacılık Örnekleri',
        examples: [
          ExampleSentence(
            sentence: 'The engine has been overhauled and is ready for return to service.',
            highlight: 'has been overhauled',
            translation: 'Motor revizyon görmüş ve servise dönüşe hazır.',
          ),
          ExampleSentence(
            sentence: 'The fault is reported to have been present since the previous flight.',
            highlight: 'is reported to have been present',
            translation: 'Arızanın bir önceki uçuştan bu yana mevcut olduğu rapor edilmektedir.',
          ),
          ExampleSentence(
            sentence: 'The airline had the airframe inspected by an independent authority.',
            highlight: 'had the airframe inspected',
            translation: 'Havayolu, gövdeyi bağımsız bir otorite tarafından denetletti.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -190,
            category: QuestionCategory.grammar,
            originalNumber: 2060,
            questionText: 'The hydraulic system ………… before the incident occurred.',
            options: [
              'was inspected',
              'had been inspected',
              'has been inspected',
              'will be inspected',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -191,
            category: QuestionCategory.grammar,
            originalNumber: 2061,
            questionText: 'It ………… that the aircraft deviated from its assigned altitude.',
            options: ['reports', 'is reported', 'reported', 'was reporting'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -192,
            category: QuestionCategory.grammar,
            originalNumber: 2062,
            questionText: 'The airline ………… the navigation system upgraded before the summer season.',
            options: ['got', 'had', 'made', 'let'],
            correctIndex: 1,
            difficulty: Difficulty.hard,
          ),
          QuestionModel(
            id: -193,
            category: QuestionCategory.grammar,
            originalNumber: 2063,
            questionText: 'The damaged component ………… by the time investigators arrived.',
            options: ['removed', 'was removed', 'had been removed', 'has removed'],
            correctIndex: 2,
            difficulty: Difficulty.hard,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — INTERMEDIATE: Advanced NOTAM Reading
  // ─────────────────────────────────────────────────────────────
  static const _notamReadingAdv = LessonContent(
    id: 'reading_10',
    title: 'İleri NOTAM Analizi',
    subtitle: 'Karmaşık NOTAM metinlerini çözümleme ve anlam çıkarma',
    categoryId: 'reading',
    estimatedTime: '15 dk',
    emoji: '📋',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'NOTAM nedir?',
        body:
            '**NOTAM** (Notice to Air Missions), pilotların haberdar edilmesi gereken havacılık bilgilerini içerir: pist kapanışları, VOR arızaları, geçici kısıtlama bölgeleri ve daha fazlası.\n\nBu derste gerçek NOTAM formatlarını çözümlemeyi öğreneceksin.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'NOTAM Formatı',
        body:
            '**Başlık:** A1234/23 NOTAMN\n**Q satırı:** Q) LTBB/QMRLC/IV/NBO/A/000/999/4102N02900E005\n**A:** LTBA (havalimanı ICAO kodu)\n**B:** 2301010600 (başlangıç: Ocak 2023, 06:00 UTC)\n**C:** 2301311800 (bitiş)\n**E:** İçerik (İngilizce)\n\n**Yaygın NOTAM türleri:**\n• QMRLC — Runway closed\n• QNVAS — VOR/NDB arızası\n• QLCAS — ILS unserviceable\n• QRTCA — Geçici kısıtlama bölgesi\n• QFAHW — Airwork in progress',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnek NOTAM',
        examples: [
          ExampleSentence(
            sentence: 'E) RWY 06/24 CLSD DUE RESURFACING WIP. EXPECT DUST AND DEBRIS IN VICINITY.',
            highlight: 'CLSD DUE RESURFACING WIP',
            translation: 'Pist 06/24 yüzey yenileme çalışması nedeniyle kapalı. Çevrede toz ve moloz bekleniyor.',
          ),
          ExampleSentence(
            sentence: 'E) ILS RWY 34L UNSERVICEABLE. CAT I OPS ONLY ON RWY 34R.',
            highlight: 'ILS RWY 34L UNSERVICEABLE',
            translation: 'Pist 34L ILS hizmete kapalı. Yalnızca Pist 34R\'de CAT I operasyon.',
          ),
          ExampleSentence(
            sentence: 'E) TEMPO RESTRICTED AREA ESTD FL050-FL200 DUE MILITARY EXERCISE.',
            highlight: 'TEMPO RESTRICTED AREA',
            translation: 'Askeri tatbikat nedeniyle FL050-FL200 arası geçici kısıtlı hava sahası.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -194,
            category: QuestionCategory.reading,
            originalNumber: 2064,
            questionText: 'NOTAM: "RWY 18/36 CLSD 0600-1800 DUE TO BIRD CONTROL OPS." When is the runway available?',
            options: [
              'Only during 0600-1800',
              'Before 0600 and after 1800',
              'Only at night',
              'The runway is permanently closed',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -195,
            category: QuestionCategory.reading,
            originalNumber: 2065,
            questionText: 'In a NOTAM, "UNSERVICEABLE" means the facility is:',
            options: [
              'operating at reduced capacity',
              'temporarily out of service',
              'permanently decommissioned',
              'under scheduled maintenance with no impact on ops',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -196,
            category: QuestionCategory.reading,
            originalNumber: 2066,
            questionText: 'NOTAM states: "TEMPO RESTRICTED AREA FL080-FL180." A flight at FL150 through this area would be:',
            options: [
              'unaffected as restrictions are below FL150',
              'in violation of the temporary restriction',
              'required to obtain a special clearance',
              'permitted if under IFR',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — INTERMEDIATE: Navigation Systems Vocabulary
  // ─────────────────────────────────────────────────────────────
  static const _navSystemsVocab = LessonContent(
    id: 'vocab_16',
    title: 'Navigasyon Sistemleri Terminolojisi',
    subtitle: 'VOR, ILS, GPS, RNAV, RNP — modern nav sistemleri',
    categoryId: 'vocabulary',
    estimatedTime: '12 dk',
    emoji: '🧭',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Modern navigasyon',
        body:
            'Günümüz havacılığında pilotlar birden fazla navigasyon sistemini birlikte kullanır. Her sistemin kendine has terminolojisi ve operasyonel kavramları bulunur.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Temel Navigasyon Sistemleri',
        body:
            '**VOR** (VHF Omnidirectional Range)\n— radial, bearing, CDI (Course Deviation Indicator)\n\n**ILS** (Instrument Landing System)\n— localizer (lateral), glideslope (vertical), outer/middle/inner marker\n— CAT I / II / III operations\n\n**DME** (Distance Measuring Equipment)\n— slant range in nautical miles\n\n**GPS / GNSS**\n— RAIM (Receiver Autonomous Integrity Monitoring)\n— WAAS/SBAS augmentation\n\n**RNAV / RNP**\n— Area navigation: fly any route, not just ground-based nav\n— RNP: required navigation performance with integrity monitoring\n— RNP AR: authorisation required approaches',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnek Cümleler',
        examples: [
          ExampleSentence(
            sentence: 'The ILS localizer provides lateral guidance to the runway centreline.',
            highlight: 'localizer',
            translation: 'ILS lokalizörü pist merkez hattına yatay yönlendirme sağlar.',
          ),
          ExampleSentence(
            sentence: 'RAIM failure means GPS integrity cannot be assured.',
            highlight: 'RAIM failure',
            translation: 'RAIM arızası GPS bütünlüğünün sağlanamadığı anlamına gelir.',
          ),
          ExampleSentence(
            sentence: 'The RNP AR approach requires special aircraft and crew authorisation.',
            highlight: 'RNP AR',
            translation: 'RNP AR yaklaşması özel uçak ve ekip yetkilendirmesi gerektirir.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -197,
            category: QuestionCategory.vocabulary,
            originalNumber: 2067,
            questionText: 'The "glideslope" component of an ILS provides:',
            options: [
              'lateral guidance to the runway',
              'vertical guidance for the descent',
              'distance information from the threshold',
              'wind shear alerts on approach',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -198,
            category: QuestionCategory.vocabulary,
            originalNumber: 2068,
            questionText: '"RAIM" in GPS operations stands for:',
            options: [
              'Radio Altitude Integrity Monitor',
              'Receiver Autonomous Integrity Monitoring',
              'Range Accuracy and Integrity Measurement',
              'Radar Altimeter Instrument Module',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -199,
            category: QuestionCategory.vocabulary,
            originalNumber: 2069,
            questionText: 'A VOR "radial" is defined as:',
            options: [
              'the bearing from the aircraft to the VOR',
              'the bearing from the VOR to the aircraft (magnetic)',
              'the distance from the aircraft to the VOR',
              'the altitude at which the VOR signal is received',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — INTERMEDIATE: TAF Reading
  // ─────────────────────────────────────────────────────────────
  static const _tafReading = LessonContent(
    id: 'reading_11',
    title: 'TAF Okuma ve Yorumlama',
    subtitle: 'Terminal Aerodrome Forecast — hava tahmin raporlarını çözümleme',
    categoryId: 'reading',
    estimatedTime: '14 dk',
    emoji: '🌦️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'TAF nedir?',
        body:
            '**TAF** (Terminal Aerodrome Forecast), bir havalimanı için 24 veya 30 saatlik hava tahminidir. METAR anlık durumu verirken TAF gelecekteki beklenen koşulları belirtir. Uçuş planlama açısından kritik öneme sahiptir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'TAF Formatı',
        body:
            '**Örnek TAF:**\nTAF LTBA 120500Z 1206/1312\n9999 FEW020 SCT060\nBECMG 1208/1210 BKN015 -RA\nTEMPO 1214/1218 4000 TSRA BKN010CB\n\n**Açıklama:**\n• LTBA — İstanbul (havalimanı ICAO kodu)\n• 120500Z — 12. günü 05:00 UTC\'de yayınlandı\n• 1206/1312 — Geçerlilik: 12. gün 06:00 – 13. gün 12:00 UTC\n• 9999 — 10 km veya üzeri görüş\n• BECMG — Gradually becoming (kademeli değişim)\n• TEMPO — Temporary fluctuation (geçici, < 1 saat)\n• TSRA — Thunderstorm with rain (gök gürültülü sağanak)\n• CB — Cumulonimbus',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'TAF Değişim Göstergeleri',
        examples: [
          ExampleSentence(
            sentence: 'BECMG 1208/1210 — conditions will gradually change between 08:00 and 10:00.',
            highlight: 'BECMG',
            translation: 'BECMG: 08:00-10:00 arasında koşullar kademeli olarak değişecek.',
          ),
          ExampleSentence(
            sentence: 'TEMPO 1214/1218 — temporary conditions lasting less than 1 hour at a time.',
            highlight: 'TEMPO',
            translation: 'TEMPO: 14:00-18:00 arasında geçici (her seferinde < 1 saat) koşullar.',
          ),
          ExampleSentence(
            sentence: 'PROB30 — 30% probability of the stated conditions.',
            highlight: 'PROB30',
            translation: 'PROB30: Belirtilen koşulların gerçekleşme olasılığı %30.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -200,
            category: QuestionCategory.reading,
            originalNumber: 2070,
            questionText: 'In a TAF, "TEMPO" indicates conditions that:',
            options: [
              'are permanent for the forecast period',
              'fluctuate temporarily, each occurrence lasting less than one hour',
              'gradually replace the previous conditions',
              'have a 30% probability of occurring',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -201,
            category: QuestionCategory.reading,
            originalNumber: 2071,
            questionText: 'TAF: "BECMG 1410/1412 BKN005 FG." This means:',
            options: [
              'fog and broken cloud at 500ft will temporarily occur between 10:00 and 12:00',
              'fog and broken cloud at 500ft will gradually develop between 10:00 and 12:00',
              'fog is forecast with 40% probability after 12:00',
              'broken cloud at 500ft will be permanent from 10:00',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -202,
            category: QuestionCategory.reading,
            originalNumber: 2072,
            questionText: '"9999" in a METAR or TAF means visibility is:',
            options: [
              'exactly 9,999 metres',
              '10 km or more',
              'less than 100 metres',
              'variable between 9 and 9 km',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — ADVANCED: PIREP Language
  // ─────────────────────────────────────────────────────────────
  static const _pirepLanguage = LessonContent(
    id: 'vocab_17',
    title: 'PIREP Dili',
    subtitle: 'Pilot Reports — türbülans, buzlanma ve hava fenomeni bildirimleri',
    categoryId: 'vocabulary',
    estimatedTime: '12 dk',
    emoji: '📡',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'PIREP nedir?',
        body:
            '**PIREP** (Pilot Report), pilotların uçuş sırasında karşılaştıkları meteorolojik koşulları ATC\'ye bildirdiği standart formattır. Diğer pilotlar için hayati önem taşır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'PIREP Kategorileri ve Terminolojisi',
        body:
            '**Türbülans şiddeti:**\n• Light (LGT) — küçük değişimler, hiçbir rahatsızlık yok\n• Moderate (MOD) — yiyecek/içecekler devrilebilir, hareket zor\n• Severe (SEV) — anlık kontrolü tehdit eden değişimler\n• Extreme (EXTM) — uçak neredeyse kontrol dışı\n\n**Buzlanma şiddeti:**\n• Trace — tespit edilebilir, sorun yok\n• Light — hız kaybı yok, buz giderici yeterli\n• Moderate — hız kaybı başlar, buz giderici güçlükle başa çıkabilir\n• Severe — ani hız/kaldırma kaybı, buz giderici yetersiz\n\n**PIREP Formatı:**\nUA /OV [konum] /TM [zaman] /FL [irtifa] /TP [uçak tipi]\n/SK [bulut] /WX [hava] /TA [sıcaklık] /TB [türbülans] /IC [buzlanma] /RM [açıklama]',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -203,
            category: QuestionCategory.vocabulary,
            originalNumber: 2073,
            questionText: 'A PIREP reporting "SEV TURB" means:',
            options: [
              'light turbulence that is barely noticeable',
              'moderate turbulence causing some spills',
              'severe turbulence causing momentary loss of aircraft control',
              'extreme turbulence causing structural damage',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -204,
            category: QuestionCategory.vocabulary,
            originalNumber: 2074,
            questionText: '"Moderate icing" in a PIREP indicates:',
            options: [
              'barely detectable ice accumulation',
              'ice accumulation where de-icing equipment may struggle to control it',
              'no significant effect on aircraft performance',
              'ice accumulation causing immediate emergency',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -205,
            category: QuestionCategory.vocabulary,
            originalNumber: 2075,
            questionText: 'In PIREP format, "/TB" refers to:',
            options: ['temperature below zero', 'turbulence report', 'top of broken layer', 'tail bearing'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — ADVANCED: Ops Manual Sentence Structures
  // ─────────────────────────────────────────────────────────────
  static const _opManualSentences = LessonContent(
    id: 'translation_8',
    title: 'Operasyon El Kitabı Cümle Yapıları',
    subtitle: 'OM-A, OM-B dilini anlama ve çevirme',
    categoryId: 'translation',
    estimatedTime: '14 dk',
    emoji: '📖',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Operations Manual (OM) dili',
        body:
            'Havayolu operasyon el kitapları (OM-A: Genel, OM-B: Uçuş Operasyonları) karmaşık yasal ve teknik dil içerir. Bu dili anlamak; kuralları doğru yorumlamak ve sınavda başarılı olmak için şarttır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Tipik OM Cümle Kalıpları',
        body:
            '**Zorunluluk ifadeleri:**\n• "The commander shall ensure that…"\n• "…must not commence unless…"\n• "…is required to carry…"\n\n**Koşullu izinler:**\n• "…may be carried out provided that…"\n• "…is permitted when all of the following conditions are met:"\n• "…subject to the approval of…"\n\n**Sorumluluk ifadeleri:**\n• "It is the responsibility of the commander to…"\n• "The operator shall ensure that…"\n• "The crew is authorised to…"',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -206,
            category: QuestionCategory.translation,
            originalNumber: 2076,
            questionText: 'Translate to Turkish: "The commander shall ensure that all crew members are briefed on emergency procedures."',
            options: [
              'Komutan, tüm mürettebat üyelerinin acil prosedürler konusunda brifing aldığından emin olmalıdır.',
              'Komutan, acil prosedürlerde mürettebatı eğitmek zorundadır.',
              'Tüm mürettebat üyeleri acil prosedürler hakkında bilgi sahibi olabilir.',
              'Komutan, acil prosedürleri mürettebata açıklaması gerekebilir.',
            ],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -207,
            category: QuestionCategory.translation,
            originalNumber: 2077,
            questionText: '"Flight must not commence unless the commander is satisfied with the serviceability of the aircraft." Bu cümle ne anlama gelir?',
            options: [
              'Uçuş, komutan uçağın arızalı olduğunu tespit edene kadar başlayabilir.',
              'Komutan uçağın operasyonel durumundan tatmin olmadıkça uçuşa başlanmamalıdır.',
              'Uçuş, yalnızca teknik sorunların giderilmesinden sonra başlatılabilir.',
              'Komutan, uçak servise alınmadan önce onay vermelidir.',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -208,
            category: QuestionCategory.translation,
            originalNumber: 2078,
            questionText: '"Additional fuel may be uplifted at the commander\'s discretion." What does this mean?',
            options: [
              'Extra fuel is mandatory on all flights',
              'The commander can decide to take extra fuel if deemed necessary',
              'Additional fuel is forbidden without prior approval',
              'Ground staff decide how much extra fuel to load',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — ADVANCED: Advanced ATC Completion
  // ─────────────────────────────────────────────────────────────
  static const _advancedAtcCompletion = LessonContent(
    id: 'completion_4',
    title: 'İleri ATC İletişim Tamamlama',
    subtitle: 'Karmaşık clearance ve procedural iletişimde boşluk doldurma',
    categoryId: 'completion',
    estimatedTime: '12 dk',
    emoji: '🎙️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'İleri ATC iletişimi',
        body:
            'Temel ATC iletişim kalıplarını biliyorsun. Bu derste daha karmaşık senaryolar için gerekli cümle yapılarını tamamlama becerini geliştireceksin: holding instructions, conditional clearances, re-routes.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Karmaşık ATC Kalıpları',
        body:
            '**Holding:**\n"Hold over [fix] at [altitude], [direction] turns, EFC [time]."\n"Expect further clearance at [time]."\n\n**Re-route:**\n"Route amended, proceed direct [waypoint], then as filed."\n"Re-cleared via [route], re-enter at [fix]."\n\n**Conditional clearance:**\n"Behind the landing [type] aircraft, [instruction]."\n"After departure of [callsign], line up runway [X]."\n\n**Speed control:**\n"Reduce speed to [X] knots not later than [fix]."\n"Resume normal speed."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -209,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2079,
            questionText: '"Hold over GUVEN at 5000 feet, left turns, expect further clearance ………… 1430."',
            options: ['before', 'at', 'until', 'by'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -210,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2080,
            questionText: '"Behind the landing Boeing 737, ………… on runway 05."',
            options: ['line up', 'cleared to land', 'hold position', 'back-track'],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -211,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2081,
            questionText: '"Reduce speed to 180 knots ………… IDONA."',
            options: ['after', 'by', 'at', 'not later than'],
            correctIndex: 3,
            difficulty: Difficulty.hard,
          ),
          QuestionModel(
            id: -212,
            category: QuestionCategory.sentenceCompletion,
            originalNumber: 2082,
            questionText: '"Route amended, proceed direct GUVEN, ………… as filed."',
            options: ['then', 'therefore', 'after that', 'and'],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // PILOT — ADVANCED: Fatigue and Human Performance Language
  // ─────────────────────────────────────────────────────────────
  static const _fatigueLanguage = LessonContent(
    id: 'vocab_18',
    title: 'Yorgunluk ve İnsan Performansı Dili',
    subtitle: 'FTL, FRMS ve CRM bağlamında yorgunluk terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '13 dk',
    emoji: '🧠',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Fatigue — neden önemlidir?',
        body:
            'Yorgunluk (fatigue), havacılıkta kaza-kırım nedenlerinin önemli bir bölümünü oluşturur. ICAO ve AB düzenlemeleri, ekiplerin yorgunluk riskini yönetmesi için kapsamlı bir dil ve sistem geliştirmiştir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Temel Yorgunluk Terminolojisi',
        body:
            '**FTL** — Flight Time Limitations (Uçuş Süresi Sınırlamaları)\n**FRMS** — Fatigue Risk Management System\n**FDP** — Flight Duty Period (uçuş görev süresi, raporlamadan kalkışa)\n**FT** — Flight Time (blok süresi)\n**Cumulative fatigue** — biriken yorgunluk (seferler arası tam dinlenme olmaksızın)\n**Sleep inertia** — uyanışın hemen ardından gelen bozulmuş performans\n**Circadian rhythm** — biyolojik saat\n**WOCL** — Window of Circadian Low (02:00-06:00 arası; performans en düşük)\n**Split duty** — uzun mola içeren, 2 parçalı görev periyodu\n**Controlled rest** — kokpitte kısa uyku (uzun menzilli uçuşlarda izinli)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Bağlam İçinde Kullanım',
        examples: [
          ExampleSentence(
            sentence: 'The crew\'s FDP exceeded the regulatory maximum, triggering an FRMS review.',
            highlight: 'FDP exceeded',
            translation: 'Mürettebatın uçuş görev süresi yasal azamíyi aştı ve FRMS incelemesini başlattı.',
          ),
          ExampleSentence(
            sentence: 'Operations during the WOCL significantly increase the risk of crew error.',
            highlight: 'WOCL',
            translation: 'Sirkadiyen düşüş penceresinde (02:00-06:00) operasyon, mürettebat hatası riskini önemli ölçüde artırır.',
          ),
          ExampleSentence(
            sentence: 'Sleep inertia must be considered before using controlled rest during long-haul flights.',
            highlight: 'Sleep inertia',
            translation: 'Uzun menzilli uçuşlarda kontrollü uyku kullanılmadan önce uyku ataleti göz önünde bulundurulmalıdır.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -213,
            category: QuestionCategory.vocabulary,
            originalNumber: 2083,
            questionText: '"WOCL" refers to the time window when:',
            options: [
              'flight operations are prohibited',
              'crew performance is at its lowest due to circadian rhythm',
              'weather conditions are typically worst',
              'ATC workload is at maximum',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -214,
            category: QuestionCategory.vocabulary,
            originalNumber: 2084,
            questionText: '"Sleep inertia" describes:',
            options: [
              'the inability to fall asleep during a rest period',
              'impaired performance immediately after waking',
              'chronic fatigue from repeated short sleep periods',
              'the regulatory limit on crew rest between duties',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -215,
            category: QuestionCategory.vocabulary,
            originalNumber: 2085,
            questionText: '"FRMS" is used by airlines to:',
            options: [
              'schedule flight routes for fuel efficiency',
              'proactively manage crew fatigue risk based on data',
              'record flight time and duty periods automatically',
              'regulate passenger load factors',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -216,
            category: QuestionCategory.vocabulary,
            originalNumber: 2086,
            questionText: '"Cumulative fatigue" occurs when:',
            options: [
              'a single flight exceeds the maximum flight time',
              'fatigue builds up over multiple duty periods without adequate recovery',
              'the crew operates more than two sectors in one day',
              'fatigue is caused by a single all-night operation',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ═══════════════════════════════════════════════════════════
  //  CABIN CREW LESSONS — cabin_7 through cabin_18
  // ═══════════════════════════════════════════════════════════

  static const _cabin7BoardingAnnouncements = LessonContent(
    id: 'cabin_7',
    title: 'Biniş Anonsları',
    subtitle: 'Gate ve uçak içi biniş duyuruları İngilizcesi',
    categoryId: 'vocabulary',
    estimatedTime: '9 dk',
    emoji: '🎤',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Standart biniş anonsları',
        body:
            'Biniş süreci sırasında hem kapı ajanları hem kabin ekibi belirli standart anonslar yapar. Bu ifadelerin doğru İngilizcesini bilmek hem yolcularla hem de havalimanı personeli ile iletişimi kolaylaştırır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yaygın Biniş İfadeleri',
        body:
            '"Ladies and gentlemen, we are now boarding…"\n"May I see your boarding pass and passport, please?"\n"Your seat is in row [X], on the [left/right]."\n"Please stow your carry-on baggage in the overhead bin."\n"The overhead bin above your seat is full. We will check your bag to the final destination."\n"We are expecting a full flight today. Please take your seats promptly."\n"We will begin boarding with passengers requiring extra assistance."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -217,
            category: QuestionCategory.vocabulary,
            originalNumber: 2087,
            questionText: 'Which phrase is used when the overhead bin is full?',
            options: [
              '"Please hold your bag on your lap."',
              '"We will check your bag to the final destination."',
              '"Your bag must remain at the gate."',
              '"Please leave your bag in the aisle."',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -218,
            category: QuestionCategory.vocabulary,
            originalNumber: 2088,
            questionText: '"Stow your carry-on baggage" means:',
            options: [
              'check the bag at the counter',
              'place the bag in a storage area (bin or under seat)',
              'carry the bag to your seat',
              'leave the bag with the gate agent',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _cabin8SeatbeltDemo = LessonContent(
    id: 'cabin_8',
    title: 'Emniyet Kemeri Demo Dili',
    subtitle: 'Güvenlik demonstrasyonu sırasında kullanılan standart İngilizce',
    categoryId: 'fill',
    estimatedTime: '8 dk',
    emoji: '🔒',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Güvenlik demonstrasyonu',
        body:
            'ICAO ve havayolu SOPları gereği tüm yolculara uçuş öncesinde güvenlik demonstrasyonu yapılmalı veya video gösterilmelidir. Kullanılan dil standartlaştırılmıştır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Demo İfadeleri',
        body:
            '"To fasten your seatbelt, insert the metal fitting into the buckle and tighten by pulling the loose end of the strap."\n"To release, lift the top of the buckle."\n"Your seatbelt should be worn low and tight across your lap at all times when seated."\n"Please direct your attention to the cabin crew for a safety demonstration."\n"There are [X] emergency exits on this aircraft: two at the front, two over the wings, and two at the rear."\n"In the event of a loss of cabin pressure, an oxygen mask will drop from the panel above you. Pull it towards you, place it over your nose and mouth, and breathe normally."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -219,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2089,
            questionText: '"To ………… your seatbelt, insert the metal fitting into the buckle."',
            options: ['secure', 'fasten', 'lock', 'tighten'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -220,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2090,
            questionText: '"Pull the oxygen mask ………… you and place it over your nose and mouth."',
            options: ['away from', 'towards', 'beside', 'under'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _cabin9ServiceLanguage = LessonContent(
    id: 'cabin_9',
    title: 'İkram Servis Dili',
    subtitle: 'Yiyecek, içecek ve duty-free servisi İngilizcesi',
    categoryId: 'vocabulary',
    estimatedTime: '9 dk',
    emoji: '🍽️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Kabin servisi iletişimi',
        body:
            'Kabin ekibinin yolcularla günlük iletişiminin önemli bir bölümü ikram servisi sırasında gerçekleşir. Profesyonel ve net bir dil kullanmak yolcu memnuniyetini doğrudan etkiler.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Servis İfadeleri',
        body:
            '"Would you like chicken or pasta for your main course?"\n"I\'m afraid we\'ve run out of chicken. Would you like pasta instead?"\n"Would you like something to drink?"\n"That would be [price]. Would you like to pay by card or cash?"\n"Your meal will be served shortly."\n"We will be coming through the cabin with duty-free items."\n"Please ensure your tray table is stowed and your seat is in the upright position for landing."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -221,
            category: QuestionCategory.vocabulary,
            originalNumber: 2091,
            questionText: '"I\'m afraid we\'ve run out of chicken" means:',
            options: [
              'chicken is being prepared',
              'chicken is no longer available',
              'chicken is only available in business class',
              'chicken will be served later',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -222,
            category: QuestionCategory.vocabulary,
            originalNumber: 2092,
            questionText: '"Tray table stowed" means the tray table is:',
            options: ['extended and ready for use', 'folded back into the seat', 'cleaned and disinfected', 'removed for safety'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _cabin10TurbulenceComm = LessonContent(
    id: 'cabin_10',
    title: 'Türbülans İletişimi',
    subtitle: 'Türbülans öncesi, sırası ve sonrasındaki standart anonslar',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '⚡',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Türbülans neden özel iletişim gerektirir?',
        body:
            'Türbülans, yolcularda ve ekipte yaralanmaya yol açabilen en yaygın uçuş güvenliği sorunlarından biridir. Net ve sakin bir iletişim, paniği önler ve güvenliği artırır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Türbülans Anonsları',
        body:
            '**Öncesinde:**\n"Ladies and gentlemen, the captain has switched on the fasten seatbelt sign. Please return to your seats and fasten your seatbelts."\n"We are expecting some turbulence ahead. Please remain seated with your seatbelts fastened."\n\n**Servis durumu:**\n"Due to turbulence, cabin service has been suspended. Please remain seated."\n\n**Sonrasında:**\n"The captain has turned off the fasten seatbelt sign. You may now move about the cabin, however we recommend keeping your seatbelt fastened when seated."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -223,
            category: QuestionCategory.vocabulary,
            originalNumber: 2093,
            questionText: '"The fasten seatbelt sign has been switched on" means passengers should:',
            options: [
              'prepare for emergency landing',
              'return to seats and fasten seatbelts',
              'move to emergency exits',
              'deploy oxygen masks',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -224,
            category: QuestionCategory.vocabulary,
            originalNumber: 2094,
            questionText: '"Cabin service has been suspended" means:',
            options: [
              'service has ended for the flight',
              'service is temporarily stopped',
              'only drinks are available',
              'service will not start',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _cabin11MedicalReporting = LessonContent(
    id: 'cabin_11',
    title: 'Tıbbi Acil Durum Raporlaması',
    subtitle: 'Doktora, kaptana ve ATC\'ye tıbbi durum bildirimi',
    categoryId: 'reading',
    estimatedTime: '12 dk',
    emoji: '🏥',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Tıbbi acil durumlar',
        body:
            'Kabin ekibi bir tıbbi acil durumla karşılaştığında hem kaptana hem yerdeki tıbbi destek hattına hem de gerekirse ATC\'ye net bilgi iletmek zorundadır. Yanlış veya eksik bilgi doğru müdahaleyi geciktirir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Tıbbi Rapor İfadeleri',
        body:
            '"Captain, we have a medical situation in row [X]. Passenger appears [conscious/unconscious]."\n"The passenger is [complaining of chest pain / having difficulty breathing / showing signs of allergic reaction]."\n"We have administered [oxygen / epinephrine / aspirin]."\n"Is there a doctor or medical professional on board?"\n"Medlink, this is [airline/flight number], we have a passenger with [symptoms], current position is [location]."\n"We request medical diversion to the nearest suitable airport."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -225,
            category: QuestionCategory.reading,
            originalNumber: 2095,
            questionText: '"Passenger appears unconscious" means the passenger:',
            options: [
              'is sleeping and should not be disturbed',
              'is unresponsive and not awake',
              'is conscious but confused',
              'is refusing to cooperate with crew',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -226,
            category: QuestionCategory.reading,
            originalNumber: 2096,
            questionText: '"We request medical diversion" means the crew is asking to:',
            options: [
              'continue to the destination and arrange ambulance',
              'land at a different airport for medical assistance',
              'return to the departure airport',
              'request a doctor via radio',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _cabin12EvacuationCommands = LessonContent(
    id: 'cabin_12',
    title: 'Tahliye Komutları',
    subtitle: 'Emergency evacuation sırasında kullanılan standart komutlar',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '🚪',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Tahliye iletişimi hayat kurtarır',
        body:
            'Acil tahliyede saniyeler kritiktir. Kabin ekibinin kullandığı komutların net, standart ve yüksek sesle verilmesi gerekir. ICAO ve havayolu SOPları bu ifadeleri belirler.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Standart Tahliye Komutları',
        body:
            '"EVACUATE! EVACUATE! EVACUATE!"\n"RELEASE SEATBELTS! LEAVE EVERYTHING! GET OUT!"\n"COME THIS WAY! THIS EXIT!" (işlevsel çıkıştayken)\n"COME THIS WAY!" (fonksiyonel olmayan çıkıştayken yönlendirme)\n"JUMP AND SLIDE!" / "STEP OFF THE SLIDE!"\n"MOVE AWAY FROM THE AIRCRAFT! MOVE AWAY!"\n\n**Kapalı çıkışta:**\n"GET BACK! GET BACK! COME THIS WAY!" (diğer çıkışa yönlendirme)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -227,
            category: QuestionCategory.vocabulary,
            originalNumber: 2097,
            questionText: 'During an evacuation, "LEAVE EVERYTHING" means passengers should:',
            options: [
              'take only their valuables',
              'take carry-on bags but leave checked bags',
              'leave all their belongings and exit immediately',
              'leave only large bags and take small items',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -228,
            category: QuestionCategory.vocabulary,
            originalNumber: 2098,
            questionText: 'If a cabin crew member says "GET BACK! COME THIS WAY!" it means:',
            options: [
              'the exit is clear and passengers should proceed',
              'the exit is blocked and passengers should use another exit',
              'passengers are moving too fast',
              'the crew member wants passengers to sit down',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _cabin13ConflictResolution = LessonContent(
    id: 'cabin_13',
    title: 'Yolcu Çatışma Yönetimi Dili',
    subtitle: 'Zor yolcularla iletişim ve de-escalation teknikleri',
    categoryId: 'vocabulary',
    estimatedTime: '11 dk',
    emoji: '🤝',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'De-escalation neden önemlidir?',
        body:
            'Disruptive passenger (rahatsız edici yolcu) vakaları hem uçuş güvenliğini hem de diğer yolcuları etkiler. Doğru dil ve tutum, durumun daha da kötüleşmesini önler.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'De-escalation İfadeleri',
        body:
            '"I understand your concern, sir/ma\'am. Let me see what I can do."\n"I\'m sorry for the inconvenience. We\'re doing our best to assist you."\n"I need you to return to your seat for the safety of all passengers."\n"If you continue this behaviour, the captain will be informed and we may have to divert."\n"I\'m going to have to ask you to comply with crew instructions."\n"We take the comfort and safety of all passengers very seriously."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -229,
            category: QuestionCategory.vocabulary,
            originalNumber: 2099,
            questionText: '"Comply with crew instructions" means the passenger should:',
            options: [
              'argue with the crew politely',
              'follow what the crew has told them to do',
              'report the crew to the airline',
              'ask for a supervisor',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -230,
            category: QuestionCategory.vocabulary,
            originalNumber: 2100,
            questionText: '"We may have to divert" means the aircraft might:',
            options: [
              'accelerate to reach the destination faster',
              'land at an unplanned airport',
              'delay departure',
              'return to the gate',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _cabin14CustomsForms = LessonContent(
    id: 'cabin_14',
    title: 'Gümrük ve Göçmenlik Formu Dili',
    subtitle: 'Arrival cards, customs declarations ve entry forms',
    categoryId: 'reading',
    estimatedTime: '10 dk',
    emoji: '📝',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Gümrük formları',
        body:
            'Uluslararası uçuşlarda yolculara arrival card (giriş kartı) veya customs declaration form (gümrük beyan formu) doldurmaları için kabin ekibi rehberlik eder. Bu belgelerdeki terminoloji standartlaştırılmıştır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Form Terminolojisi',
        body:
            '**Arrival card:**\n• Surname / Family name — soyadı\n• Given names / First name — adı\n• Date of birth (DD/MM/YYYY) — doğum tarihi\n• Nationality — uyruk\n• Passport number — pasaport numarası\n• Purpose of visit: tourism / business / transit / study\n• Address in country of destination — gidilen ülkedeki adres\n\n**Customs declaration:**\n• Do you have goods to declare? — Beyan edecek eşyanz var mı?\n• Are you carrying currency exceeding [limit]? — Limitin üzerinde döviz taşıyor musunuz?\n• Are you carrying meat, dairy, or plant products? — Et, süt veya bitki ürünleri taşıyor musunuz?',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -231,
            category: QuestionCategory.reading,
            originalNumber: 2101,
            questionText: '"Purpose of visit: transit" means the passenger is:',
            options: [
              'visiting for tourism',
              'passing through to another destination',
              'working in the country',
              'studying in the country',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -232,
            category: QuestionCategory.reading,
            originalNumber: 2102,
            questionText: '"Goods to declare" on a customs form means:',
            options: [
              'items that must be listed because they may be subject to customs duty or restrictions',
              'all personal belongings in the suitcase',
              'items purchased at duty-free shops only',
              'medical items requiring special handling',
            ],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _cabin15CrewRest = LessonContent(
    id: 'cabin_15',
    title: 'Mürettebat Dinlenme Prosedürleri Dili',
    subtitle: 'Uzun menzilli uçuşlarda crew rest iletişimi',
    categoryId: 'vocabulary',
    estimatedTime: '9 dk',
    emoji: '😴',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Crew rest neden önemlidir?',
        body:
            'Uzun menzilli uçuşlarda (genellikle 8 saati aşan) kabin ekibine dinlenme fırsatı sağlanır. Bu sürecin yönetimi ve iletişimi belirli bir terminoloji gerektirir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Crew Rest Terminolojisi',
        body:
            '**Crew rest compartment (CRC)** — ekip dinlenme bölmesi (üst veya alt güverte)\n**Break schedule** — dinlenme takvimi\n**In-charge cabin crew member** — sorumlu kabin amiri\n\nİfadeler:\n"I\'m going on my scheduled break. [Name] will be in charge."\n"Please call me if there is a medical emergency or if turbulence is forecast."\n"The crew will be taking turns resting. One senior crew member will remain in the cabin at all times."\n"We are approximately [X] hours from destination. Crew rest will begin shortly."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -233,
            category: QuestionCategory.vocabulary,
            originalNumber: 2103,
            questionText: '"In-charge cabin crew member" during rest refers to:',
            options: [
              'the captain monitoring the cabin',
              'the senior cabin crew responsible while others rest',
              'a passenger volunteer',
              'a relief pilot who monitors passengers',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _cabin16MaydayPanPan = LessonContent(
    id: 'cabin_16',
    title: 'Kabin için MAYDAY ve PAN PAN',
    subtitle: 'Acil durum iletişiminde kabin ekibinin rolü',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '🚨',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Kabin ekibi ve acil iletişim',
        body:
            'MAYDAY ve PAN PAN çağrıları teknik olarak pilotlar tarafından yapılır. Ancak kabin ekibinin bu terimlerin anlamını, prosedürler içindeki rolünü ve kaptanla iletişim dilini bilmesi zorunludur.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'MAYDAY vs PAN PAN',
        body:
            '**MAYDAY** (3 kez tekrar edilir):\n— Hayati tehlike veya acil yardım gerektiren durum\n— Yangın, dekompresyon, motor arızası, tıbbi kritik durum\n— Kabin ekibi: kabini tahliye ve brace pozisyonu için hazırlar\n\n**PAN PAN** (3 kez tekrar edilir):\n— Acil durum değil, ancak yardım gerekebilir (urgency)\n— Tıbbi acil durum (hayati tehlike olmayan), yakıt azlığı\n— Kabin ekibi: kaptanı bilgilendirir, normal prosedür devam eder\n\n**Kabin-Kokpit iletişimi:**\n"Captain, this is [name] in the cabin. We have a [describe situation]."\n"What are your instructions?"\n"Understood. We will [action]."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -234,
            category: QuestionCategory.vocabulary,
            originalNumber: 2104,
            questionText: 'A "MAYDAY" call indicates:',
            options: [
              'an urgency situation requiring possible assistance',
              'a distress situation with immediate danger to life',
              'a routine priority request for ATC assistance',
              'a passenger medical situation',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -235,
            category: QuestionCategory.vocabulary,
            originalNumber: 2105,
            questionText: '"PAN PAN" compared to "MAYDAY" indicates:',
            options: [
              'a more serious emergency',
              'an urgency requiring assistance but not immediate danger to life',
              'a routine communication',
              'an engine failure',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _cabin17InfantSafety = LessonContent(
    id: 'cabin_17',
    title: 'Bebek ve Çocuk Güvenlik Dili',
    subtitle: 'Bassinet, CARES harness ve çocuk emniyeti terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '8 dk',
    emoji: '👶',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Çocuk yolcularla iletişim',
        body:
            'Bebekli ve çocuklu yolcular özel ekipman ve güvenlik kılavuzlarına ihtiyaç duyar. Kabin ekibinin bu ekipmanlara ilişkin terminolojiyi ve kural ifadelerini bilmesi gerekir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Bebek ve Çocuk Güvenlik Terimleri',
        body:
            '**Bassinet** — uçak koltuğuna monte edilen bebek yatağı (kalkış, iniş ve türbülansta kaldırılır)\n**CARES harness** — çocuklar için onaylı emniyet kemeri eki\n**Child restraint system (CRS)** — çocuk güvenlik sistemi (araba koltuğu gibi)\n**Lap infant** — kucakta taşınan bebek (< 2 yaş, kendi koltuğu yok)\n**Supplemental loop belt** — bazı ülkelerde onaylı bebek kemeri eki\n\nİfadeler:\n"The bassinet must be removed for takeoff, landing, and during turbulence."\n"Lap infants must be held securely or placed in an approved CRS."\n"Please ensure the child is properly secured in the CARES harness."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -236,
            category: QuestionCategory.vocabulary,
            originalNumber: 2106,
            questionText: 'A "bassinet" must be removed during:',
            options: [
              'meal service only',
              'takeoff, landing, and turbulence',
              'cruise phase only',
              'immigration checks',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -237,
            category: QuestionCategory.vocabulary,
            originalNumber: 2107,
            questionText: '"Lap infant" refers to a child who:',
            options: [
              'has their own seat and restraint system',
              'is under 2 years old and held by a parent without their own seat',
              'requires a CARES harness',
              'is travelling unaccompanied',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _cabin18ServiceFailure = LessonContent(
    id: 'cabin_18',
    title: 'Servis Hatası İletişimi',
    subtitle: 'Eksik ikram, sistem arızası ve özür ifadeleri',
    categoryId: 'translation',
    estimatedTime: '9 dk',
    emoji: '🙏',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Servis hataları nasıl yönetilir?',
        body:
            'Kabin hizmetlerinde aksaklıklar (eksik yemek seçeneği, sistem arızası, koltuk sorunu) yaşanabilir. Bunları profesyonel bir dille yönetmek, müşteri memnuniyetini ve güveni korur.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Servis Hatası İfadeleri',
        body:
            '"I sincerely apologise for the inconvenience."\n"Unfortunately, your pre-ordered meal was not loaded onto the aircraft. I\'m sorry for this error."\n"I\'m afraid the in-flight entertainment system in your seat is not functioning. I\'ll try to reset it."\n"We will report this issue to the airline and ensure you are compensated."\n"As an apology, may I offer you [complimentary item]?"\n"Your feedback is very important to us. I\'ll inform my supervisor."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -238,
            category: QuestionCategory.translation,
            originalNumber: 2108,
            questionText: 'Translate to Turkish: "I sincerely apologise for the inconvenience caused."',
            options: [
              'Bu rahatsızlık için içtenlikle özür dilerim.',
              'Bu sorun için üzgün değilim.',
              'Maalesef yardımcı olamıyorum.',
              'Bu durum bizim sorumluluğumuzda değil.',
            ],
            correctIndex: 0,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -239,
            category: QuestionCategory.translation,
            originalNumber: 2109,
            questionText: '"We will ensure you are compensated" means:',
            options: [
              'nothing will be done',
              'the airline will provide something in return for the inconvenience',
              'the passenger will be charged extra',
              'the crew will apologise again at the destination',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  // ═══════════════════════════════════════════════════════════
  //  AMT LESSONS — amt_7 through amt_18
  // ═══════════════════════════════════════════════════════════

  static const _amt7TechnicalLog = LessonContent(
    id: 'amt_7',
    title: 'Teknik Günlük Girişleri',
    subtitle: 'Aircraft technical log — arıza kaydı ve imza dili',
    categoryId: 'fill',
    estimatedTime: '11 dk',
    emoji: '📓',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Teknik günlük nedir?',
        body:
            '**Aircraft Technical Log (ATL)**, uçakla birlikte seyahat eden ve her uçuş segmentinde doldurulması zorunlu olan belgedir. Arızaları, yapılan işlemleri ve uçuşa elverişlilik beyanını içerir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'ATL Girişi İfadeleri',
        body:
            '**Arıza kaydı (Defect entry):**\n"Captain\'s report: [defect description]. Aircraft serviceable for next flight with defect deferred to MEL item [X]."\n\n**Giderme kaydı (Rectification):**\n"Rectified in accordance with AMM Chapter [X], Task [X]. Part replaced: P/N [X], S/N [X]. Aircraft certified serviceable."\n\n**Erteleme (Deferral):**\n"Defect deferred under MEL item [X] for [X] calendar days. Placard installed."\n\n**Teknisyen imzası:**\n"I certify that the work specified above has been carried out in accordance with Part-145 and the data specified therein."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -240,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2110,
            questionText: '"Defect ………… under MEL item 29-1 for 10 calendar days."',
            options: ['closed', 'deferred', 'delayed', 'removed'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -241,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2111,
            questionText: '"Aircraft ………… serviceable." (rectification tamamlandıktan sonra yazılan ifade)',
            options: ['declared', 'certified', 'confirmed', 'approved'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -242,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2112,
            questionText: '"Rectified in ………… with AMM Chapter 28."',
            options: ['compliance', 'accordance', 'agreement', 'line'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _amt8InspectionTerms = LessonContent(
    id: 'amt_8',
    title: 'Muayene Terminolojisi',
    subtitle: 'Visual, detailed, special detailed — muayene türleri ve dili',
    categoryId: 'vocabulary',
    estimatedTime: '11 dk',
    emoji: '🔍',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Havacılıkta muayene türleri',
        body:
            'Havacılık bakımında farklı derinlikte muayene türleri tanımlanmıştır. Doğru terminolojiyi bilmek, iş emrini (work order) ve sonuç raporunu doğru yazmak için şarttır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Muayene Türleri',
        body:
            '**General Visual Inspection (GVI):**\n— Geniş alanda, erişim gerekmeksizin yapılan genel görsel muayene\n— Hasarı, arızayı, düzensizliği tespit etmek için\n\n**Detailed Inspection (DET):**\n— Yakın mesafeden, genellikle aydınlatma ve büyütme yardımıyla\n— Belirli bir alana odaklanır\n\n**Special Detailed Inspection (SDI):**\n— NDT (Non-Destructive Testing) teknikleri içerir\n— Borescope, eddy current, ultrasonic, X-ray\n\n**Operational Check:**\n— Sistemin tasarım fonksiyonunu gerçekleştirip gerçekleştirmediğini doğrular\n\n**Functional Check:**\n— Belirli fonksiyonun quantitative (sayısal) olarak doğrulanması',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -243,
            category: QuestionCategory.vocabulary,
            originalNumber: 2113,
            questionText: 'A "General Visual Inspection" (GVI) is best described as:',
            options: [
              'a close-up inspection with magnifying equipment',
              'a broad-area visual check without opening access panels',
              'an NDT technique using eddy current',
              'a quantitative check of system performance',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -244,
            category: QuestionCategory.vocabulary,
            originalNumber: 2114,
            questionText: '"Borescope inspection" is an example of:',
            options: [
              'General Visual Inspection',
              'Operational Check',
              'Special Detailed Inspection',
              'Functional Check',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _amt9EngineRunup = LessonContent(
    id: 'amt_9',
    title: 'Motor Run-up Dili',
    subtitle: 'Ground run ve engine test prosedür terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '🔥',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Engine run-up nedir?',
        body:
            'Bakım sonrası motorun zemin testine "engine run-up" veya "ground run" denir. Bu test, motorun operasyonel parametrelerini doğrulamak ve kaçakları tespit etmek için yapılır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Run-up Terminolojisi',
        body:
            '**Ground run authorization** — zemin testi için gerekli izin belgesi\n**Idle** — rölanti (en düşük güç ayarı)\n**Take-off power (TOGA)** — maksimum kalkış gücü\n**EGT** — Exhaust Gas Temperature (egzoz gaz sıcaklığı)\n**N1 / N2** — fan ve kompresör hız yüzdesi\n**Oil pressure / oil temperature** — yağ basıncı / sıcaklığı\n**Surge** — kompresör sürjü (anormal ses + EGT artışı)\n**Wet start** — ateşleme olmaksızın yakıt sızdırması\n**Hung start** — motor ateşlenir fakat rölantiye ulaşamaz\n**Hot start** — EGT başlangıç limitini aşar',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -245,
            category: QuestionCategory.vocabulary,
            originalNumber: 2115,
            questionText: 'A "hot start" during engine start means:',
            options: [
              'the engine reached idle faster than normal',
              'EGT exceeded the start temperature limit',
              'the engine failed to ignite',
              'oil pressure dropped during startup',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -246,
            category: QuestionCategory.vocabulary,
            originalNumber: 2116,
            questionText: '"Hung start" describes a condition where:',
            options: [
              'the engine lights up but does not accelerate to idle',
              'the engine reaches full power too quickly',
              'ignition fails completely',
              'EGT is normal but N1 is high',
            ],
            correctIndex: 0,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -247,
            category: QuestionCategory.vocabulary,
            originalNumber: 2117,
            questionText: '"TOGA" power setting is used during:',
            options: [
              'normal cruise',
              'engine idle on ground',
              'maximum power for takeoff or go-around',
              'approach and landing',
            ],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _amt10CorrosionReport = LessonContent(
    id: 'amt_10',
    title: 'Korozyon Raporu Dili',
    subtitle: 'Korozyon türleri, derecelendirme ve raporlama terminolojisi',
    categoryId: 'reading',
    estimatedTime: '12 dk',
    emoji: '🦠',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Korozyon neden kritiktir?',
        body:
            'Korozyon, hava aracı yapısal bütünlüğünü tehdit eden en önemli sorunlardan biridir. AMT\'nin farklı korozyon türlerini tanımlayabilmesi ve raporunu doğru yazabilmesi zorunludur.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Korozyon Terminolojisi',
        body:
            '**Türler:**\n• Surface corrosion — yüzey korozyonu (oksitlenme)\n• Pitting corrosion — çukur/nokta korozyonu\n• Intergranular corrosion — taneler arası korozyon\n• Galvanic corrosion — farklı metaller temasından oluşan\n• Stress corrosion cracking — gerilim + korozyon birlikteliği\n• Filiform corrosion — boya altı ince ipliksi korozyon\n\n**Derecelendirme (severity):**\n• Level 1 — yüzeysel, temizlenebilir\n• Level 2 — derinlemesine, onarım gerektirir\n• Level 3 — yapısal etkisi var, parça değişimi gerekebilir\n\n**Rapor ifadesi:**\n"Corrosion found on [component]. Type: [pitting/surface]. Extent: [area in cm²]. Depth: [mm]. Level: [1/2/3]. Action taken: [clean and treat / blend / replace]."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -248,
            category: QuestionCategory.reading,
            originalNumber: 2118,
            questionText: '"Galvanic corrosion" occurs when:',
            options: [
              'metal is exposed to high temperature',
              'two dissimilar metals are in electrical contact in the presence of an electrolyte',
              'tensile stress accelerates surface pitting',
              'paint is applied over a corroded surface',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -249,
            category: QuestionCategory.reading,
            originalNumber: 2119,
            questionText: 'A corrosion report stating "Level 3" indicates:',
            options: [
              'surface corrosion that can be cleaned',
              'minor pitting requiring only treatment',
              'structural impact likely requiring part replacement',
              'cosmetic paint damage only',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _amt11NdtTerms = LessonContent(
    id: 'amt_11',
    title: 'NDT Terminolojisi',
    subtitle: 'Tahribatsız muayene yöntemleri ve raporlama dili',
    categoryId: 'vocabulary',
    estimatedTime: '12 dk',
    emoji: '📡',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'NDT nedir?',
        body:
            '**NDT** (Non-Destructive Testing / Tahribatsız Muayene), parçayı bozmadan veya değiştirmeden iç ve yüzey kusurlarını tespit etmek için kullanılan muayene yöntemlerinin genel adıdır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'NDT Yöntemleri',
        body:
            '**VT** — Visual Testing: doğrudan veya dolaylı görsel muayene\n**PT** — Penetrant Testing: yüzey çatlaklarında floresan boya kullanımı\n**MT** — Magnetic Particle Testing: manyetik malzemelerde yüzey ve yüzey altı kusurları\n**UT** — Ultrasonic Testing: ses dalgaları ile iç kusur tespiti; thickness measurement\n**ET** — Eddy Current Testing: elektrik iletken malzemelerde yüzey/yüzey altı\n**RT** — Radiographic Testing: X-ışını veya gama ışınıyla iç yapı görüntüleme\n**Borescope** — optik cihazla motor iç kanallarını inceleme\n\n**Rapor ifadeleri:**\n"No cracks, corrosion, or other defects noted."\n"Indication found at [location]. Further evaluation required."\n"Part accepted / rejected in accordance with engineering data."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -250,
            category: QuestionCategory.vocabulary,
            originalNumber: 2120,
            questionText: '"Eddy Current Testing" (ET) is most useful for detecting defects in:',
            options: [
              'non-metallic composite structures',
              'electrically conductive materials such as aluminium',
              'fuel system rubber seals',
              'hydraulic fluid contamination',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -251,
            category: QuestionCategory.vocabulary,
            originalNumber: 2121,
            questionText: 'In an NDT report, "no indication found" means:',
            options: [
              'the test was not performed',
              'no defect signal was detected',
              'results are inconclusive',
              'the part must be replaced',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _amt12HydraulicSystem = LessonContent(
    id: 'amt_12',
    title: 'Hidrolik Sistem Dili',
    subtitle: 'Hydraulic system bakım ve arıza terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '11 dk',
    emoji: '💧',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Hidrolik sistemler neden kritiktir?',
        body:
            'Uçağın kontrol yüzeyleri, iniş takımı ve frenler hidrolik sistemle çalışır. Bu sistemin bakım dilini bilmek, AMM talimatlarını doğru okumak için şarttır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Hidrolik Terminoloji',
        body:
            '**Temel bileşenler:**\n• Hydraulic reservoir — depo\n• Hydraulic pump (engine-driven / electric) — pompa\n• Pressure relief valve — basınç tahliye valfi\n• Actuator — aktüatör (silindir)\n• Selector valve — seçici valf\n• Accumulator — akümülatör (basınç depolamak için)\n• Filter element — filtre elemanı\n\n**Arıza terimleri:**\n• External leakage — dış sızıntı (görünür)\n• Internal leakage — iç sızıntı (pistondan bypass)\n• Low pressure — düşük basınç (pump, filter, leak)\n• Aeration — sıvıya hava karışması (köpük)\n• Contamination — kirlilik (parçacık, su)\n\n**AMM talimat ifadeleri:**\n"Depressurise hydraulic system before maintenance."\n"Bleed air from system after component replacement."\n"Check fluid level at [COLD/HOT] indication on sight glass."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -252,
            category: QuestionCategory.vocabulary,
            originalNumber: 2122,
            questionText: '"Depressurise hydraulic system before maintenance" means:',
            options: [
              'turn on the hydraulic pump',
              'relieve accumulated hydraulic pressure before working on the system',
              'add hydraulic fluid before starting work',
              'run a ground check to verify pressure',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -253,
            category: QuestionCategory.vocabulary,
            originalNumber: 2123,
            questionText: '"Aeration" in a hydraulic system indicates:',
            options: [
              'correct fluid viscosity',
              'air bubbles mixed with hydraulic fluid, causing foaming',
              'normal fluid circulation',
              'high fluid temperature',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _amt13AvionicsTroubleshooting = LessonContent(
    id: 'amt_13',
    title: 'Aviyonik Arıza Giderme Dili',
    subtitle: 'BITE, fault codes ve aviyonik troubleshooting terminolojisi',
    categoryId: 'reading',
    estimatedTime: '13 dk',
    emoji: '💻',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Modern aviyonik sistemler',
        body:
            'Modern uçaklarda aviyonik sistemler kendi kendini test edebilen (BITE — Built-In Test Equipment) özelliğe sahiptir. AMT\'nin bu sistemlerin çıktılarını anlayabilmesi ve arıza giderimini doğru belgelemesi gerekir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Aviyonik Terminoloji',
        body:
            '**BITE** — Built-In Test Equipment: sistem içindeki otomatik test fonksiyonu\n**Fault code / fault message** — arıza kodu veya mesajı\n**LRU** — Line Replaceable Unit: sahada değiştirilebilen en küçük birim\n**Intermittent fault** — aralıklı arıza (sürekli tekrarlamayan)\n**Confirmed fault** — doğrulanmış arıza (BITE sürekli kayıt ediyor)\n**NFF** — No Fault Found: LRU değiştirildi fakat arıza bulunamadı\n**ACMS** — Aircraft Condition Monitoring System\n**DFDR** — Digital Flight Data Recorder verisi\n\nTroubleshooting ifadeleri:\n"Access BITE menu on MCDU and retrieve active faults."\n"Fault confirmed: [LRU name] faulty. Replace LRU in accordance with AMM."\n"No fault found after LRU replacement. Monitor for recurrence."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -254,
            category: QuestionCategory.reading,
            originalNumber: 2124,
            questionText: '"NFF — No Fault Found" after LRU replacement means:',
            options: [
              'the fault has been permanently resolved',
              'the replaced LRU was defective',
              'no defect was detected in the removed unit during bench test',
              'the BITE system is faulty',
            ],
            correctIndex: 2,
            difficulty: Difficulty.hard,
          ),
          QuestionModel(
            id: -255,
            category: QuestionCategory.reading,
            originalNumber: 2125,
            questionText: 'An "intermittent fault" in avionics means the fault:',
            options: [
              'is permanently active and easy to reproduce',
              'appears and disappears without a clear pattern',
              'was found only in the BITE test, not in flight',
              'requires immediate AOG action',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _amt14PartsLogistics = LessonContent(
    id: 'amt_14',
    title: 'Yedek Parça ve Lojistik Dili',
    subtitle: 'Part number, serviceable tag ve parça sipariş terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '10 dk',
    emoji: '📦',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Yedek parça yönetimi',
        body:
            'AMT, bakım sırasında doğru parçayı tespit etmek, sipariş etmek ve teslim alırken kontrol etmek zorundadır. Bu sürecin her adımında belirli bir terminoloji kullanılır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Parça Terminolojisi',
        body:
            '**P/N** — Part Number: parça numarası\n**S/N** — Serial Number: seri numarası\n**Batch/Lot Number** — seri üretim parti numarası\n**Serviceable tag (Form 1 / 8130-3)** — parçanın uçuşa elverişli olduğunu gösteren belge\n— EASA Form 1, FAA 8130-3\n**Unserviceable tag** — kullanılamaz etiketi\n**Shelf life** — raf ömrü\n**Cure date** — üretim tarihi (lastik, conta için)\n**Overhaul (OH)** — revizyon\n**Serviceable (SVC)** — uçuşa elverişli\n**Beyond Economical Repair (BER)** — ekonomik onarım sınırını aşmış\n\nİfadeler:\n"Verify P/N and S/N before installation."\n"Ensure valid EASA Form 1 accompanies the part."\n"Check shelf life has not expired prior to installation."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -256,
            category: QuestionCategory.vocabulary,
            originalNumber: 2126,
            questionText: 'An "EASA Form 1" accompanying a spare part certifies that:',
            options: [
              'the part is in unserviceable condition',
              'the part has been released as airworthy by an approved organisation',
              'the part has been removed from a scrapped aircraft',
              'the part requires further inspection before installation',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -257,
            category: QuestionCategory.vocabulary,
            originalNumber: 2127,
            questionText: '"Shelf life expired" for a rubber seal means:',
            options: [
              'the seal has been installed too long',
              'the seal cannot be used because its guaranteed service period has passed',
              'the seal must be returned to the manufacturer',
              'the seal requires a functional test before use',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _amt15CertificationRelease = LessonContent(
    id: 'amt_15',
    title: 'Sertifikasyon ve Servise Verme Dili',
    subtitle: 'CRS, Part-145 ve release to service terminolojisi',
    categoryId: 'fill',
    estimatedTime: '12 dk',
    emoji: '✅',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Servise verme sertifikası',
        body:
            '**Certificate of Release to Service (CRS)**, bir bakım görevinin tamamlandıktan sonra yetkili kişi tarafından imzalanması gereken belgedir. Bu belge olmadan uçak uçuşa alınamaz.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'CRS Dili',
        body:
            '**Standart CRS ifadesi (Part-145):**\n"Certifies that the work specified in this order has been carried out in accordance with Part-145 and in respect to that work the aircraft/aircraft component is considered ready for release to service."\n\n**Anahtar ifadeler:**\n• "released to service" — servise verildi\n• "in accordance with" (IAW) — uygun olarak\n• "approved data" — onaylı veri\n• "authorised certifying staff" — yetkili sertifikasyon personeli\n• "limitations as specified" — belirtilen sınırlamalar dahilinde\n\n**Sınırlı release:**\n"Aircraft released to service with defect [X] deferred under MEL item [Y]."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -258,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2128,
            questionText: '"The work has been carried out ………… Part-145 approved data."',
            options: ['following', 'in accordance with', 'as per to', 'according'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -259,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2129,
            questionText: '"Aircraft ………… to service." (CRS sonunda yazılan standart ifade)',
            options: ['returned', 'cleared', 'released', 'approved'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -260,
            category: QuestionCategory.fillBlanks,
            originalNumber: 2130,
            questionText: '"Only ………… certifying staff may sign the CRS."',
            options: ['senior', 'experienced', 'authorised', 'licensed'],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _amt16FuelSystem = LessonContent(
    id: 'amt_16',
    title: 'Yakıt Sistemi Dili',
    subtitle: 'Fuel system bakım, sızıntı ve tank terminolojisi',
    categoryId: 'vocabulary',
    estimatedTime: '11 dk',
    emoji: '⛽',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Yakıt sistemi bakımı',
        body:
            'Yakıt sistemi arızaları uçak güvenliğini doğrudan etkiler. AMT\'nin yakıt sistemi terminolojisini iyi bilmesi hem bakım sırasında hem de raporlamada kritik önem taşır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yakıt Sistemi Terminolojisi',
        body:
            '**Bileşenler:**\n• Fuel tank (integral/bladder/pod) — yakıt tankı\n• Boost pump — takviye pompası\n• Cross-feed valve — çapraz besleme valfi\n• Fuel quantity indication (FQI) — yakıt miktarı göstergesi\n• Fuel filter / strainer — yakıt filtresi\n• Fuel vent system — yakıt havalandırma sistemi\n• Refuelling / defuelling — yakıt ikmali / tahliyesi\n\n**Arıza/Sızıntı terimleri:**\n• Stain — leke (aktif sızıntı değil)\n• Seep — yavaş, hafif sızıntı (≤ 1 damla/dk)\n• Heavy seep — orta sızıntı (1-30 damla/dk)\n• Running leak — akma (> 30 damla/dk, acil işlem gerekir)\n\n**AMM ifadesi:**\n"Fuel tank entry requires hot work permit and confined space authorisation."\n"All fuel must be defuelled before sealant application."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -261,
            category: QuestionCategory.vocabulary,
            originalNumber: 2131,
            questionText: 'A "running leak" in the fuel system indicates:',
            options: [
              'a dry stain with no active flow',
              'a slow seep under 1 drop per minute',
              'active fuel flow exceeding 30 drops per minute requiring immediate action',
              'fuel tank vapour pressure build-up',
            ],
            correctIndex: 2,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -262,
            category: QuestionCategory.vocabulary,
            originalNumber: 2132,
            questionText: '"Fuel tank entry" requires:',
            options: [
              'only a standard work order',
              'hot work permit and confined space authorisation',
              'captain\'s approval',
              'no special authorisation if the aircraft is defuelled',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _amt17LandingGear = LessonContent(
    id: 'amt_17',
    title: 'İniş Takımı Sistemi Dili',
    subtitle: 'Landing gear, brake ve shimmy terminolojisi',
    categoryId: 'reading',
    estimatedTime: '12 dk',
    emoji: '🛬',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'İniş takımı bakımı',
        body:
            'İniş takımı, her iniş ve kalkışta büyük kuvvetlere maruz kalan kritik bir yapıdır. Periyodik muayenelerin ve arıza giderimlerinin doğru belgelenmesi zorunludur.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'İniş Takımı Terminolojisi',
        body:
            '**Yapısal bileşenler:**\n• Shock strut (oleo) — amortisör\n• Torque link — döndürme bağlantısı\n• Drag brace / side brace — geri çekilme kolu\n• Wheel well — iniş takımı yuvası\n• Down lock / up lock — açık/kapalı kilitleme\n• Squat switch — yere baskı şalteri\n\n**Fren sistemi:**\n• Anti-skid system — kayma önleme sistemi\n• Brake pressure — fren basıncı\n• Brake wear indicator — fren aşınma göstergesi\n• Hydraulic brake unit — hidrolik fren birimi\n\n**Arızalar:**\n• Shimmy — tekerlek titreşimi (yatay düzlem)\n• Gear not down and locked — iniş takımı inmiş-kilitli değil\n• Hydraulic fluid on gear — iniş takımında hidrolik sızıntı\n• Flat spot — düz nokta (kayma sonucu tekerlek aşınması)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -263,
            category: QuestionCategory.reading,
            originalNumber: 2133,
            questionText: '"Shimmy" in landing gear terminology refers to:',
            options: [
              'the extension speed of the landing gear',
              'an abnormal lateral (sideways) wheel vibration',
              'hydraulic pressure fluctuation during extension',
              'a brake system pressure warning',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -264,
            category: QuestionCategory.reading,
            originalNumber: 2134,
            questionText: 'The "squat switch" on an aircraft is used to:',
            options: [
              'indicate that the landing gear is fully retracted',
              'detect whether the aircraft is on the ground (weight on wheels)',
              'measure tyre pressure',
              'control anti-skid braking',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -265,
            category: QuestionCategory.reading,
            originalNumber: 2135,
            questionText: '"Flat spot" on a tyre is most commonly caused by:',
            options: [
              'over-inflation',
              'wheel lock-up during braking (skidding)',
              'hard landing impact',
              'prolonged parking on a hot surface',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  // ── DIALOGUE LESSONS ────────────────────────────────────────────────────────

  static const _pilotDlg1 = LessonContent(
    id: 'pilot_dlg_1',
    title: 'Kalkış İzni: ATC ↔ Pilot',
    subtitle: 'Gerçek radyo iletişimi — departure clearance diyaloğu',
    categoryId: 'phraseology',
    estimatedTime: '8 dk',
    emoji: '🗼',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Kalkış İzni Nedir?',
        body:
            'Kalkış öncesi pilot, ATC\'den **departure clearance** (kalkış izni) alır. Bu iletişim, standart ICAO phraseology ile gerçekleşir ve pilot her talimatı **readback** (tekrar okuma) ile onaylar.\n\n'
            'Bu derste gerçek bir kalkış iznini adım adım dinleyecek ve ifadeleri öğreneceksin.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Readback Kuralı',
        body:
            'Pilot, ATC\'nin talimatını **aynen tekrar etmek** zorundadır:\n\n'
            '**ATC:** "THY123, cleared to Istanbul, runway 36L, squawk 2341."\n'
            '**PILOT:** "Cleared to Istanbul, runway 36L, squawk 2341, THY123."\n\n'
            '• Uçuş numarası sona eklenir\n'
            '• Rakamlar tek tek okunur: **2341 → two three four one**\n'
            '• "Runway" yerine sadece numara: **"three six left"**',
      ),
      LessonSection(
        type: LessonSectionType.dialogue,
        title: 'Kalkış İzni — LTBA Yer Kontrolü',
        body: 'Uçuş: THY123 · Rota: LTBA → LTFM · Pistler: 36L',
        dialogueLines: [
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Istanbul Clearance, Turkish 123, request IFR clearance to Istanbul Sabiha, information Bravo.',
            translation: 'İstanbul Yer Kontrolü, Turkish 123, İstanbul Sabiha\'ya IFR izni talep ediyorum, Bravo bilgisini aldım.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Turkish 123, cleared to Istanbul Sabiha airport via IXU1B departure, climb initially to flight level 100, squawk 2341.',
            translation: 'Turkish 123, İstanbul Sabiha havalimanına IXU1B kalkış prosedürü ile kalkış izni verildi, başlangıçta FL100\'e tırman, transponder 2341.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Cleared to Istanbul Sabiha, IXU1B departure, climb flight level 100, squawk 2341, Turkish 123.',
            translation: 'İstanbul Sabiha\'ya, IXU1B kalkış, FL100\'e tırmanış, transponder 2341, Turkish 123.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Turkish 123, readback correct. Contact ground 121.8, good day.',
            translation: 'Turkish 123, tekrar okumanız doğru. Yer kontrolü 121.8\'i arayın, güle güle.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Ground 121.8, Turkish 123, good day.',
            translation: 'Yer kontrolü 121.8, Turkish 123, güle güle.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Temel Readback İfadeleri',
        examples: [
          ExampleSentence(sentence: 'Cleared to [destination] via [route].', translation: '[Varış noktasına] [rota] üzerinden kalkış izni verildi.', highlight: 'Cleared to'),
          ExampleSentence(sentence: 'Climb initially to flight level [X].', translation: 'Başlangıçta FL[X]\'e tırman.', highlight: 'Climb initially'),
          ExampleSentence(sentence: 'Squawk [code].', translation: 'Transponder kodu [kod].', highlight: 'Squawk'),
          ExampleSentence(sentence: 'Readback correct, contact [frequency].', translation: 'Tekrar okumanız doğru, [frekans]\'ı arayın.', highlight: 'Readback correct'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Sınav İpucu',
        body:
            'ICAO sınavında sık sorulan: **"What should a pilot do after receiving a clearance?"**\n\n'
            'Cevap: **Read back all items** of the clearance correctly and in the same sequence.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -300,
            category: QuestionCategory.grammar,
            originalNumber: 3000,
            questionText: 'A pilot receives: "Cleared to Berlin, squawk 4521." The correct readback is:',
            options: [
              '"Cleared to Berlin, squawk 4521, [callsign]."',
              '"Roger, understood."',
              '"Affirmative, Berlin."',
              '"Copy that, 4521."',
            ],
            correctIndex: 0,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -301,
            category: QuestionCategory.grammar,
            originalNumber: 3001,
            questionText: 'In ICAO phraseology, "Readback correct" means:',
            options: [
              'The pilot has made an error in readback',
              'The controller confirms the pilot repeated the clearance accurately',
              'The pilot should read back again',
              'The clearance has been changed',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -302,
            category: QuestionCategory.grammar,
            originalNumber: 3002,
            questionText: 'How is squawk code "2341" spoken in radio communication?',
            options: [
              '"Two thousand three hundred forty-one"',
              '"Two three four one"',
              '"Twenty-three forty-one"',
              '"Code 2341"',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -303,
            category: QuestionCategory.grammar,
            originalNumber: 3003,
            questionText: '"Climb initially to flight level 100" means:',
            options: [
              'Climb to 100 feet',
              'Climb to 10,000 feet as the first assigned altitude',
              'Climb at 100 feet per minute',
              'The final cruise altitude is FL100',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _pilotDlg2 = LessonContent(
    id: 'pilot_dlg_2',
    title: 'MAYDAY Çağrısı: Acil Durum İletişimi',
    subtitle: 'Engine failure — gerçek acil durum diyaloğu',
    categoryId: 'phraseology',
    estimatedTime: '10 dk',
    emoji: '🚨',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'MAYDAY — En Yüksek Acil Seviyesi',
        body:
            '**MAYDAY**, can güvenliğini tehdit eden ciddi acil durumlarda kullanılan uluslararası distress çağrısıdır. Üç kez tekrarlanır.\n\n'
            '• **MAYDAY MAYDAY MAYDAY** → Hayati tehlike\n'
            '• **PAN-PAN PAN-PAN PAN-PAN** → Acil durum (hayati tehlike yok)\n\n'
            'Bu derste bir motor arızasında kule ile pilot arasındaki iletişimi inceleyeceksin.',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'MAYDAY vs PAN-PAN',
        animationType: GrammarAnimationType.compareContrast,
        contrastPair: ContrastPair(
          leftLabel: 'MAYDAY',
          rightLabel: 'PAN-PAN',
          leftColor: Color(0xFFDC2626),
          rightColor: Color(0xFFD97706),
          leftEmoji: '🚨',
          rightEmoji: '⚠️',
          rows: [
            ('Can tehlikesi — hayati tehdit', 'Acil durum — hayati tehdit YOK'),
            ('"MAYDAY MAYDAY MAYDAY"', '"PAN-PAN PAN-PAN PAN-PAN"'),
            ('Motor yangını, çarpışma, yapısal hasar', 'Yakıt azlığı, tıbbi durum, mekanik arıza'),
            ('En yüksek öncelik — tüm trafik kesilir', 'Yüksek öncelik — diğer trafik devam eder'),
            ('Fransızca: "m\'aider" → yardım et', 'Fransızca: "panne" → arıza/duruş'),
          ],
        ),
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'MAYDAY Formatı',
        body:
            'MAYDAY çağrısında 7 bilgi verilir:\n\n'
            '1. **MAYDAY MAYDAY MAYDAY**\n'
            '2. Muhatap birim: *"[Station name]"*\n'
            '3. Uçak adı: *"[Aircraft callsign]"*\n'
            '4. Acil durum türü: *"Engine failure"*\n'
            '5. Pilot niyeti: *"Declaring emergency, requesting vectors to nearest airport"*\n'
            '6. Mevcut pozisyon/irtifa: *"FL220, 40 miles east of Istanbul"*\n'
            '7. Diğer bilgiler: *"Souls on board: 189, fuel: 2 hours"*',
      ),
      LessonSection(
        type: LessonSectionType.dialogue,
        title: 'Motor Arızası — Acil İniş',
        body: 'Uçuş: THY456 · FL220 · Motor 2 arızası',
        dialogueLines: [
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'MAYDAY MAYDAY MAYDAY, Istanbul Radar, Turkish 456, engine number two failure, declaring emergency, request immediate descent and vectors to nearest suitable airport.',
            translation: 'MAYDAY MAYDAY MAYDAY, İstanbul Radar, Turkish 456, motor iki arızası, acil durum ilan ediyorum, en yakın uygun havalimanına acil iniş ve yönlendirme talep ediyorum.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Turkish 456, MAYDAY acknowledged. Turn left heading 270, descend flight level 100, Istanbul Atatürk is 35 miles to your west. Emergency services alerted.',
            translation: 'Turkish 456, MAYDAY alındı. Sola 270 dereceye dön, FL100\'e alçal, İstanbul Atatürk batında 35 mil. Acil servisler uyarıldı.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Left heading 270, descending flight level 100, Turkish 456. Souls on board 189, fuel endurance 2 hours.',
            translation: 'Sola 270 derece, FL100\'e alçalıyor, Turkish 456. Uçaktaki kişi sayısı 189, yakıt süresi 2 saat.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Turkish 456, roger. You are cleared direct Istanbul, descend altitude 3000 feet, QNH 1013. Runway 05 available, ILS approach.',
            translation: 'Turkish 456, anlaşıldı. Doğruca İstanbul\'a izinlisiniz, 3000 feet\'e alçalın, QNH 1013. Pist 05 hazır, ILS yaklaşması.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Direct Istanbul, altitude 3000 feet, QNH 1013, runway 05, Turkish 456. Request crash and fire services on standby.',
            translation: 'Doğruca İstanbul, 3000 feet, QNH 1013, pist 05, Turkish 456. Kaza ve yangın ekiplerinin hazır beklemesini talep ediyoruz.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Turkish 456, crash and fire services on standby runway 05. You are cleared ILS approach runway 05. Report established.',
            translation: 'Turkish 456, kaza ve yangın ekipleri pist 05\'te hazır bekliyor. Pist 05 ILS yaklaşmasına izinlisiniz. Lokalizatöre girdiğinizde bildirin.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Acil Durum İfadeleri',
        examples: [
          ExampleSentence(sentence: 'Declaring emergency, [reason].', translation: 'Acil durum ilan ediyorum, [sebep].', highlight: 'Declaring emergency'),
          ExampleSentence(sentence: 'Request immediate descent and vectors.', translation: 'Acil iniş ve yönlendirme talep ediyorum.', highlight: 'Request immediate'),
          ExampleSentence(sentence: 'Souls on board [number], fuel endurance [time].', translation: 'Uçaktaki kişi sayısı [sayı], yakıt süresi [süre].', highlight: 'Souls on board'),
          ExampleSentence(sentence: 'Request crash and fire services on standby.', translation: 'Kaza ve yangın ekiplerinin hazır beklemesini talep ediyoruz.', highlight: 'crash and fire services'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '🚨 Sınav İpucu',
        body:
            'ICAO sınavında **MAYDAY vs PAN-PAN** farkı sık sorulur:\n\n'
            '• **MAYDAY** = imminent danger to life (can tehlikesi mevcut)\n'
            '• **PAN-PAN** = urgency, no immediate danger to life (acil ama hayati tehlike yok)\n\n'
            'Örnek: Yakıt azlığı → **PAN-PAN** | Motor yangını → **MAYDAY**',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -304,
            category: QuestionCategory.grammar,
            originalNumber: 3004,
            questionText: 'How many times is "MAYDAY" repeated at the beginning of a distress call?',
            options: ['Once', 'Twice', 'Three times', 'As many times as needed'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -305,
            category: QuestionCategory.grammar,
            originalNumber: 3005,
            questionText: '"Souls on board" refers to:',
            options: ['Number of passengers only', 'Total number of people on the aircraft', 'Number of crew members', 'Number of conscious people'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -306,
            category: QuestionCategory.grammar,
            originalNumber: 3006,
            questionText: 'A pilot experiences cabin depressurization with no immediate threat to life. The correct call is:',
            options: ['MAYDAY MAYDAY MAYDAY', 'PAN-PAN PAN-PAN PAN-PAN', 'EMERGENCY EMERGENCY', 'DISTRESS DISTRESS'],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -307,
            category: QuestionCategory.grammar,
            originalNumber: 3007,
            questionText: '"Crash and fire services on standby" means:',
            options: [
              'A crash has already occurred',
              'Fire trucks and rescue teams are ready at the airport in case of incident',
              'The aircraft must land immediately',
              'The runway is closed for other traffic',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _pilotDlg3 = LessonContent(
    id: 'pilot_dlg_3',
    title: 'Yaklaşma ve İniş: Approach ↔ Pilot',
    subtitle: 'ILS yaklaşması, irtifa bildirimleri ve iniş izni',
    categoryId: 'phraseology',
    estimatedTime: '9 dk',
    emoji: '🛬',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'İniş Yaklaşması Süreci',
        body:
            'Iniş yaklaşmasında pilot **Approach Control** ve ardından **Tower** ile iletişim kurar. Süreç:\n\n'
            '1. **Approach** frekansına geçiş\n'
            '2. Pozisyon ve irtifa bildirimi\n'
            '3. ILS frekansı ve pist bilgisi\n'
            '4. **Tower** frekansına geçiş\n'
            '5. İniş izni ve **"cleared to land"**',
      ),
      LessonSection(
        type: LessonSectionType.dialogue,
        title: 'ILS Yaklaşması — İstanbul',
        body: 'Uçuş: THY789 · Yaklaşma pistı: 36R · QNH: 1015',
        dialogueLines: [
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Istanbul Approach, Turkish 789, passing flight level 120, descending to 4000 feet, information Charlie.',
            translation: 'İstanbul Yaklaşma, Turkish 789, FL120\'den geçiyor, 4000 feet\'e alçalıyor, Charlie bilgisini aldım.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Turkish 789, Istanbul Approach, radar contact. Descend altitude 3000 feet, QNH 1015. Expect ILS approach runway 36 right.',
            translation: 'Turkish 789, İstanbul Yaklaşma, radar teması kuruldu. 3000 feet\'e alçal, QNH 1015. Pist 36 sağ ILS yaklaşması bekleniyor.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Descend 3000 feet, QNH 1015, Turkish 789. Request ILS frequency for runway 36 right.',
            translation: '3000 feet\'e alçal, QNH 1015, Turkish 789. Pist 36 sağ ILS frekansını talep ediyorum.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Turkish 789, ILS 36R frequency 109.5. Turn left heading 060, intercept localizer. Report established.',
            translation: 'Turkish 789, ILS 36R frekansı 109.5. Sola 060 dereceye dön, lokalizatörü kesmek için. Kurulduğunuzda bildirin.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Left heading 060, Turkish 789. Established ILS runway 36 right.',
            translation: 'Sola 060 derece, Turkish 789. Pist 36 sağ ILS\'e kuruldu.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Turkish 789, contact Istanbul Tower 118.1. Good day.',
            translation: 'Turkish 789, İstanbul Kule 118.1\'i arayın. Güle güle.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Istanbul Tower, Turkish 789, ILS runway 36 right, fully established.',
            translation: 'İstanbul Kule, Turkish 789, pist 36 sağ ILS\'e tam olarak kuruldu.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Turkish 789, wind 350 degrees 12 knots, runway 36 right, cleared to land.',
            translation: 'Turkish 789, rüzgar 350 derece 12 knot, pist 36 sağ, iniş izni verildi.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Cleared to land, runway 36 right, Turkish 789.',
            translation: 'İniş izni, pist 36 sağ, Turkish 789.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Yaklaşma İfadeleri',
        examples: [
          ExampleSentence(sentence: 'Radar contact. Descend altitude [X] feet, QNH [Y].', translation: 'Radar teması. [X] feet\'e alçal, QNH [Y].', highlight: 'Radar contact'),
          ExampleSentence(sentence: 'Report established [ILS/VOR approach].', translation: '[ILS/VOR] yaklaşmasına kurulduğunuzda bildirin.', highlight: 'Report established'),
          ExampleSentence(sentence: 'Wind [direction] degrees [speed] knots, cleared to land.', translation: 'Rüzgar [yön] derece [hız] knot, iniş izni verildi.', highlight: 'cleared to land'),
          ExampleSentence(sentence: 'Go around, I say again, go around.', translation: 'Alçalışı kes, tekrar ediyorum, alçalışı kes.', highlight: 'Go around'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -308,
            category: QuestionCategory.grammar,
            originalNumber: 3008,
            questionText: '"Cleared to land" is given by:',
            options: ['Approach Control', 'Tower Control', 'Ground Control', 'Area Control Centre'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -309,
            category: QuestionCategory.grammar,
            originalNumber: 3009,
            questionText: '"Report established" means the pilot should report when:',
            options: [
              'The aircraft reaches cruise altitude',
              'The aircraft has intercepted and is tracking the ILS localizer/glideslope',
              'The aircraft has landed',
              'The pilot has received the ATIS information',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -310,
            category: QuestionCategory.grammar,
            originalNumber: 3010,
            questionText: 'What does "Go around" instruct the pilot to do?',
            options: [
              'Circle the airport at holding altitude',
              'Abort the landing approach and climb away',
              'Reduce speed and extend flaps',
              'Contact tower on a different frequency',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -311,
            category: QuestionCategory.grammar,
            originalNumber: 3011,
            questionText: 'QNH refers to:',
            options: [
              'The wind speed at ground level',
              'The altimeter setting to indicate altitude above mean sea level',
              'The runway visual range',
              'The ILS glideslope frequency',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _cabinDlg1 = LessonContent(
    id: 'cabin_dlg_1',
    title: 'Turbülans: Kabin ↔ Yolcu',
    subtitle: 'Yolcu sakinleştirme ve güvenlik talimatları',
    categoryId: 'phraseology',
    estimatedTime: '8 dk',
    emoji: '🌩️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Turbülansta Kabin Yönetimi',
        body:
            'Turbülans anında kabin görevlisi **hem yolcuları sakinleştirmeli** hem de **güvenlik talimatlarını net biçimde iletmelidir**. İletişim tonu:\n\n'
            '• **Sakin ama otoriter** — panik yaratmadan net talimat\n'
            '• **Basit ve anlaşılır İngilizce** — yolcunun anlayacağı kelimeler\n'
            '• **Empatik** — yolcunun korkusunu onaylamak',
      ),
      LessonSection(
        type: LessonSectionType.dialogue,
        title: 'Ciddi Turbülans Anında',
        body: 'Uçuş sırasında beklenmeyen ciddi turbülans',
        dialogueLines: [
          DialogueLine(
            speaker: DialogueSpeaker.captain,
            text: 'Cabin crew, be seated immediately.',
            translation: 'Kabin ekibi, hemen oturun.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.cabin,
            text: 'Ladies and gentlemen, the captain has switched on the fasten seatbelt sign. Please return to your seats and fasten your seatbelts immediately.',
            translation: 'Bayanlar ve baylar, kaptan emniyet kemeri işaretini yaktı. Lütfen hemen yerinize dönün ve emniyet kemerinizi bağlayın.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.passenger,
            text: 'Excuse me, is this dangerous? I\'m very scared.',
            translation: 'Affedersiniz, bu tehlikeli mi? Çok korkuyorum.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.cabin,
            text: 'I completely understand your concern. This is moderate turbulence — it is uncomfortable but completely safe. The aircraft is designed for this. Please keep your seatbelt fastened.',
            translation: 'Endişenizi çok iyi anlıyorum. Bu orta şiddette turbülans — rahatsız edici ama tamamen güvenli. Uçak bunun için tasarlanmış. Lütfen emniyet kemerinizi bağlı tutun.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.passenger,
            text: 'Can I go to the lavatory?',
            translation: 'Tuvalete gidebilir miyim?',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.cabin,
            text: 'I\'m sorry, that is not possible right now for your safety. Please remain seated with your seatbelt fastened until the sign is switched off.',
            translation: 'Üzgünüm, güvenliğiniz için şu an bu mümkün değil. İşaret söndürülene kadar lütfen emniyet kemerinizle oturmaya devam edin.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.cabin,
            text: 'Ladies and gentlemen, the fasten seatbelt sign has been switched off. You may move around the cabin, but we recommend keeping your seatbelt fastened while seated.',
            translation: 'Bayanlar ve baylar, emniyet kemeri işareti söndürüldü. Kabinde dolaşabilirsiniz, ancak oturduğunuzda emniyet kemerinizi bağlı tutmanızı öneririz.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Kabin Güvenlik İfadeleri',
        examples: [
          ExampleSentence(sentence: 'Please fasten your seatbelt immediately.', translation: 'Lütfen emniyet kemerinizi hemen bağlayın.', highlight: 'fasten your seatbelt'),
          ExampleSentence(sentence: 'This is [light/moderate/severe] turbulence.', translation: 'Bu [hafif/orta/şiddetli] turbülanstır.', highlight: 'turbulence'),
          ExampleSentence(sentence: 'The aircraft is designed for this condition.', translation: 'Uçak bu durum için tasarlanmıştır.', highlight: 'designed for'),
          ExampleSentence(sentence: 'Please remain seated until the sign is off.', translation: 'İşaret söndürülene kadar lütfen oturmaya devam edin.', highlight: 'remain seated'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -312,
            category: QuestionCategory.grammar,
            originalNumber: 3012,
            questionText: 'When the captain says "Cabin crew, be seated immediately," the crew should:',
            options: [
              'Continue service and then sit down',
              'Sit down immediately regardless of what they are doing',
              'Ask the captain for clarification',
              'Check the passengers first',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -313,
            category: QuestionCategory.grammar,
            originalNumber: 3013,
            questionText: '"Moderate turbulence" can be described to passengers as:',
            options: [
              '"Extremely dangerous, hold on tight"',
              '"Uncomfortable but completely safe — the aircraft is designed for this"',
              '"We may need to make an emergency landing"',
              '"Minor bumps that pose no risk whatsoever"',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -314,
            category: QuestionCategory.grammar,
            originalNumber: 3014,
            questionText: 'A passenger asks to use the lavatory during heavy turbulence. The best response is:',
            options: [
              '"Of course, go ahead."',
              '"I\'m sorry, for your safety please remain seated until the sign is off."',
              '"Wait 5 minutes and then go."',
              '"Only if you are quick."',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _cabinDlg2 = LessonContent(
    id: 'cabin_dlg_2',
    title: 'Tıbbi Acil: Kabin ↔ Kaptan',
    subtitle: 'Havada tıbbi acil durum yönetimi ve bildirim',
    categoryId: 'phraseology',
    estimatedTime: '9 dk',
    emoji: '🏥',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Havada Tıbbi Acil Durumlar',
        body:
            'Havada tıbbi acil durumda kabin görevlisi üç adımı hızla uygular:\n\n'
            '1. **İlk değerlendirme** — bilinci, solunumu, nabzı kontrol et\n'
            '2. **Kaptan bildirim** — belirlenen formatta bildir\n'
            '3. **Doktor çağrısı** — "Is there a doctor on board?"\n\n'
            'Kaptan, gerekirse **divert** (rota değişikliği) kararı verir.',
      ),
      LessonSection(
        type: LessonSectionType.dialogue,
        title: 'Yolcu Bayılma — Kabin ↔ Kokpit',
        body: 'Koltuk 24A yolcusu bilincini kaybetti',
        dialogueLines: [
          DialogueLine(
            speaker: DialogueSpeaker.cabin,
            text: 'Captain, this is the senior cabin crew. We have a medical situation in the cabin. Passenger in seat 24A is unconscious, unresponsive. CPR may be required.',
            translation: 'Kaptan, ben baş kabin görevlisiyim. Kabinde tıbbi bir durum var. 24A koltuğundaki yolcu bilinçsiz, yanıt vermiyor. CPR gerekebilir.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.captain,
            text: 'Understood. Is there a medical professional on board?',
            translation: 'Anlaşıldı. Uçakta tıbbi personel var mı?',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.cabin,
            text: 'We are asking now. Ladies and gentlemen, is there a doctor or medical professional on board? Please press the call button or come to seat 24A.',
            translation: 'Şu an soruyoruz. Bayanlar ve baylar, uçakta doktor veya tıbbi personel var mı? Lütfen çağrı butonuna basın veya 24A koltuğuna gelin.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.passenger,
            text: 'I\'m a cardiologist. I can help.',
            translation: 'Ben kardiyologum. Yardımcı olabilirim.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.cabin,
            text: 'Captain, we have a cardiologist assisting. Patient is breathing but unconscious. Doctor requests supplemental oxygen and medical kit.',
            translation: 'Kaptan, bir kardiyolog yardım ediyor. Hasta nefes alıyor ama bilinçsiz. Doktor ek oksijen ve tıbbi kit talep ediyor.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.captain,
            text: 'Roger. I am contacting medical ground support. Prepare for possible diversion. Keep me updated every 5 minutes.',
            translation: 'Anlaşıldı. Medikal yer desteğiyle iletişime geçiyorum. Olası rota değişikliğine hazırlanın. Her 5 dakikada güncelleyin.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.cabin,
            text: 'Understood. Captain, doctor advises diversion is necessary. Patient condition is deteriorating.',
            translation: 'Anlaşıldı. Kaptan, doktor rota değişikliğinin gerekli olduğunu söylüyor. Hastanın durumu kötüleşiyor.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.captain,
            text: 'Cabin crew, we are diverting to Ankara. ETA 25 minutes. Medical team will be at the gate.',
            translation: 'Kabin ekibi, Ankara\'ya sapıyoruz. Tahmini varış 25 dakika. Tıbbi ekip kapıda bekliyor olacak.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Tıbbi Acil İfadeleri',
        examples: [
          ExampleSentence(sentence: 'We have a medical situation in the cabin.', translation: 'Kabinde tıbbi bir durum var.', highlight: 'medical situation'),
          ExampleSentence(sentence: 'Is there a doctor or medical professional on board?', translation: 'Uçakta doktor veya tıbbi personel var mı?', highlight: 'doctor on board'),
          ExampleSentence(sentence: 'Patient is conscious/unconscious and breathing/not breathing.', translation: 'Hasta bilinçli/bilinçsiz ve nefes alıyor/almıyor.', highlight: 'conscious'),
          ExampleSentence(sentence: 'We are diverting to [airport]. ETA [X] minutes.', translation: '[Havalimanı]\'na sapıyoruz. Tahmini varış [X] dakika.', highlight: 'diverting'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -315,
            category: QuestionCategory.grammar,
            originalNumber: 3015,
            questionText: 'When reporting a medical situation to the captain, the cabin crew should include:',
            options: [
              'Only the passenger\'s name',
              'Seat number, patient condition, and what is needed',
              'A request to land immediately without explanation',
              'Only the doctor\'s assessment',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -316,
            category: QuestionCategory.grammar,
            originalNumber: 3016,
            questionText: '"Diversion" in this context means:',
            options: [
              'Entertainment system malfunction',
              'Changing the flight route to land at a different airport',
              'Passenger disturbance',
              'A detour to avoid weather',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -317,
            category: QuestionCategory.grammar,
            originalNumber: 3017,
            questionText: '"ETA" stands for:',
            options: ['Emergency Technical Alert', 'Estimated Time of Arrival', 'Engine Thrust Adjustment', 'Evacuation Team Alert'],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _amtDlg1 = LessonContent(
    id: 'amt_dlg_1',
    title: 'Arıza Teslimi: Teknisyen ↔ Kaptan',
    subtitle: 'Teknik arıza bildirimi ve aircraft release diyaloğu',
    categoryId: 'phraseology',
    estimatedTime: '9 dk',
    emoji: '🔧',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Uçuş Öncesi Teknik Teslim',
        body:
            'Bakım işlemi sonrasında teknisyen, uçağı **certify** ederek kaptana **release** (teslim) eder. Bu süreçte:\n\n'
            '• Yapılan iş açıkça tarif edilir\n'
            '• Herhangi bir **limitation** (kısıtlama) varsa bildirilir\n'
            '• **Certificate of Release to Service (CRS)** verilir\n\n'
            'Kaptan teknik günlüğü (technical log) imzalamadan önce soruları sorabilir.',
      ),
      LessonSection(
        type: LessonSectionType.dialogue,
        title: 'Hidrolik Arıza Sonrası Teslim',
        body: 'Uçuş öncesi apron — AMT kaptan ile buluşuyor',
        dialogueLines: [
          DialogueLine(
            speaker: DialogueSpeaker.amt,
            text: 'Good morning, Captain. I\'m the certifying engineer. I need to brief you on the maintenance carried out overnight.',
            translation: 'Günaydın Kaptan. Ben sertifika mühendisiyim. Geceyi kapsayan bakım hakkında sizi bilgilendirmem gerekiyor.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.captain,
            text: 'Good morning. What was the defect?',
            translation: 'Günaydın. Arıza neydi?',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.amt,
            text: 'We had a hydraulic fluid leak on the green system, identified at the actuator on the left main gear door. We replaced the actuator seal and re-sealed the line. System was pressure-tested and certified serviceable.',
            translation: 'Yeşil sistemde hidrolik sıvı kaçağı vardı, sol ana iniş takımı kapı aktüatöründe tespit edildi. Aktüatör contasını değiştirdik ve hattı yeniden sızdırmaz hale getirdik. Sistem basınç testine tabi tutuldu ve hizmete uygun olarak sertifikalandırıldı.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.captain,
            text: 'Any limitations or deferred items?',
            translation: 'Herhangi bir kısıtlama veya ertelenen iş var mı?',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.amt,
            text: 'No limitations. All systems are serviceable. The MEL item from yesterday — the reading light in seat 12B — has also been rectified.',
            translation: 'Kısıtlama yok. Tüm sistemler hizmete hazır. Dünden kalan MEL maddesi — 12B koltuğundaki okuma lambası — da giderildi.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.captain,
            text: 'Understood. What\'s the current hydraulic fluid level?',
            translation: 'Anlaşıldı. Mevcut hidrolik sıvı seviyesi ne?',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.amt,
            text: 'Green system is full — serviced to maximum per AMM 29-10-00. Total fluid added: 1.2 litres Skydrol LD-4.',
            translation: 'Yeşil sistem dolu — AMM 29-10-00\'a göre maksimum seviyeye servis yapıldı. Toplam eklenen sıvı: 1,2 litre Skydrol LD-4.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.captain,
            text: 'Good. I\'m satisfied. I\'ll sign the tech log now.',
            translation: 'Güzel. Tatmin oldum. Şimdi teknik günlüğü imzalayacağım.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.amt,
            text: 'Thank you, Captain. Certificate of Release to Service is on page 4. Safe flight.',
            translation: 'Teşekkürler Kaptan. Hizmete Verme Sertifikası 4. sayfada. İyi uçuşlar.',
            highlight: true,
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Teknik Teslim İfadeleri',
        examples: [
          ExampleSentence(sentence: 'We replaced the [component] and pressure-tested the system.', translation: '[Bileşeni] değiştirdik ve sistemi basınç testine tabi tuttuk.', highlight: 'replaced'),
          ExampleSentence(sentence: 'System was certified serviceable.', translation: 'Sistem hizmete uygun olarak sertifikalandırıldı.', highlight: 'certified serviceable'),
          ExampleSentence(sentence: 'No limitations, all systems are serviceable.', translation: 'Kısıtlama yok, tüm sistemler hizmete hazır.', highlight: 'serviceable'),
          ExampleSentence(sentence: 'Certificate of Release to Service is on page [X].', translation: 'Hizmete Verme Sertifikası [X]. sayfada.', highlight: 'Certificate of Release'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -318,
            category: QuestionCategory.translation,
            originalNumber: 3018,
            questionText: '"Any limitations or deferred items?" — what is the captain asking?',
            options: [
              'If the flight will be delayed',
              'If there are any operational restrictions or maintenance items postponed to a later date',
              'If the MEL book is on board',
              'If the maintenance was expensive',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -319,
            category: QuestionCategory.translation,
            originalNumber: 3019,
            questionText: '"Certificate of Release to Service (CRS)" means:',
            options: [
              'A document that records all flight hours',
              'A document issued by a certifying engineer confirming the aircraft is airworthy after maintenance',
              'A customs clearance document',
              'The aircraft\'s insurance certificate',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -320,
            category: QuestionCategory.translation,
            originalNumber: 3020,
            questionText: 'Translate: "System was pressure-tested and certified serviceable."',
            options: [
              'Sistem kontrol edildi ve devre dışı bırakıldı.',
              'Sistem basınç testine tabi tutuldu ve hizmete uygun olarak sertifikalandırıldı.',
              'Sistem basınç altında arızalandı.',
              'Sistem yeniden test edilmesi için beklemede.',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );

  static const _studentDlg1 = LessonContent(
    id: 'student_dlg_1',
    title: 'İlk Radyo Teması: Tower ↔ Pilot',
    subtitle: 'Temel ATC iletişimi — yeni başlayanlar için adım adım',
    categoryId: 'phraseology',
    estimatedTime: '7 dk',
    emoji: '📻',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Radyo İletişimine Giriş',
        body:
            'Pilotlar ATC ile **standart kelimeler** kullanarak iletişim kurar. Bu dilde:\n\n'
            '• Her kelime belirli anlam taşır — serbest konuşma yapılmaz\n'
            '• Sayılar tek tek okunur: **270 → "two seven zero"**\n'
            '• "Anlaşıldı" için **"Roger"** kullanılır\n'
            '• "Evet" için **"Affirm"**, "Hayır" için **"Negative"**\n\n'
            'Bu diyalogda temel kalkış hazırlığını adım adım göreceksin.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Temel Radyo Kelimeleri',
        body:
            '• **Roger** — mesajı aldım ve anladım\n'
            '• **Wilco** — aldım ve yapacağım (will comply)\n'
            '• **Affirm** — evet\n'
            '• **Negative** — hayır\n'
            '• **Say again** — tekrar et\n'
            '• **Stand by** — bekle\n'
            '• **Go ahead** — devam et, dinliyorum\n'
            '• **[Callsign] with you** — frekansa ilk çağrıda kullanılır',
      ),
      LessonSection(
        type: LessonSectionType.dialogue,
        title: 'Basit Kalkış — Kule İletişimi',
        body: 'Öğrenci pilotu ile kule arasındaki temel iletişim',
        dialogueLines: [
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Ankara Tower, Student 01, at the holding point runway 21, ready for departure.',
            translation: 'Ankara Kule, Student 01, pist 21 bekleme noktasında, kalkışa hazır.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Student 01, Ankara Tower, hold position. Traffic on final.',
            translation: 'Student 01, Ankara Kule, bekle. Finalden gelen trafik var.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Holding, Student 01.',
            translation: 'Bekliyoruz, Student 01.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Student 01, wind 210 degrees 8 knots, runway 21, cleared for takeoff.',
            translation: 'Student 01, rüzgar 210 derece 8 knot, pist 21, kalkış izni verildi.',
            highlight: true,
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Runway 21, cleared for takeoff, Student 01.',
            translation: 'Pist 21, kalkış izni, Student 01.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.atc,
            text: 'Student 01, after departure turn left heading 180, climb to 3000 feet.',
            translation: 'Student 01, kalkış sonrası sola 180 dereceye dön, 3000 feet\'e tırman.',
          ),
          DialogueLine(
            speaker: DialogueSpeaker.pilot,
            text: 'Left heading 180, climb 3000 feet, Student 01.',
            translation: 'Sola 180 derece, 3000 feet tırmanış, Student 01.',
          ),
        ],
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Temel Kalkış İfadeleri',
        examples: [
          ExampleSentence(sentence: 'Ready for departure.', translation: 'Kalkışa hazır.', highlight: 'Ready for departure'),
          ExampleSentence(sentence: 'Cleared for takeoff, runway [X].', translation: 'Pist [X], kalkış izni verildi.', highlight: 'Cleared for takeoff'),
          ExampleSentence(sentence: 'Hold position. Traffic on final.', translation: 'Bekle. Finalden gelen trafik var.', highlight: 'Hold position'),
          ExampleSentence(sentence: 'After departure turn [left/right] heading [X].', translation: 'Kalkış sonrası [sola/sağa] [X] dereceye dön.', highlight: 'After departure'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '✈️ Başlangıç İpucu',
        body:
            'Radyo iletişiminde en çok yapılan hata: **gereksiz kelime kullanmak**.\n\n'
            '❌ "Yes, I understand, we are going to hold, Student 01."\n'
            '✅ "Holding, Student 01."\n\n'
            'Kısa, net, standartta kal. **Less is more.**',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -321,
            category: QuestionCategory.grammar,
            originalNumber: 3021,
            questionText: '"Roger" in aviation communication means:',
            options: [
              '"I will comply with your instruction"',
              '"I have received and understood your message"',
              '"Yes, I agree"',
              '"Standby, I need to check"',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -322,
            category: QuestionCategory.grammar,
            originalNumber: 3022,
            questionText: 'How is the heading "270" spoken in radio communication?',
            options: ['"Two seventy"', '"Two hundred seventy"', '"Two seven zero"', '"Heading 270"'],
            correctIndex: 2,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -323,
            category: QuestionCategory.grammar,
            originalNumber: 3023,
            questionText: '"Cleared for takeoff" is given when:',
            options: [
              'The aircraft is ready to start engines',
              'The runway is free and the aircraft is authorized to take off',
              'The aircraft has received the ATIS information',
              'The squawk code has been assigned',
            ],
            correctIndex: 1,
            difficulty: Difficulty.easy,
          ),
        ],
      ),
    ],
  );

  static const _amt18SafetyMgmt = LessonContent(
    id: 'amt_18',
    title: 'Bakımda Güvenlik Yönetimi Dili',
    subtitle: 'SMS, hazard reporting ve toolbox talk terminolojisi',
    categoryId: 'translation',
    estimatedTime: '12 dk',
    emoji: '🛡️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Havacılık bakımında SMS',
        body:
            '**Safety Management System (SMS)**, havacılık kuruluşlarının güvenlik risklerini proaktif olarak yönetmesi için geliştirilen sistematik yaklaşımdır. AMT\'ler SMS süreçlerinin aktif katılımcılarıdır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'SMS Terminolojisi',
        body:
            '**Temel kavramlar:**\n• Hazard — tehlike (zarar vermek için potansiyel mevcut durum)\n• Risk — tehlikenin gerçekleşme olasılığı × sonucun şiddeti\n• Safety occurrence — güvenlik olayı\n• Near miss / close call — ramak kala (hasar olmaksızın gerçekleşen olay)\n• Root cause analysis — kök neden analizi\n• Corrective action — düzeltici faaliyet\n• Preventive action — önleyici faaliyet\n• Just culture — suçlama yerine öğrenmeyi hedefleyen kültür\n• Toolbox talk — bakım öncesi kısa güvenlik brifing\n\n**Hazard report ifadesi:**\n"I observed a potential hazard: [description]. Location: [X]. Risk level: [high/medium/low]. Recommended action: [X]."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik Sorular',
        practiceQuestions: [
          QuestionModel(
            id: -266,
            category: QuestionCategory.translation,
            originalNumber: 2136,
            questionText: 'Translate to Turkish: "A near miss should always be reported, even if no damage occurred."',
            options: [
              'Ramak kala olaylar, hasar meydana gelmese bile her zaman raporlanmalıdır.',
              'Hasar olmayan olaylar rapor edilmek zorunda değildir.',
              'Ramak kala olaylar yalnızca ciddi hasara yol açtığında raporlanır.',
              'Güvenlik olayları yalnızca kaza olduğunda kayıt altına alınır.',
            ],
            correctIndex: 0,
            difficulty: Difficulty.easy,
          ),
          QuestionModel(
            id: -267,
            category: QuestionCategory.translation,
            originalNumber: 2137,
            questionText: '"Just culture" in SMS means:',
            options: [
              'a culture of assigning blame for all safety errors',
              'a culture that encourages reporting by distinguishing between honest mistakes and negligence',
              'a culture where only management decides safety actions',
              'a legal term for fair compensation after accidents',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
          QuestionModel(
            id: -268,
            category: QuestionCategory.translation,
            originalNumber: 2138,
            questionText: '"Root cause analysis" aims to:',
            options: [
              'identify who is responsible for an accident',
              'find the underlying cause(s) of a safety occurrence to prevent recurrence',
              'document all damage caused by the occurrence',
              'report the occurrence to the aviation authority',
            ],
            correctIndex: 1,
            difficulty: Difficulty.medium,
          ),
        ],
      ),
    ],
  );
}
