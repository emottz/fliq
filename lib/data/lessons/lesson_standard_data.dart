import '../models/lesson_content_model.dart';
import '../models/question_model.dart';

/// Standart İngilizce dersleri — A1'den C1'e, havacılık bağlamıyla zenginleştirilmiş.
/// 36 ders: 8 Başlangıç · 8 Temel · 8 Orta · 12 İleri
class LessonStandardData {
  LessonStandardData._();

  static const List<LessonContent> all = [
    // ── Başlangıç (A1) ──────────────────────────────────────────
    presentSimple,
    thereIs,
    questions,
    adjectives,
    prepositions,
    articles,
    pronouns,
    presentSimpleKeywords,
    // ── Temel (A2) ──────────────────────────────────────────────
    pastSimple,
    futureWill,
    canCould,
    presentContinuous,
    comparatives,
    pastSimpleKeywords,
    futureKeywords,
    conjunctions,
    // ── Orta (B1) ───────────────────────────────────────────────
    presentPerfect,
    pastContinuous,
    conditionals1,
    relativeClauses,
    gerunds,
    presentPerfectKeywords,
    pastPerfectKeywords,
    passiveVoiceBasic,
    // ── İleri (B2-C1) ───────────────────────────────────────────
    conditionals2,
    pastPerfect,
    reportedSpeechAdv,
    inversion,
    discourseMarkers,
    mustShouldHaveTo,
    tagQuestions,
    wishIfOnly,
    usedToWould,
    quantifiers,
    phrasalVerbs,
    wordFormation,
  ];

  // ══════════════════════════════════════════════════════════════
  // BAŞLANGIÇ (A1)
  // ══════════════════════════════════════════════════════════════

  // ── STD 1: Present Simple ──────────────────────────────────────
  static const presentSimple = LessonContent(
    id: 'std_1',
    title: 'Geniş Zaman',
    subtitle: 'Present Simple — rutinler, gerçekler, kurallar',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '📘',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Geniş Zaman nedir?',
        body:
            'Geniş Zaman (Present Simple), **düzenli tekrarlanan olaylar**, **kalıcı gerçekler** ve **prosedür kuralları** için kullanılır.\n\nHavacılıkta kontrol listeleri, sistem açıklamaları ve ATC prosedürleri bu zamanda yazılır:\n"The captain **performs** a pre-flight check before every flight."\n"ATC **issues** clearances to all departing aircraft."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Olumlu:** Subject + **V1** (he/she/it → +s/es)\n**Olumsuz:** Subject + **do/does not** + V1\n**Soru:** **Do/Does** + Subject + V1?\n\n✓ The engine **runs** at full power.\n✓ Pilots **do not skip** checklists.\n✓ **Does** the aircraft **carry** enough fuel?',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The co-pilot monitors the instruments during cruise.', highlight: 'monitors', translation: 'Yardımcı pilot, seyir sırasında aletleri izler.'),
          ExampleSentence(sentence: 'ATC does not allow aircraft to enter the runway without clearance.', highlight: 'does not allow', translation: 'ATC, uçakların izin almadan piste girmesine izin vermez.'),
          ExampleSentence(sentence: 'Does the maintenance manual specify the torque value?', highlight: 'Does ... specify', translation: 'Bakım kılavuzu tork değerini belirtiyor mu?'),
          ExampleSentence(sentence: 'The hydraulic system operates at 3000 PSI.', highlight: 'operates', translation: 'Hidrolik sistem 3000 PSI basınçta çalışır.'),
          ExampleSentence(sentence: 'Cabin crew check the emergency exits before every flight.', highlight: 'check', translation: 'Kabin ekibi her uçuştan önce acil çıkışları kontrol eder.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '💡 Dikkat',
        body:
            '"He/She/It" öznelerinde fiile **-s veya -es** eklemeyi unutma!\n• go → **goes** | fly → **flies** | watch → **watches**\n• Olumsuzda: **does not** + yalın fiil\n✗ He does not **flies** → ✓ He does not **fly**',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1001, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft ………… at 35,000 feet during cruise.',
            options: ['cruise', 'cruises', 'is cruise', 'cruising'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1002, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'ATC ………… landing clearance before aircraft touch down.',
            options: ['give', 'gives', 'giving', 'is giving'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1003, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Pilots ………… their licences with them at all times.',
            options: ['carries', 'carry', 'is carry', 'to carry'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1004, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… the captain complete the pre-flight inspection personally?',
            options: ['Is', 'Do', 'Does', 'Are'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 2: There is / There are ────────────────────────────────
  static const thereIs = LessonContent(
    id: 'std_2',
    title: 'There is / There are',
    subtitle: 'Var / Yok — mevcudiyeti tanımlamak',
    categoryId: 'grammar',
    estimatedTime: '6 dk',
    emoji: '📍',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Mevcudiyet nasıl ifade edilir?',
        body:
            '"There is / There are" yapısı bir şeyin **var olduğunu ya da olmadığını** belirtmek için kullanılır. Havacılıkta durum raporlarında ve bakım notlarında sıkça karşılaşırsın:\n"There **is** a crack on the fuselage."\n"There **are** no discrepancies found."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Tekil:** There **is** + noun\n**Çoğul:** There **are** + noun\n**Olumsuz:** There **is/are no** + noun  veya  There **is/are not any** + noun\n**Soru:** **Is/Are** there + noun?\n\n✓ There is a fuel leak near the left engine.\n✓ There are three emergency exits on this aircraft.\n✗ There is no discrepancies. → ✓ There are no discrepancies.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'There is a crack in the wing spar that must be inspected immediately.', highlight: 'There is', translation: 'Kanat omurgasında hemen incelenmesi gereken bir çatlak var.'),
          ExampleSentence(sentence: 'There are four engines on a Boeing 747.', highlight: 'There are', translation: 'Boeing 747\'de dört motor vardır.'),
          ExampleSentence(sentence: 'There is no pressure reading on the hydraulic gauge.', highlight: 'There is no', translation: 'Hidrolik manometrede basınç değeri yok.'),
          ExampleSentence(sentence: 'Are there any hazardous materials on board?', highlight: 'Are there any', translation: 'Uçakta tehlikeli madde var mı?'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1011, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… a fire warning light illuminated on panel B.',
            options: ['There are', 'There is', 'Is there', 'There has'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1012, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… any passengers seated in the emergency exit rows?',
            options: ['There are', 'Is there', 'Are there', 'There is'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1013, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… no faults recorded in the technical log.',
            options: ['There is', 'There are', 'Are there', 'Is there'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1014, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… several deferred maintenance items on this aircraft.',
            options: ['There is', 'There are', 'Is there', 'There has'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 3: Questions & Negatives ───────────────────────────────
  static const questions = LessonContent(
    id: 'std_3',
    title: 'Soru ve Olumsuz Cümleler',
    subtitle: 'Questions & Negatives — İngilizce soru kurma',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '❓',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Soru nasıl kurulur?',
        body:
            'İngilizce\'de soru kurmak için yardımcı fiil öznenin önüne alınır. Türkçe\'den farklı olarak soru işareti veya ek yeterli değildir — **fiil sırası değişmek zorundadır**.\n\nHavacılık iletişiminde doğru soru kurmak kritiktir: yanlış anlaşılma can güvenliğini etkiler.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Soru Türleri',
        body:
            '**Yes/No soruları:** Yardımcı fiil + Subject + V1?\n  → Does the aircraft have fuel? / Is the runway clear?\n\n**Wh- soruları:** Wh + Yardımcı + Subject + V1?\n  → What is the runway condition?\n  → Where is the nearest alternate airport?\n  → How long has the aircraft been unserviceable?\n\n**Olumsuz:** Subject + do/does/did **not** + V1\n  → The crew did not receive the updated ATIS.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'What is your current altitude and heading?', highlight: 'What is', translation: 'Mevcut irtifanız ve rotanız nedir?'),
          ExampleSentence(sentence: 'Did the crew report the bird strike before landing?', highlight: 'Did ... report', translation: 'Ekip inişten önce kuş çarpması olayını bildirdi mi?'),
          ExampleSentence(sentence: 'How many hours does the engine have since last overhaul?', highlight: 'How many hours does', translation: 'Motor son revizyon\'dan bu yana kaç saat çalışmıştır?'),
          ExampleSentence(sentence: 'The co-pilot did not acknowledge the ATC clearance.', highlight: 'did not acknowledge', translation: 'Yardımcı pilot ATC izinini teyit etmedi.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '💡 Dikkat',
        body:
            'Wh- sorusunun öznesi bizzat "wh-" sözcüğüyse yardımcı fiil **kullanılmaz**:\n✓ Who **signed** the maintenance release? (kim imzaladı?)\n✗ Who did signed the maintenance release?\n\nÖzne dışındaki her wh- sorusunda yardımcı fiil şarttır:\n✓ What **did** the captain **decide**?',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1021, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… the landing gear retract normally after takeoff?',
            options: ['Was', 'Did', 'Does', 'Is'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1022, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… is the aircraft\'s maximum takeoff weight?',
            options: ['Who', 'Where', 'What', 'Which'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1023, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The mechanic ………… the defect entry in the technical log.',
            options: ['did not wrote', 'does not wrote', 'did not write', 'not write'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1024, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… authorised the aircraft to return to service?',
            options: ['Who did', 'Who', 'Whom', 'Who does'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 4: Adjectives & Adverbs ────────────────────────────────
  static const adjectives = LessonContent(
    id: 'std_4',
    title: 'Sıfatlar ve Zarflar',
    subtitle: 'Adjectives & Adverbs — tanımlama ve nitelendirme',
    categoryId: 'vocabulary',
    estimatedTime: '7 dk',
    emoji: '🎨',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Sıfat mı, zarf mı?',
        body:
            '**Sıfatlar** isimleri tanımlar: *a severe turbulence*, *a faulty valve*.\n**Zarflar** fiilleri, sıfatları veya diğer zarfları tanımlar: *The engine runs **smoothly***,  *an **extremely** critical fault*.\n\nHavacılık raporlarında "the aircraft **rapidly** descended" ile "a **rapid** descent" arasındaki fark önemlidir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Sıfat:** Noun\'dan önce veya linking verb\'den sonra\n  → a **critical** fault / The fault is **critical**\n\n**Zarf:** Fiil, sıfat veya zarf\'tan önce ya da sonra\n  → The aircraft descended **rapidly**\n  → The weather is **extremely** severe\n\n**-ly ekiyle zarf yapımı (çoğunlukla):**\n  quick → quickly / safe → safely / immediate → immediately\n\n**Dikkat:** fast, hard, low — hem sıfat hem zarf',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The pilot reported a severe vibration in the left engine.', highlight: 'severe', translation: 'Pilot, sol motorda şiddetli bir titreşim bildirdi.'),
          ExampleSentence(sentence: 'The aircraft climbed steadily to its cruising altitude.', highlight: 'steadily', translation: 'Uçak seyir irtifasına istikrarlı biçimde tırmandı.'),
          ExampleSentence(sentence: 'Low-visibility procedures are immediately activated when RVR drops below 550 m.', highlight: 'immediately', translation: 'RVR 550 m\'nin altına düşünce düşük görüş prosedürleri derhal devreye girer.'),
          ExampleSentence(sentence: 'The faulty sensor produced an inaccurate reading.', highlight: 'faulty ... inaccurate', translation: 'Arızalı sensör hatalı bir okuma üretti.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1031, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The crew responded ………… to the fire warning.',
            options: ['immediate', 'immediatly', 'immediately', 'immediating'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1032, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'A ………… approach is required in crosswind conditions above 25 knots.',
            options: ['carefully', 'more carefully', 'careful', 'carefulness'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1033, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The hydraulic pressure dropped ………… during the test.',
            options: ['unexpected', 'unexpectedly', 'unexpecting', 'unexpect'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1034, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The runway surface was ………… contaminated after the storm.',
            options: ['heavy', 'heaviness', 'heavying', 'heavily'], correctIndex: 3, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 5: Prepositions ────────────────────────────────────────
  static const prepositions = LessonContent(
    id: 'std_5',
    title: 'Edatlar',
    subtitle: 'Prepositions — yer, zaman ve yön bildiren sözcükler',
    categoryId: 'grammar',
    estimatedTime: '7 dk',
    emoji: '📌',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Edatlar neden önemlidir?',
        body:
            'Edatlar, isimler ve fiiller arasındaki ilişkiyi kurar. Havacılık İngilizcesinde konumu, zamanı ve yönü doğru belirtmek **güvenlik açısından kritiktir**:\n"Turn **left** **at** runway 28" ile "Turn **right** **on** runway 28" bambaşka anlam taşır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Temel Edat Grupları',
        body:
            '**Yer:** in (içinde), on (üzerinde), at (noktasında), above (yukarısında), below (altında), between (arasında), next to (yanında)\n\n**Hareket:** to (yöne), from (den), through (içinden), into (içine), over (üzerinden)\n\n**Zaman:** at (saat), on (gün), in (ay/yıl), during (süresince), before / after, by (en geç), within (içinde)\n\n**Araç/Yöntem:** by (ile), with (ile), without (olmadan), in accordance with (uygun olarak)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The aircraft is holding at FL150, north of the VOR.', highlight: 'at ... north of', translation: 'Uçak, VOR\'un kuzeyinde FL150\'de bekleme yapıyor.'),
          ExampleSentence(sentence: 'The maintenance must be completed within 24 hours.', highlight: 'within', translation: 'Bakımın 24 saat içinde tamamlanması gerekiyor.'),
          ExampleSentence(sentence: 'The cabin crew performed duties in accordance with the SOPs.', highlight: 'in accordance with', translation: 'Kabin ekibi görevlerini SOP\'lara uygun şekilde yerine getirdi.'),
          ExampleSentence(sentence: 'The runway is closed from 0200 to 0600 for resurfacing.', highlight: 'from ... to', translation: 'Pist asfaltlama için 0200\'den 0600\'e kadar kapalı.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1041, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft is parked ………… Gate 12.',
            options: ['in', 'on', 'at', 'by'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1042, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'All maintenance must be carried out ………… with the AMM.',
            options: ['accordance', 'in accordance', 'according', 'by accordance'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1043, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The flight departed ………… schedule, at 08:45.',
            options: ['on', 'in', 'at', 'by'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1044, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft climbed ………… 10,000 feet to FL350.',
            options: ['at', 'from', 'by', 'through'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════
  // TEMEL (A2)
  // ══════════════════════════════════════════════════════════════

  // ── STD 6: Past Simple ────────────────────────────────────────
  static const pastSimple = LessonContent(
    id: 'std_6',
    title: 'Geçmiş Zaman',
    subtitle: 'Past Simple — tamamlanmış olaylar ve raporlar',
    categoryId: 'grammar',
    estimatedTime: '9 dk',
    emoji: '🕐',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Past Simple neden önemlidir?',
        body:
            'Kaza/olay raporları, uçuş günlükleri ve bakım kayıtları Past Simple zaman kipiyle yazılır. Geçmişte **belirli bir zamanda tamamlanan** eylemleri ifade eder.\n\n"The engine **failed** at FL280."\n"The crew **declared** an emergency at 14:32 UTC."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Düzenli:** V1 + **ed** → land/**ed**, report/**ed**, check/**ed**\n**Düzensiz:** Ezber gerektirir → fly/**flew**, take/**took**, lose/**lost**, have/**had**\n\n**Olumsuz:** Subject + **did not** + V1\n**Soru:** **Did** + Subject + V1?\n\nZaman zarfları: yesterday, last night, at 14:32, two hours ago, during the approach',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The crew detected smoke in the cockpit and declared an emergency.', highlight: 'detected ... declared', translation: 'Ekip kokpitte duman tespit etti ve acil durum ilan etti.'),
          ExampleSentence(sentence: 'The aircraft landed safely despite the hydraulic failure.', highlight: 'landed', translation: 'Uçak hidrolik arızasına rağmen sağlam indi.'),
          ExampleSentence(sentence: 'Did the captain receive the updated weather briefing before departure?', highlight: 'Did ... receive', translation: 'Kaptan kalkıştan önce güncellenen hava durumu brifingini aldı mı?'),
          ExampleSentence(sentence: 'The maintenance crew did not find any cracks during the inspection.', highlight: 'did not find', translation: 'Bakım ekibi kontrol sırasında herhangi bir çatlak bulmadı.'),
          ExampleSentence(sentence: 'The aircraft took off from Istanbul at 0620 UTC.', highlight: 'took off', translation: 'Uçak İstanbul\'dan 0620 UTC\'de havalandı.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '💡 Dikkat',
        body:
            'Havacılık raporlarında en çok kullanılan düzensiz fiiller:\n• fly → **flew** | take off → **took off** | land → landed (düzenli)\n• declare → declared | report → reported (düzenli)\n• lose → **lost** | find → **found** | make → **made**\n\nSoru ve olumsuzu oluştururken fiile **ed ekleme!**\n✗ Did the crew **reported** it? → ✓ Did the crew **report** it?',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1051, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The captain ………… the engine immediately after the fire warning.',
            options: ['shutted down', 'shut down', 'shutdown', 'did shut down'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1052, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The mechanic ………… the defect entry before signing the release.',
            options: ['writed', 'written', 'wrote', 'did write'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1053, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The crew ………… the approach due to a sudden wind shear.',
            options: ['abandoned', 'did abandoned', 'abandon', 'abandonned'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1054, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… the first officer brief the cabin crew on the turbulence?',
            options: ['Was', 'Did', 'Does', 'Had'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 7: Future with Will ────────────────────────────────────
  static const futureWill = LessonContent(
    id: 'std_7',
    title: 'Gelecek Zaman',
    subtitle: 'Will & Going to — planlar ve tahminler',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '🔮',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Will ve Going to farkı',
        body:
            'Gelecek zamanı ifade etmek için iki temel yapı vardır:\n• **Will** → anlık karar, söz verme, tahmin (kanıt yok)\n• **Going to** → önceden planlanmış eylem, kanıta dayalı tahmin\n\n"I **will** contact ATC immediately." (anlık karar)\n"We **are going to** divert to Ankara." (önceden kararlaştırıldı)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Will:** Subject + **will** + V1\n  → The weather will improve after 1400.\n  → We will not (won\'t) reach the alternate.\n\n**Going to:** Subject + **am/is/are going to** + V1\n  → The aircraft is going to land at Sabiha Gökçen.\n  → The crew are not going to delay the departure.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The weather will deteriorate rapidly after 1800 UTC.', highlight: 'will deteriorate', translation: 'Hava koşulları 1800 UTC\'den sonra hızla kötüleşecek.'),
          ExampleSentence(sentence: 'We are going to hold at the VOR for 20 minutes due to traffic.', highlight: 'are going to hold', translation: 'Trafik nedeniyle VOR\'da 20 dakika bekleme yapacağız.'),
          ExampleSentence(sentence: 'The captain will make a PA announcement before the descent.', highlight: 'will make', translation: 'Kaptan iniş öncesinde bir kabin anons yapacak.'),
          ExampleSentence(sentence: 'I will request a lower altitude due to turbulence.', highlight: 'will request', translation: 'Türbülans nedeniyle daha düşük irtifa talep edeceğim.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1061, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'If the oil pressure drops below limits, the crew ………… the engine.',
            options: ['are going to shut down', 'will shut down', 'would shut down', 'were going to shut down'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1062, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'According to the flight plan, the aircraft ………… land at 1520 UTC.',
            options: ['will', 'is going to', 'would', 'shall'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1063, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Look at those cumulonimbus clouds — there ………… a severe thunderstorm.',
            options: ['is going to be', 'will be', 'shall be', 'would be'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1064, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '"I ………… declare an emergency if the situation doesn\'t improve."',
            options: ['am going to', 'will', 'would', 'shall'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 8: Can / Could / May ───────────────────────────────────
  static const canCould = LessonContent(
    id: 'std_8',
    title: 'Can, Could, May',
    subtitle: 'Yetenek, olasılık ve izin — temel modal fiiller',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '🔑',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Bu üç modal arasındaki fark',
        body:
            '**Can** → yetenek veya izin (günlük dil)\n**Could** → geçmişte yetenek, kibar rica, olasılık\n**May** → resmi izin, olasılık\n\nHavacılıkta ATC konuşmalarında "May we proceed?" ve "You may descend" çok sık kullanılır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Kullanım Tablosu',
        body:
            '| Modal | Kullanım | Örnek |\n|-------|---------|-------|\n| can | yetenek | The aircraft can carry 250 passengers. |\n| can | günlük izin | Can we start engines now? |\n| could | geçmişte yetenek | The old model could only reach FL350. |\n| could | kibar soru | Could you say again? |\n| may | resmi izin | You may proceed to the gate. |\n| may | olasılık | There may be ice on the runway. |',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The aircraft cannot take off without a valid airworthiness certificate.', highlight: 'cannot', translation: 'Uçak geçerli bir uçuşa elverişlilik sertifikası olmadan kalkamaz.'),
          ExampleSentence(sentence: 'Could you confirm your squawk code?', highlight: 'Could you confirm', translation: 'Transponder kodunuzu teyit edebilir misiniz?'),
          ExampleSentence(sentence: 'You may taxi to holding point Alpha 1.', highlight: 'may taxi', translation: 'Alpha 1 bekleme noktasına taksi yapabilirsiniz.'),
          ExampleSentence(sentence: 'There may be significant turbulence above FL300 this evening.', highlight: 'may be', translation: 'Bu akşam FL300 üzerinde önemli türbülans olabilir.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1071, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '"………… we start the APU?" — requesting permission from ground.',
            options: ['Could', 'May', 'Can', 'All of the above'], correctIndex: 3, difficulty: Difficulty.easy),
          QuestionModel(id: -1072, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft ………… climb above FL400 due to performance limitations.',
            options: ['may not', 'could not', 'cannot', 'will not'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1073, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '"You ………… proceed direct to KONAK waypoint." — ATC clearance',
            options: ['can', 'may', 'could', 'would'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1074, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'There ………… be ice contamination on the wings — we need to check.',
            options: ['can', 'could', 'may', 'both b and c'], correctIndex: 3, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 9: Present Continuous ─────────────────────────────────
  static const presentContinuous = LessonContent(
    id: 'std_9',
    title: 'Şimdiki Zaman (-ing)',
    subtitle: 'Present Continuous — devam eden ve geçici eylemler',
    categoryId: 'grammar',
    estimatedTime: '7 dk',
    emoji: '⏳',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Present Continuous ne zaman kullanılır?',
        body:
            'Present Continuous (am/is/are + V-ing), **tam konuşma anında gerçekleşen** veya **geçici devam eden** eylemleri anlatır.\n\nHavacılıkta pilot/ATC iletişiminde sıkça kullanılır:\n"We **are experiencing** moderate turbulence."\n"The aircraft **is climbing** to FL280."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Olumlu:** Subject + **am/is/are** + V**-ing**\n**Olumsuz:** Subject + **am/is/are not** + V-ing\n**Soru:** **Am/Is/Are** + Subject + V-ing?\n\n**-ing yazım kuralları:**\n• fly → fly**ing** | land → land**ing**\n• run → ru**nn**ing | sit → si**tt**ing (k.+v.+k. → son harf çift)\n• make → mak**ing** (sonu -e → e atılır)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'We are descending to 4000 feet on the ILS approach.', highlight: 'are descending', translation: 'ILS yaklaşmasında 4000 feet\'e alçalıyoruz.'),
          ExampleSentence(sentence: 'The cabin crew are preparing the cabin for landing.', highlight: 'are preparing', translation: 'Kabin ekibi kabini inişe hazırlıyor.'),
          ExampleSentence(sentence: 'Is the fuel truck currently servicing the aircraft?', highlight: 'Is ... servicing', translation: 'Yakıt kamyonu şu an uçağı ikmaliyor mu?'),
          ExampleSentence(sentence: 'The technician is not finding the source of the oil leak.', highlight: 'is not finding', translation: 'Teknisyen yağ kaçağının kaynağını bulamıyor.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1081, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft ………… at a rate of 1,800 feet per minute.',
            options: ['climbs', 'is climbing', 'climb', 'are climbing'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1082, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… the ground crew ………… the luggage into the hold?',
            options: ['Is ... loading', 'Are ... loading', 'Does ... loading', 'Have ... loading'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1083, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'We ………… moderate icing at FL180.',
            options: ['encounter', 'are encountering', 'encountering', 'have encountering'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1084, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The mechanic ………… the engine run-up test at the moment.',
            options: ['performs', 'is performing', 'was performing', 'will perform'], correctIndex: 1, difficulty: Difficulty.easy),
        ],
      ),
    ],
  );

  // ── STD 10: Comparatives & Superlatives ───────────────────────
  static const comparatives = LessonContent(
    id: 'std_10',
    title: 'Karşılaştırmalar',
    subtitle: 'Comparatives & Superlatives — daha fazla, en fazla',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '📊',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Karşılaştırma neden gereklidir?',
        body:
            'Havacılık kararlarında ve raporlarında "daha fazla", "en az", "eşit" gibi karşılaştırmalar sık kullanılır:\n"The alternate airport has **a longer** runway."\n"This is **the most efficient** route available."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Kısa sıfatlar (1-2 hece):** adj + **-er** than / the adj + **-est**\n  → long → **longer** than / **the longest**\n  → safe → **safer** / **the safest**\n\n**Uzun sıfatlar (3+ hece):** **more** + adj / **the most** + adj\n  → efficient → **more efficient** / **the most efficient**\n  → severe → **more severe** / **the most severe**\n\n**Düzensizler:** good/**better**/best · bad/**worse**/worst · far/**further**/furthest',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The B737 is lighter than the A330, making it more fuel-efficient on short routes.', highlight: 'lighter ... more fuel-efficient', translation: 'B737, A330\'dan daha hafiftir; bu da kısa güzergahlarda onu daha yakıt verimli kılar.'),
          ExampleSentence(sentence: 'The crosswind at the alternate was stronger than forecast.', highlight: 'stronger than', translation: 'Alternatif pistdeki çapraz rüzgar tahmin edilenden daha güçlüydü.'),
          ExampleSentence(sentence: 'This runway is the longest in the country at 4,500 metres.', highlight: 'the longest', translation: 'Bu pist 4.500 metre ile ülkedeki en uzun pisttir.'),
          ExampleSentence(sentence: 'The weather is getting worse — we should consider diversion.', highlight: 'getting worse', translation: 'Hava koşulları kötüleşiyor — sapma düşünmeliyiz.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1091, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The visibility at the destination is ………… than the alternate.',
            options: ['worse', 'more worse', 'worst', 'more bad'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1092, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Runway 28L is ………… runway at this airport.',
            options: ['the longest', 'the most long', 'longer', 'most longest'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1093, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'This engine overhaul procedure is ………… the previous one.',
            options: ['more complex than', 'complexer than', 'more complex that', 'most complex than'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1094, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The ………… aircraft in the fleet is the newest A220.',
            options: ['most efficient', 'more efficient', 'efficientest', 'most efficiently'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════
  // ORTA (B1)
  // ══════════════════════════════════════════════════════════════

  // ── STD 11: Present Perfect ───────────────────────────────────
  static const presentPerfect = LessonContent(
    id: 'std_11',
    title: 'Present Perfect',
    subtitle: 'Have/Has + V3 — geçmiş deneyim ve etkisi',
    categoryId: 'grammar',
    estimatedTime: '10 dk',
    emoji: '🔗',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Present Perfect nedir?',
        body:
            'Present Perfect, geçmişte gerçekleşen **ama şimdiye etkisi olan** olayları anlatır. Havacılıkta son bakım durumu, tecrübe bildirimi ve son durum güncellemelerinde sıkça kullanılır:\n"The crew **has been** briefed."\n"Engineering **has cleared** the aircraft for departure."\n"Have you **received** the latest ATIS?"',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Olumlu:** Subject + **have/has** + V3\n**Olumsuz:** Subject + **have/has not** + V3\n**Soru:** **Have/Has** + Subject + V3?\n\nSık kullanılan zaman zarfları:\n• **already** (zaten), **yet** (henüz — soru/olumsuzda)\n• **just** (az önce), **ever/never** (hiç)\n• **since** (den beri), **for** (süredir)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The engineer has already signed the maintenance release.', highlight: 'has already signed', translation: 'Mühendis bakım onayını çoktan imzaladı.'),
          ExampleSentence(sentence: 'Have you checked the tyre pressures yet?', highlight: 'Have you checked ... yet', translation: 'Lastik basınçlarını kontrol ettin mi henüz?'),
          ExampleSentence(sentence: 'The aircraft has never experienced a pressurisation failure.', highlight: 'has never experienced', translation: 'Uçak hiç kabin basıncı arızası yaşamamış.'),
          ExampleSentence(sentence: 'The captain has been flying for this airline for fifteen years.', highlight: 'has been flying for', translation: 'Kaptan bu havayolunda on beş yıldır uçuyor.'),
          ExampleSentence(sentence: 'We have just received the amended clearance from ATC.', highlight: 'have just received', translation: 'ATC\'den az önce değiştirilmiş izni aldık.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '💡 Present Perfect vs Past Simple',
        body:
            'Tam zamanı belli geçmiş → **Past Simple**\n✓ The engine **failed** at 14:32. (belirli zaman)\n\nZamanı belirsiz veya şimdiye bağlı geçmiş → **Present Perfect**\n✓ The engine **has failed** before. (deneyim, zaman belirsiz)\n\n"We **have cleared** the runway." (şu an hazır → etkisi şimdi)\n"The crew **cleared** the runway at 0820." (belirli zaman)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1101, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The co-pilot ………… the approach briefing yet.',
            options: ['has not completed', 'did not completed', 'have not completed', 'not completed'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1102, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… the aircraft been refuelled?',
            options: ['Did', 'Was', 'Has', 'Is'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1103, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'This is the first time the crew ………… this emergency procedure.',
            options: ['performed', 'has performed', 'have performed', 'performs'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1104, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The technician ………… the brake assembly three times this week.',
            options: ['inspected', 'has inspected', 'have inspected', 'inspect'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 12: Past Continuous ───────────────────────────────────
  static const pastContinuous = LessonContent(
    id: 'std_12',
    title: 'Geçmişte Süregelen Eylem',
    subtitle: 'Past Continuous — geçmişte devam eden eylem',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '🔄',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Past Continuous nedir?',
        body:
            'Past Continuous (was/were + V-ing), geçmişte belirli bir anda **sürmekte olan** eylemi anlatır. Kaza soruşturmalarında ve durum açıklamalarında kritiktir:\n"The crew **was conducting** the approach **when** the wind shear occurred."\n"At the time of the incident, the aircraft **was climbing** through FL180."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı ve Kullanım',
        body:
            '**Yapı:** Subject + **was/were** + V-ing\n\n**Ne zaman kullanılır:**\n1. Belirli bir geçmiş anda süren eylem:\n   → At 14:30, the aircraft **was holding** at FL100.\n2. Bir kısa eylem uzun eylemle kesişince:\n   → The crew **was briefing** when the alert sounded. (uzun + kısa)\n3. İki paralel süregelen eylem:\n   → While the captain **was flying**, the FO **was computing** fuel.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The aircraft was descending through FL080 when the GPWS activated.', highlight: 'was descending', translation: 'GPWS devreye girdiğinde uçak FL080\'den alçalıyordu.'),
          ExampleSentence(sentence: 'The cabin crew were serving meals when the seatbelt sign illuminated.', highlight: 'were serving', translation: 'Emniyet kemeri işareti yanınca kabin ekibi yemek servisi yapıyordu.'),
          ExampleSentence(sentence: 'While the engineers were working on engine 1, a fuel leak was found.', highlight: 'were working', translation: 'Mühendisler 1. motor üzerinde çalışırken bir yakıt kaçağı bulundu.'),
          ExampleSentence(sentence: 'The controller was vectoring two aircraft simultaneously when radar contact was lost.', highlight: 'was vectoring', translation: 'Kontrolör iki uçağı aynı anda yönlendirirken radar kontağı kesildi.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1111, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The crew ………… the approach checklist when the engine fire warning illuminated.',
            options: ['ran', 'were running', 'was running', 'has been running'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1112, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'At 0900 UTC, the aircraft ………… at FL350 on a heading of 270.',
            options: ['cruised', 'cruising', 'was cruising', 'were cruising'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1113, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The engineer ………… the hydraulic system when he discovered the crack.',
            options: ['tested', 'was testing', 'were testing', 'has been testing'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1114, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'While the captain ………… the fuel, the co-pilot ………… the weather.',
            options: ['was checking / was monitoring', 'checked / monitored', 'is checking / is monitoring', 'checks / monitors'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 13: Conditionals Type 1 ───────────────────────────────
  static const conditionals1 = LessonContent(
    id: 'std_13',
    title: 'Koşul Cümleleri Tip 1',
    subtitle: 'First Conditional — gerçek ve olası koşullar',
    categoryId: 'grammar',
    estimatedTime: '9 dk',
    emoji: '⚡',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Tip 1 Koşul nedir?',
        body:
            'Birinci Tip Koşul cümleleri, **gerçek ve olası** durumlar için kullanılır. Sonuç mantıksal ve mümkündür.\n\nHavacılıkta acil prosedürler, kural maddeleri ve operasyonel kararlar çoğunlukla bu yapıyla yazılır:\n"**If** the oil pressure drops below 40 PSI, **the crew will shut down** the engine."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**If** + Present Simple, **will/can/may/must** + V1\n\n✓ If the visibility drops below 550m, the crew will execute a missed approach.\n✓ If you receive a TCAS RA, you must follow it immediately.\n✓ If fuel reaches bingo, the aircraft can divert immediately.\n\n**Dikkat:** if-cümleciğinde "will" kullanılmaz!\n✗ If the weather **will improve**, we will depart.\n✓ If the weather **improves**, we will depart.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'If the RVR falls below CAT I minima, the approach will be discontinued.', highlight: 'If ... falls ... will be discontinued', translation: 'RVR, CAT I minimumların altına düşerse yaklaşma iptal edilecektir.'),
          ExampleSentence(sentence: 'If a fuel imbalance exceeds 1,000 kg, the crew must initiate fuel transfer.', highlight: 'If ... exceeds ... must initiate', translation: 'Yakıt dengesizliği 1.000 kg\'ı aşarsa ekip yakıt transferi başlatmak zorundadır.'),
          ExampleSentence(sentence: 'Can you hold at the VOR if the gate is not ready?', highlight: 'if ... is not ready', translation: 'Kapı hazır değilse VOR\'da bekleme yapabilir misiniz?'),
          ExampleSentence(sentence: 'If the airport is below minimums, we will divert to Ankara.', highlight: 'If ... is below ... will divert', translation: 'Havalimanı minimumların altındaysa Ankara\'ya sapacağız.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1121, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'If the engine temperature ………… limits, the crew will shut it down.',
            options: ['exceeds', 'will exceed', 'exceeded', 'would exceed'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1122, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'If you receive a TCAS RA, you ………… follow it immediately.',
            options: ['would', 'should', 'must', 'might'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1123, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'What ………… happen if the aircraft loses all hydraulic pressure?',
            options: ['will', 'would', 'should', 'did'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1124, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The runway ………… be closed if ………… on it.',
            options: ['will / there is debris', 'would / there is debris', 'will / there will be debris', 'shall / debris is'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 14: Relative Clauses ──────────────────────────────────
  static const relativeClauses = LessonContent(
    id: 'std_14',
    title: 'Bağıl Cümleler',
    subtitle: 'Relative Clauses — who, which, that ile tanımlama',
    categoryId: 'grammar',
    estimatedTime: '9 dk',
    emoji: '🔍',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Bağıl Cümle nedir?',
        body:
            'Bağıl Cümle, bir ismi veya ifadeyi **tanımlar veya açıklar**. Teknik raporlarda ve havacılık düzenlemelerinde ayrıntı katmak için sıkça kullanılır:\n"The pilot **who declared the emergency** had 12 years of experience."\n"The valve **that controls fuel flow** was found faulty."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı ve Bağıl Zamirler',
        body:
            '**who** → insanlar için\n  → The captain who flew the aircraft was highly experienced.\n\n**which** → nesneler/hayvanlar için\n  → The engine which failed was the left one.\n\n**that** → hem insanlar hem nesneler (gayri resmi)\n  → The crew that responded first handled it well.\n\n**whose** → sahiplik\n  → The pilot whose licence expired was grounded.\n\n**where** → yer\n  → The hangar where the repair took place is now closed.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The aircraft which departed at 0800 has declared an emergency.', highlight: 'which departed at 0800', translation: '0800\'de kalkan uçak acil durum ilan etti.'),
          ExampleSentence(sentence: 'The technician who signed the release must hold an authorised B1 licence.', highlight: 'who signed the release', translation: 'Onayı imzalayan teknisyen, yetkili bir B1 lisansına sahip olmalıdır.'),
          ExampleSentence(sentence: 'We need to replace the component whose service life has expired.', highlight: 'whose service life has expired', translation: 'Hizmet ömrü dolmuş olan parçayı değiştirmemiz gerekiyor.'),
          ExampleSentence(sentence: 'The runway where the incident occurred is still under investigation.', highlight: 'where the incident occurred', translation: 'Olayın gerçekleştiği pist hâlâ soruşturma altında.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1131, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The inspector ………… reviewed the maintenance records found several discrepancies.',
            options: ['which', 'who', 'whose', 'whom'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1132, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The fuel tank ………… capacity is 12,000 litres must be inspected quarterly.',
            options: ['which', 'that', 'whose', 'who'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1133, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The airport ………… they diverted was already operating at full capacity.',
            options: ['which', 'that', 'where', 'who'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1134, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The regulation ………… came into effect in 2023 requires all aircraft to have TCAS II.',
            options: ['who', 'whose', 'which', 'where'], correctIndex: 2, difficulty: Difficulty.easy),
        ],
      ),
    ],
  );

  // ── STD 15: Gerunds & Infinitives ─────────────────────────────
  static const gerunds = LessonContent(
    id: 'std_15',
    title: 'Fiilimsi: -ing ve to-infinitive',
    subtitle: 'Gerunds & Infinitives — fiil ismi yapıları',
    categoryId: 'grammar',
    estimatedTime: '10 dk',
    emoji: '🧩',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Gerund mu, to-infinitive mi?',
        body:
            'Bir fiili başka bir fiilin nesnesi ya da öznesi olarak kullanmak istediğinde iki seçenek var:\n• **Gerund** (V-ing): özne olarak, veya belirli fiillerden sonra\n• **to-Infinitive**: amaç belirtmek, veya başka belirli fiillerden sonra\n\nHavacılık metinlerinde bu yapılar çok sık geçer: *avoid stalling*, *need to check*, *recommend carrying extra fuel*.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Hangi yapı ne zaman?',
        body:
            '**Gerund (-ing) kullanan fiiller:** enjoy, avoid, recommend, consider, suggest, keep, risk, deny\n  → The crew **avoided flying** through the storm.\n  → Engineers **recommend checking** torque values.\n\n**to-Infinitive kullanan fiiller:** need, want, decide, plan, agree, refuse, manage, fail\n  → The captain **decided to divert**.\n  → The aircraft **failed to climb** above FL200.\n\n**Her ikisini alan fiiller:** like, start, begin, continue, prefer (anlam aynı kalır)\n  → We started **checking / to check** the systems.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The captain decided to declare a Mayday after the second engine failure.', highlight: 'decided to declare', translation: 'Kaptan, ikinci motor arızasının ardından Mayday ilan etmeye karar verdi.'),
          ExampleSentence(sentence: 'Pilots should avoid flying in areas with reported volcanic ash.', highlight: 'avoid flying', translation: 'Pilotlar, volkanik kül bildirilen bölgelerde uçmaktan kaçınmalıdır.'),
          ExampleSentence(sentence: 'The mechanic failed to notice the crack during the first inspection.', highlight: 'failed to notice', translation: 'Tamirci ilk kontrol sırasında çatlağı fark etmekte başarısız oldu.'),
          ExampleSentence(sentence: 'ATC recommended reducing speed to 180 knots on the approach.', highlight: 'recommended reducing', translation: 'ATC, yaklaşmada hızı 180 knota indirmeyi önerdi.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1141, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The crew decided ………… to the alternate airport.',
            options: ['diverting', 'to divert', 'divert', 'diverted'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1142, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Maintenance regulations recommend ………… all filter elements after a surge.',
            options: ['to replace', 'replacing', 'replace', 'replaced'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1143, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft managed ………… above the thunderstorm cell.',
            options: ['climbing', 'to climb', 'climb', 'to climbing'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1144, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Pilots must avoid ………… in icing conditions without anti-ice activated.',
            options: ['to fly', 'fly', 'flying', 'to flying'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════
  // İLERİ (B2-C1)
  // ══════════════════════════════════════════════════════════════

  // ── STD 16: Conditionals Type 2 & 3 ──────────────────────────
  static const conditionals2 = LessonContent(
    id: 'std_16',
    title: 'Koşul Cümleleri Tip 2 & 3',
    subtitle: 'Unreal & Past Conditionals — varsayımsal durumlar',
    categoryId: 'grammar',
    estimatedTime: '11 dk',
    emoji: '🌀',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Gerçekdışı koşullar',
        body:
            '**Tip 2 (Şimdi/Gelecekte gerçekdışı):** Şu an için varsayımsal durum.\n**Tip 3 (Geçmişte gerçekleşmemiş):** Geçmişte farklı bir karar alınsaydı ne olurdu?\n\nHavacılık kazası soruşturmalarında Tip 3 çok sık kullanılır:\n"**If** the crew **had received** the updated weather, they **would have diverted**."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Tip 2:** If + Past Simple, **would/could/might** + V1\n  → If we had more fuel, we could divert to the alternate.\n  → If the runway were longer, heavier aircraft could land here.\n\n**Tip 3:** If + Past Perfect (had + V3), **would/could/might have** + V3\n  → If the crew had noticed the warning earlier, they would have had more time.\n  → If maintenance had replaced the valve, the leak would not have occurred.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'If the radar had been serviceable, the crew would have detected the cell earlier.', highlight: 'had been ... would have detected', translation: 'Radar çalışıyor olsaydı, ekip hücreyi daha erken tespit etmiş olurdu.'),
          ExampleSentence(sentence: 'If the co-pilot were more experienced, the captain might delegate more tasks.', highlight: 'were ... might delegate', translation: 'Yardımcı pilot daha deneyimli olsaydı, kaptan daha fazla görev devredebilirdi.'),
          ExampleSentence(sentence: 'The accident would not have happened if the pre-flight check had been thorough.', highlight: 'would not have happened ... had been', translation: 'Uçuş öncesi kontrol kapsamlı yapılmış olsaydı kaza yaşanmayacaktı.'),
          ExampleSentence(sentence: 'If I were you, I would request a lower altitude due to icing.', highlight: 'were ... would request', translation: 'Senin yerinde olsam, buz oluşumu nedeniyle daha düşük irtifa talep ederdim.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1151, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'If the de-icing had been completed before departure, the accident ………… .',
            options: ['would not happen', 'would not have happened', 'will not happen', 'did not happen'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1152, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'If we ………… more fuel, we could divert to an alternate airport.',
            options: ['had', 'have', 'would have', 'will have'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1153, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The crash ………… avoided if the crew had followed the checklist properly.',
            options: ['could be', 'can be', 'could have been', 'would be'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1154, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'If the runway ………… longer, large cargo aircraft could operate here.',
            options: ['is', 'was', 'were', 'would be'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 17: Past Perfect ──────────────────────────────────────
  static const pastPerfect = LessonContent(
    id: 'std_17',
    title: 'Geçmiş Mükemmel',
    subtitle: 'Past Perfect — geçmişte daha önceki eylem',
    categoryId: 'grammar',
    estimatedTime: '9 dk',
    emoji: '⏪',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Past Perfect nedir?',
        body:
            'Past Perfect (had + V3), geçmişteki **iki olaydan önce olanı** vurgular. Kaza soruşturmalarında olayların kronolojik sırasını netleştirmek için kullanılır:\n"The crew **had already briefed** the emergency procedure **before** the fault appeared."\n"By the time they reached the runway, the weather **had deteriorated** significantly."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Olumlu:** Subject + **had** + V3\n**Olumsuz:** Subject + **had not** (hadn\'t) + V3\n**Soru:** **Had** + Subject + V3?\n\nSık kullanılan bağlaçlar: **before, after, by the time, already, just, never, when**\n\n✓ The aircraft had taxied to the runway before the crew noticed the fault.\n✓ By the time maintenance arrived, the leak had stopped spontaneously.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The crew had completed the checklist before the engine start.', highlight: 'had completed', translation: 'Ekip, motor çalıştırmadan önce kontrol listesini tamamlamıştı.'),
          ExampleSentence(sentence: 'By the time the rescue team arrived, the crew had already evacuated the aircraft.', highlight: 'had already evacuated', translation: 'Kurtarma ekibi geldiğinde ekip uçağı çoktan boşaltmıştı.'),
          ExampleSentence(sentence: 'The investigation found that the technician had not replaced the correct part.', highlight: 'had not replaced', translation: 'Soruşturma, teknisyenin doğru parçayı değiştirmediğini ortaya koydu.'),
          ExampleSentence(sentence: 'Had the crew received the SIGMET, they would not have entered the area.', highlight: 'Had the crew received', translation: 'Ekip SIGMET\'i almış olsaydı, o bölgeye girmezlerdi.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1161, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'By the time the fire brigade arrived, the crew ………… the aircraft.',
            options: ['evacuated', 'had evacuated', 'have evacuated', 'were evacuating'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1162, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The investigation revealed that the valve ………… incorrectly during the last overhaul.',
            options: ['installed', 'had installed', 'had been installed', 'was installed'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1163, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… the captain ………… the NOTAMs before the crew reported for duty?',
            options: ['Had ... reviewed', 'Did ... review', 'Has ... reviewed', 'Was ... reviewing'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1164, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft landed safely, but it ………… its fuel reserves completely.',
            options: ['almost used', 'had almost used', 'has almost used', 'almost had used'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 18: Reported Speech ───────────────────────────────────
  static const reportedSpeechAdv = LessonContent(
    id: 'std_18',
    title: 'Dolaylı Anlatım',
    subtitle: 'Reported Speech — aktarma ve zaman kayması',
    categoryId: 'grammar',
    estimatedTime: '10 dk',
    emoji: '💬',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Dolaylı Anlatım nedir?',
        body:
            'Birinin söylediklerini aktarırken doğrudan alıntı yapmak yerine **Reported Speech** kullanılır. Kaza raporlarında tanık ifadeleri, ATC kayıtlarının özetleri ve bakım bildirimlerinde zorunludur:\n"The captain said that the oil pressure **had dropped** below limits."\n"ATC reported that the runway **was** contaminated."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Zaman Kayması (Backshift)',
        body:
            '| Doğrudan | Dolaylı |\n|---------|--------|\n| Present Simple | Past Simple |\n| Present Continuous | Past Continuous |\n| Past Simple | Past Perfect |\n| will | would |\n| can | could |\n| must | had to / must |\n\n**Zaman zarfları da değişir:**\n• now → then / at that time\n• today → that day\n• yesterday → the previous day\n• tomorrow → the following day / the next day\n• here → there',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The captain said that the left engine had been vibrating for 20 minutes.', highlight: 'had been vibrating', translation: 'Kaptan, sol motorun 20 dakikadır titreştiğini söyledi.'),
          ExampleSentence(sentence: 'ATC informed the crew that the runway would be closed for 30 minutes.', highlight: 'would be closed', translation: 'ATC, ekibe pistin 30 dakika kapalı kalacağını bildirdi.'),
          ExampleSentence(sentence: 'The first officer reported that he could not retract the landing gear.', highlight: 'could not retract', translation: 'Yardımcı pilot, iniş takımını kaldıramadığını bildirdi.'),
          ExampleSentence(sentence: 'The witness stated that the aircraft had descended very rapidly.', highlight: 'had descended', translation: 'Tanık, uçağın çok hızlı alçaldığını ifade etti.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1171, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '"We are experiencing engine failure." → The crew reported that they ………… engine failure.',
            options: ['experience', 'experienced', 'were experiencing', 'had experienced'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1172, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '"The runway is clear." → ATC confirmed that the runway ………… clear.',
            options: ['is', 'was', 'had been', 'were'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1173, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '"I will contact Istanbul Approach immediately." → The pilot said he ………… Istanbul Approach immediately.',
            options: ['will contact', 'contacted', 'would contact', 'had contacted'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1174, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '"We must divert to Ankara." → The captain stated that they ………… to Ankara.',
            options: ['must divert', 'had to divert', 'would have to divert', 'both b and c'], correctIndex: 3, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 19: Inversion & Emphasis ──────────────────────────────
  static const inversion = LessonContent(
    id: 'std_19',
    title: 'Devrik Cümle ve Vurgu',
    subtitle: 'Inversion & Emphasis — resmi ve güçlü ifadeler',
    categoryId: 'grammar',
    estimatedTime: '10 dk',
    emoji: '🔼',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Neden devrik cümle?',
        body:
            'Devrik cümle yapıları (inversion), **resmiyet**, **vurgu** ve **güçlü etki** için kullanılır. ICAO dil testi sınavlarında ve resmi havacılık belgelerinde sıkça karşılaşırsın:\n"**Not only did** the crew fail to follow procedures, but they also ignored ATC instructions."\n"**Under no circumstances should** the engine be restarted in flight."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yaygın Devrik Yapılar',
        body:
            '**Olumsuz zarflıklar ile:**\n• Never → **Never has** such a serious failure occurred.\n• Not only → **Not only did** the crew fail, but they also...\n• Under no circumstances → **Under no circumstances should** you...\n• Rarely → **Rarely do** such errors go undetected.\n\n**Only ile:**\n• Only after → **Only after the checklist was completed did** the aircraft depart.\n• Only when → **Only when** fuel was critical **did** they divert.\n\n**So/Such ile:**\n• So serious was the damage that the aircraft was grounded.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'Never should a crew member disable a safety system without authorisation.', highlight: 'Never should', translation: 'Bir ekip üyesi, izin almadan hiçbir zaman bir güvenlik sistemini devre dışı bırakmamalıdır.'),
          ExampleSentence(sentence: 'Not only did the aircraft lose hydraulic pressure, but the brakes also failed.', highlight: 'Not only did', translation: 'Uçak yalnızca hidrolik basıncını kaybetmekle kalmadı, frenler de arıza yaptı.'),
          ExampleSentence(sentence: 'Only after completing the engine fire checklist should the crew assess the damage.', highlight: 'Only after ... should', translation: 'Yalnızca motor yangını kontrol listesini tamamladıktan sonra ekip hasarı değerlendirmelidir.'),
          ExampleSentence(sentence: 'Under no circumstances should the cargo hold door be opened in flight.', highlight: 'Under no circumstances should', translation: 'Uçuş sırasında kargo kapısı hiçbir koşulda açılmamalıdır.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1181, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… should the aircraft be cleared for departure without a full pre-flight check.',
            options: ['Under no circumstances', 'Rarely', 'Only when', 'Not only'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1182, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Not only ………… the hydraulic pressure, but ………… too.',
            options: ['did the aircraft lose / the fuel system failed', 'the aircraft lose / failed the fuel', 'lost the aircraft / fuel failed', 'did lose the aircraft / the fuel did fail'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1183, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Only after the fire ………… fully extinguished ………… the aircraft approach the gate.',
            options: ['was / did', 'had been / did', 'was / should', 'had been / should'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1184, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… has such a complex technical failure been recorded in this fleet.',
            options: ['Rarely', 'Never', 'Not only', 'Both a and b'], correctIndex: 3, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 20: Discourse Markers ─────────────────────────────────
  static const discourseMarkers = LessonContent(
    id: 'std_20',
    title: 'Bağlaçlar ve Söylem İşaretleri',
    subtitle: 'Discourse Markers — tutarlı ve akıcı metinler',
    categoryId: 'grammar',
    estimatedTime: '10 dk',
    emoji: '🔗',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Söylem işaretleri nedir?',
        body:
            'Söylem işaretleri (bağlaçlar, geçiş ifadeleri), cümleleri ve paragrafları **tutarlı ve akıcı** biçimde bağlar. Havacılık raporları, prosedür dokümanları ve ICAO dil testi yazma bölümünde bu ifadeleri doğru kullanmak puan farkı yaratır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Kategoriler',
        body:
            '**Ekleme:** furthermore, in addition, moreover, also, additionally\n  → The engine failed. **Furthermore**, the backup system was unserviceable.\n\n**Karşılaştırma/Zıtlık:** however, nevertheless, despite, although, whereas, on the other hand\n  → The weather was severe. **However**, the crew managed a safe landing.\n\n**Neden-Sonuç:** therefore, consequently, as a result, thus, due to\n  → Fuel was critically low. **As a result**, the crew declared an emergency.\n\n**Zaman/Sıra:** initially, subsequently, eventually, finally, at the time, prior to\n  → **Initially**, the crew attempted a restart. **Subsequently**, they shut down the engine.\n\n**Sonuç/Özet:** in conclusion, overall, to summarise, in summary',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The weather briefing indicated clear skies; however, conditions deteriorated rapidly en route.', highlight: 'however', translation: 'Hava brifinginde açık gökyüzü belirtilmişti; ancak rota boyunca koşullar hızla kötüleşti.'),
          ExampleSentence(sentence: 'The aircraft had a technical defect. Consequently, the departure was delayed by three hours.', highlight: 'Consequently', translation: 'Uçakta teknik arıza mevcuttu. Sonuç olarak, kalkış üç saat ertelendi.'),
          ExampleSentence(sentence: 'Despite the strong crosswind, the captain executed a successful landing.', highlight: 'Despite', translation: 'Güçlü yan rüzgara rağmen kaptan başarılı bir iniş gerçekleştirdi.'),
          ExampleSentence(sentence: 'Initially, the crew declared PANPAN; subsequently, they upgraded to MAYDAY.', highlight: 'Initially ... subsequently', translation: 'Ekip önce PANPAN ilan etti; ardından bunu MAYDAY\'e yükseltti.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1191, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The first approach was unsuccessful. ………… , the crew executed a go-around.',
            options: ['Furthermore', 'Consequently', 'Despite', 'Although'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1192, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… the poor weather conditions, the aircraft landed without incident.',
            options: ['Although', 'Despite', 'However', 'Whereas'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1193, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The hydraulic pressure dropped. ………… , the flight crew had to use alternative braking.',
            options: ['Nevertheless', 'As a result', 'Initially', 'In addition'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1194, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The runway was contaminated. ………… , the taxiways were also icy.',
            options: ['As a result', 'Furthermore', 'Despite', 'However'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════
  // YENİ BAŞLANGIÇ (A1) DERSLERİ
  // ══════════════════════════════════════════════════════════════

  // ── STD 21: Articles ──────────────────────────────────────────
  static const articles = LessonContent(
    id: 'std_21',
    title: 'Tanımlık: A / An / The',
    subtitle: 'Articles — belirsiz ve belirli tanımlık kullanımı',
    categoryId: 'grammar',
    estimatedTime: '7 dk',
    emoji: '🔤',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Tanımlıklar neden önemlidir?',
        body:
            'İngilizce\'de her ismin önüne doğru tanımlık getirilmelidir. Havacılık İngilizcesinde yanlış tanımlık, talimatın anlamını değiştirebilir:\n"Call **the** approach control" (belirli bir birim) vs "Call **an** approach control" (herhangi bir birim)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Kurallar',
        body:
            '**A** → sessiz harfle başlayan tekil isimler (a flight, a runway, a captain)\n**An** → sesli harfle başlayan tekil isimler (an airport, an IFR clearance, an emergency)\n**The** → daha önce bahsedilen, tek olan veya belirli olan isimler\n\n✓ We have **a** technical issue. (ilk kez bahsediliyor)\n✓ **The** issue is in the hydraulic system. (aynı sorundan tekrar)\n✓ **The** sun is setting — reduce to night lighting.\n✗ No article: uncountable nouns in general — "Fuel is essential."',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'An emergency has been declared on flight TK204.', highlight: 'An emergency', translation: 'TK204 seferinde acil durum ilan edildi.'),
          ExampleSentence(sentence: 'The captain requested a lower altitude due to turbulence.', highlight: 'The captain ... a lower altitude', translation: 'Kaptan türbülans nedeniyle daha düşük bir irtifa talep etti.'),
          ExampleSentence(sentence: 'A fuel leak was found near the left engine.', highlight: 'A fuel leak', translation: 'Sol motor yakınında bir yakıt kaçağı bulundu.'),
          ExampleSentence(sentence: 'The runway is cleared for landing — wind calm.', highlight: 'The runway', translation: 'Pist inişe açık — rüzgar sakin.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.tip,
        title: '💡 Dikkat',
        body:
            'Bazı isimler sesli harfle başlamalarına rağmen "a" alır:\n• a **u**niform (yoo-niform) → sessiz ünsüz ses\n• a **eu**ropean regulation\n\nBazı kısaltmalar "an" alır:\n• an IFR flight (I = "eye" → sesli)\n• an ATC clearance (A = "ay" → sesli)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1201, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'We have declared ………… emergency due to engine failure.',
            options: ['a', 'an', 'the', '—'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1202, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… pilot in command is responsible for flight safety.',
            options: ['A', 'An', 'The', '—'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1203, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'There is ………… IFR clearance waiting for you on frequency 121.5.',
            options: ['a', 'an', 'the', '—'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1204, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The crew reported ………… unusual vibration in ………… left engine.',
            options: ['an / the', 'a / a', 'the / a', 'an / a'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 22: Pronouns ──────────────────────────────────────────
  static const pronouns = LessonContent(
    id: 'std_22',
    title: 'Zamirler',
    subtitle: 'Pronouns — kişi, iyelik ve yansımalı zamirler',
    categoryId: 'grammar',
    estimatedTime: '7 dk',
    emoji: '👤',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Zamirler neden gereklidir?',
        body:
            'Zamirler, isimlerin yerine geçerek tekrara düşmemizi engeller. Havacılık iletişiminde kısa ve net cümleler için zamiri doğru seçmek kritiktir:\n"The captain completed **his** checklist." (possessive)\n"The ATC cleared **them** for approach." (object pronoun)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Zamir Tablosu',
        body:
            '| Özne | Nesne | İyelik Sıfatı | İyelik Zamiri | Yansımalı |\n|------|-------|--------------|--------------|----------|\n| I | me | my | mine | myself |\n| you | you | your | yours | yourself |\n| he | him | his | his | himself |\n| she | her | her | hers | herself |\n| it | it | its | — | itself |\n| we | us | our | ours | ourselves |\n| they | them | their | theirs | themselves |\n\n**Dikkat:** its (iyelik) ≠ it\'s (= it is)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The first officer completed his walk-around and reported to the captain.', highlight: 'his', translation: 'Yardımcı pilot dış kontrolünü tamamladı ve kaptana rapor verdi.'),
          ExampleSentence(sentence: 'ATC instructed them to hold at the VOR.', highlight: 'them', translation: 'ATC onlara VOR\'da bekleme yapmaları talimatını verdi.'),
          ExampleSentence(sentence: 'The aircraft lost its hydraulic pressure during the approach.', highlight: 'its', translation: 'Uçak yaklaşma sırasında hidrolik basıncını kaybetti.'),
          ExampleSentence(sentence: 'We need to contact approach control ourselves.', highlight: 'We ... ourselves', translation: 'Yaklaşma kontrolüyle kendimiz iletişim kurmamız gerekiyor.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1211, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft lost ………… engine power during climb.',
            options: ['his', 'their', 'its', 'our'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1212, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'ATC instructed ………… to descend to FL100.',
            options: ['we', 'our', 'us', 'ours'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1213, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The captain briefed the crew ………… on the diversion plan.',
            options: ['himself', 'herself', 'itself', 'themselves'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1214, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The maintenance team submitted ………… report on time.',
            options: ['their', 'there', 'they', 'them'], correctIndex: 0, difficulty: Difficulty.easy),
        ],
      ),
    ],
  );

  // ── STD 23: Present Simple Keywords (from TENSES.xlsx) ────────
  static const presentSimpleKeywords = LessonContent(
    id: 'std_23',
    title: 'Geniş Zaman: Anahtar Kelimeler',
    subtitle: 'Present Simple Keywords — sıklık zarfları ve zaman belirteçleri',
    categoryId: 'grammar',
    estimatedTime: '6 dk',
    emoji: '🔑',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Geniş Zaman nasıl tanınır?',
        body:
            'Bir cümlede belirli anahtar kelimeler varsa, fiil büyük ihtimalle **Present Simple**\'dır. Özellikle sıklık zarfları (frequency adverbs) ve alışkanlık belirten ifadeler geniş zamanın ipucudur.\n\n**Kural:** Soruda zaman ipucu yoksa ve eylem genel bir gerçeği anlatıyorsa → Present Simple.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Sıklık Zarfları (Frequency Adverbs)',
        body:
            '| Zarf | Sıklık | Örnek |\n|------|--------|-------|\n| never | %0 | Pilots **never** skip safety checks. |\n| rarely / seldom / scarcely | %10 | ATC **rarely** approves that route. |\n| occasionally / sometimes | %40 | We **sometimes** divert due to weather. |\n| usually / generally / mostly / often / frequently | %60–80 | Aircraft **usually** cruise at FL350. |\n| always / all the time | %100 | The crew **always** completes the checklist. |\n\n**Diğer ipuçları:** every day/week/month, timetables, scientific truths, "date back / go back / trace back"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'Pilots never skip the pre-flight checklist.', highlight: 'never', translation: 'Pilotlar uçuş öncesi kontrol listesini hiç atlamaz.'),
          ExampleSentence(sentence: 'The aircraft sometimes diverts to an alternate due to weather.', highlight: 'sometimes', translation: 'Uçak zaman zaman hava koşulları nedeniyle alternatif pistlere sapma yapar.'),
          ExampleSentence(sentence: 'The ATIS broadcast updates every hour.', highlight: 'every hour', translation: 'ATIS yayını her saat güncellenir.'),
          ExampleSentence(sentence: 'Aviation regulations date back to the early 20th century.', highlight: 'date back', translation: 'Havacılık düzenlemeleri 20. yüzyılın başlarına dayanır.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1221, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The maintenance crew ………… performs a full inspection every 500 flight hours.',
            options: ['usually', 'yesterday', 'last week', 'at that moment'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1222, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Which word indicates Present Simple? "The flight ………… at 09:00 daily."',
            options: ['departed', 'was departing', 'departs', 'will depart'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1223, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Pilots ………… follow ATC instructions — it is mandatory.',
            options: ['always', 'yesterday', 'last year', 'at that time'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1224, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The history of commercial aviation ………… to the 1920s.',
            options: ['dated back', 'is dating back', 'dates back', 'will date back'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════
  // YENİ TEMEL (A2) DERSLERİ
  // ══════════════════════════════════════════════════════════════

  // ── STD 24: Past Simple Keywords (from TENSES.xlsx) ───────────
  static const pastSimpleKeywords = LessonContent(
    id: 'std_24',
    title: 'Geçmiş Zaman: Anahtar Kelimeler',
    subtitle: 'Past Simple Keywords — geçmiş zaman belirteçleri',
    categoryId: 'grammar',
    estimatedTime: '6 dk',
    emoji: '📅',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Past Simple nasıl tanınır?',
        body:
            'Geçmişe ait **net bir tarih veya zaman dilimi** görüyorsan → Simple Past.\nKazalar, olay raporları ve bakım kayıtlarında bu belirteçler çok sık geçer.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Simple Past Anahtar Kelimeleri',
        body:
            '**Kesin geçmiş zaman belirteçleri:**\n• yesterday, last night / week / year / month\n• ago → "two hours ago", "three days ago"\n• in + yıl → "in 1972", "in 2019"\n• between [yıl] and [yıl] → "between 1960 and 2010"\n• from [yıl] to [yıl] → "from 1999 to 2005"\n• during + dönem → "during World War II"\n• in ancient times, until recently, once\n• previously, initially, formerly, in the past\n\n**Kural:** Geçmişe ait net tarih gördüğünde → %95 Simple Past.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The aircraft departed yesterday at 0620 UTC.', highlight: 'yesterday', translation: 'Uçak dün 0620 UTC\'de kalktı.'),
          ExampleSentence(sentence: 'ICAO established international aviation standards in 1944.', highlight: 'in 1944', translation: 'ICAO uluslararası havacılık standartlarını 1944\'te oluşturdu.'),
          ExampleSentence(sentence: 'The crew reported the bird strike two hours ago.', highlight: 'two hours ago', translation: 'Ekip kuş çarpmasını iki saat önce bildirdi.'),
          ExampleSentence(sentence: 'Between 1970 and 1990, aviation safety improved dramatically.', highlight: 'Between 1970 and 1990', translation: '1970 ile 1990 arasında havacılık güvenliği dramatik biçimde gelişti.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1231, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The incident ………… three hours ago.',
            options: ['occurs', 'has occurred', 'occurred', 'is occurring'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1232, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Commercial aviation ………… rapidly between 1950 and 1970.',
            options: ['grows', 'has grown', 'grew', 'is growing'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1233, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft ………… at Sabiha Gökçen last night.',
            options: ['lands', 'has landed', 'landed', 'land'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1234, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'In the past, aircraft ………… without modern navigation aids.',
            options: ['operate', 'operated', 'have operated', 'are operating'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 25: Future Simple Keywords (from TENSES.xlsx) ─────────
  static const futureKeywords = LessonContent(
    id: 'std_25',
    title: 'Gelecek Zaman: Anahtar Kelimeler',
    subtitle: 'Future Keywords — gelecek zaman belirteçleri ve tahmin',
    categoryId: 'grammar',
    estimatedTime: '6 dk',
    emoji: '🚀',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Gelecek Zaman nasıl tanınır?',
        body:
            '**Will** ve **be going to** gelecek zamanı ifade eder. Belirli anahtar kelimeler bu yapının ipucudur.\n\n**Önemli not:** "Before long" → çok geçmeden (gelecek) / "Long before" → çok önceden (geçmiş)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Future Simple Anahtar Kelimeleri',
        body:
            '**Gelecek zaman belirteçleri:**\n• tomorrow, later today\n• next week / month / year\n• in + gelecek zaman → "in 2050", "in two hours"\n• within + süre → "within a month"\n• before long → "çok geçmeden"\n• soon, shortly\n\n**Will kullanımı:** anlık karar, tahmin, söz\n**Going to kullanımı:** önceden planlanmış eylem, kanıta dayalı tahmin\n\n⚠️ "Before long" = soon (GELECEK)\n⚠️ "Long before" = much earlier (GEÇMİŞ)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The aircraft will arrive at the gate within thirty minutes.', highlight: 'within thirty minutes', translation: 'Uçak otuz dakika içinde kapıya gelecek.'),
          ExampleSentence(sentence: 'Before long, all commercial aircraft will use sustainable fuel.', highlight: 'Before long', translation: 'Çok geçmeden tüm ticari uçaklar sürdürülebilir yakıt kullanacak.'),
          ExampleSentence(sentence: 'The next maintenance check is scheduled for next month.', highlight: 'next month', translation: 'Bir sonraki bakım kontrolü gelecek ay için planlandı.'),
          ExampleSentence(sentence: 'In 2050, electric-powered aircraft will be common.', highlight: 'In 2050', translation: '2050\'de elektrikli uçaklar yaygınlaşmış olacak.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1241, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The weather ………… improve tomorrow morning according to the TAF.',
            options: ['improves', 'improved', 'will improve', 'has improved'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1242, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '"Before long" means:',
            options: ['much earlier', 'in the past', 'very soon', 'a long time ago'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1243, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The new ATC system ………… be operational within six months.',
            options: ['was', 'will', 'has', 'is'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1244, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The flight crew ………… depart next Wednesday.',
            options: ['is going to', 'departed', 'has departed', 'departs'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 26: Conjunctions ──────────────────────────────────────
  static const conjunctions = LessonContent(
    id: 'std_26',
    title: 'Bağlaçlar',
    subtitle: 'Conjunctions — cümleleri ve fikirleri birleştirme',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '🔗',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Bağlaçlar neden önemlidir?',
        body:
            'Bağlaçlar, iki cümleyi veya fikri mantıksal bir ilişkiyle birleştirir. Havacılık raporlarında ve talimatlarında cümleleri doğru bağlamak, bilginin açık iletilmesini sağlar:\n"The engine failed **and** the crew declared an emergency."\n"The runway was wet **but** the landing was successful."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Temel Bağlaçlar',
        body:
            '**Ekleme:** and (ve), also (ayrıca), both...and (hem...hem de)\n  → The captain **and** the co-pilot completed the checklist.\n\n**Zıtlık:** but (ama), yet (oysa), although / even though (karşın), while (oysa ki)\n  → The weather was poor, **but** the flight continued.\n\n**Neden:** because (çünkü), since (için), as (için)\n  → We diverted **because** the destination was below minimums.\n\n**Sonuç:** so (bu yüzden), therefore, thus\n  → Fuel was low, **so** the crew requested priority.\n\n**Koşul:** if (eğer), unless (eğer...masaydı), provided that\n  → **Unless** the weather improves, we will divert.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The aircraft had a hydraulic failure, but the crew managed a safe landing.', highlight: 'but', translation: 'Uçakta hidrolik arızası oluştu, ancak ekip güvenli bir iniş yaptı.'),
          ExampleSentence(sentence: 'We cannot depart unless ATC gives a slot time.', highlight: 'unless', translation: 'ATC bir kalkış zamanı vermediği sürece hareket edemeyiz.'),
          ExampleSentence(sentence: 'Both the captain and the first officer confirmed the checklist items.', highlight: 'Both ... and', translation: 'Hem kaptan hem de yardımcı pilot kontrol listesi maddelerini onayladı.'),
          ExampleSentence(sentence: 'The approach was unstable, so the crew executed a go-around.', highlight: 'so', translation: 'Yaklaşma kararsızdı, bu yüzden ekip tekrar tur yaptı.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1251, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft cannot take off ………… the de-icing is completed.',
            options: ['but', 'unless', 'and', 'because'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1252, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The engine failed, ………… the crew declared MAYDAY.',
            options: ['although', 'unless', 'so', 'yet'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1253, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… the conditions were dangerous, the captain chose to continue.',
            options: ['Because', 'Although', 'So', 'Unless'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1254, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The crew could not land ………… the runway was occupied.',
            options: ['so', 'but', 'because', 'although'], correctIndex: 2, difficulty: Difficulty.easy),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════
  // YENİ ORTA (B1) DERSLERİ
  // ══════════════════════════════════════════════════════════════

  // ── STD 27: Present Perfect Keywords (from TENSES.xlsx) ───────
  static const presentPerfectKeywords = LessonContent(
    id: 'std_27',
    title: 'Present Perfect: Anahtar Kelimeler',
    subtitle: 'Present Perfect Keywords — since, for, yet, already, just',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '⏱️',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Present Perfect nasıl tanınır?',
        body:
            'Present Perfect (have/has + V3) belirli anahtar kelimelerle gelir. Bu kelimeleri tanımak soru çözümünde büyük avantaj sağlar.\n\n**FIDOW kuralı:** For, In (the past), During, Once/Over, While + geçmiş dönem → Present Perfect',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Present Perfect Anahtar Kelimeleri',
        body:
            '**since** → belirli bir başlangıç noktasından beri\n  → The aircraft has been grounded **since** Monday.\n\n**for** → belirli bir süre boyunca\n  → The captain has flown **for** twenty years.\n\n**just** → az önce\n  → The crew has **just** received the updated clearance.\n\n**already** → beklenden önce gerçekleşti\n  → Engineering has **already** inspected the engine.\n\n**yet** → henüz (soru/olumsuz cümlelerde)\n  → Has the aircraft been refuelled **yet**?\n\n**ever / never** → hiç / hiç olmamak\n  → Have you **ever** declared an emergency?\n\n**lately / recently / so far / up to now / all my life** → yakın dönem etkisi',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The maintenance team has just completed the engine inspection.', highlight: 'has just completed', translation: 'Bakım ekibi motor incelemesini az önce tamamladı.'),
          ExampleSentence(sentence: 'This aircraft has never experienced a bird strike since its delivery.', highlight: 'has never ... since', translation: 'Bu uçak teslimattan bu yana hiç kuş çarpması yaşamamış.'),
          ExampleSentence(sentence: 'Have you received the updated ATIS yet?', highlight: 'yet', translation: 'Güncellenmiş ATIS\'i aldınız mı henüz?'),
          ExampleSentence(sentence: 'The runway has been closed for three hours due to FOD.', highlight: 'has been closed for', translation: 'Pist FOD nedeniyle üç saattir kapalı.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1261, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The co-pilot ………… the approach briefing yet.',
            options: ['did not complete', 'has not completed', 'not completed', 'was not completing'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1262, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The crew ………… for this airline since 2015.',
            options: ['works', 'worked', 'has worked', 'is working'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1263, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… you ever flown in zero-visibility conditions?',
            options: ['Did', 'Have', 'Do', 'Are'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1264, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The ATC controller ………… just cleared the aircraft for departure.',
            options: ['had', 'was', 'has', 'did'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 28: Past Perfect Keywords (from TENSES.xlsx) ──────────
  static const pastPerfectKeywords = LessonContent(
    id: 'std_28',
    title: 'Past Perfect: Anahtar Kelimeler',
    subtitle: 'Past Perfect Keywords — before, after, by the time',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '⏪',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Past Perfect nasıl tanınır?',
        body:
            'Past Perfect (had + V3), geçmişteki iki olaydan **önce gerçekleşeni** anlatır. Havacılık kaza soruşturmalarında olayların sırasını belirtmek için kritiktir.\n\n**Not:** Past Perfect her zaman zorunlu değildir — ancak kronolojik sırayı vurgulamak istediğinde kullanılır.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Past Perfect Anahtar Kelimeleri',
        body:
            '**before** → önce (önceki eylem = Past Perfect)\n  → The crew had completed the checklist **before** they started the engines.\n\n**after** → sonra (önceki eylem = Past Perfect)\n  → **After** the crew **had briefed** the emergency, they executed the approach.\n\n**by the time** → ...-dığında (önceki eylem = Past Perfect)\n  → **By the time** the fire crew arrived, the aircraft **had landed** safely.\n\n**by + geçmiş tarih** → ... itibarıyla (eylem o zamana kadar tamamlanmış)\n  → By 2010, TCAS had become mandatory on all airliners.\n\n**until / as soon as / once / while** → bağlaç olarak Past Perfect tetikler',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The aircraft had already landed before the rescue team was alerted.', highlight: 'had already landed ... before', translation: 'Kurtarma ekibine haber verilmeden önce uçak çoktan inmişti.'),
          ExampleSentence(sentence: 'By the time the controller noticed, the aircraft had entered the runway.', highlight: 'By the time ... had entered', translation: 'Kontrolör fark ettiğinde uçak piste girmiş bulunuyordu.'),
          ExampleSentence(sentence: 'After the crew had completed the checklist, they requested pushback.', highlight: 'had completed', translation: 'Ekip kontrol listesini tamamladıktan sonra geri itme talebinde bulundu.'),
          ExampleSentence(sentence: 'By 1970, jet travel had transformed commercial aviation.', highlight: 'By 1970 ... had transformed', translation: '1970\'e gelindiğinde jet uçuşu ticari havacılığı dönüştürmüştü.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1271, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'By the time the engineer arrived, the crew ………… the fault.',
            options: ['already isolated', 'has already isolated', 'had already isolated', 'already isolates'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1272, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'After the crew ………… the emergency checklist, they declared MAYDAY.',
            options: ['completed', 'had completed', 'have completed', 'completing'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1273, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… the time the relief crew arrived, the original crew ………… for 12 hours.',
            options: ['By / had flown', 'Until / flew', 'After / have flown', 'Before / had flown'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1274, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'By 2000, GPS navigation ………… standard on most commercial aircraft.',
            options: ['becomes', 'became', 'had become', 'has become'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 29: Passive Voice Basic ───────────────────────────────
  static const passiveVoiceBasic = LessonContent(
    id: 'std_29',
    title: 'Edilgen Çatı (Temel)',
    subtitle: 'Passive Voice — eylemin nesnesini öne çıkarmak',
    categoryId: 'grammar',
    estimatedTime: '9 dk',
    emoji: '⚙️',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Edilgen Çatı neden kullanılır?',
        body:
            'Edilgen çatı (Passive Voice), eylemi yapanı değil **yapılanı** ön plana çıkarır. Havacılık prosedür dokümanlarında ve kaza raporlarında çok yaygındır:\n"The aircraft **was inspected** before departure." (kim yaptığı değil, ne yapıldığı önemli)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**am/is/are + V3** → Present Passive\n  → The checklist **is completed** before every flight.\n\n**was/were + V3** → Past Passive\n  → The fault **was found** during the pre-flight check.\n\n**will be + V3** → Future Passive\n  → The engine **will be replaced** next week.\n\n**have/has been + V3** → Present Perfect Passive\n  → The aircraft **has been serviced** and is ready.\n\nFail eden kişiyi belirtmek için: **by** + agent\n  → The report was signed **by** the captain.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The runway is closed for resurfacing every winter.', highlight: 'is closed', translation: 'Pist her kış asfaltlama için kapatılır.'),
          ExampleSentence(sentence: 'The aircraft was cleared for landing by Istanbul Approach.', highlight: 'was cleared ... by', translation: 'Uçak İstanbul Yaklaşma tarafından inişe onaylandı.'),
          ExampleSentence(sentence: 'The technical defect has been corrected and the aircraft is serviceable.', highlight: 'has been corrected', translation: 'Teknik arıza giderildi ve uçak uçuşa elverişli.'),
          ExampleSentence(sentence: 'All new procedures will be implemented by January 2026.', highlight: 'will be implemented', translation: 'Tüm yeni prosedürler Ocak 2026\'ya kadar uygulamaya konacak.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1281, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft ………… to the hangar for a full inspection last night.',
            options: ['taken', 'was taken', 'is taken', 'takes'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1282, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'All maintenance records ………… by the certifying engineer.',
            options: ['are signed', 'sign', 'signing', 'to sign'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1283, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The safety bulletin ………… to all airlines by next Monday.',
            options: ['sends', 'will be sent', 'was sent', 'has sent'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1284, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The investigation report ………… already ………… by the safety board.',
            options: ['has / been published', 'was / published', 'is / publishing', 'had / published'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════
  // YENİ İLERİ (B2-C1) DERSLERİ
  // ══════════════════════════════════════════════════════════════

  // ── STD 30: Must / Should / Have to ───────────────────────────
  static const mustShouldHaveTo = LessonContent(
    id: 'std_30',
    title: 'Must, Should, Have to',
    subtitle: 'Obligation & Advice — zorunluluk ve tavsiye',
    categoryId: 'grammar',
    estimatedTime: '9 dk',
    emoji: '⚠️',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Zorunluluk ve tavsiye',
        body:
            'Havacılıkta güvenlik talimatları ve prosedürler sıklıkla **must**, **should** ve **have to** ile ifade edilir. Bu üç modal\'ın farkını bilmek hem sınav hem uçuş güvenliği açısından önemlidir.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Kullanım Tablosu',
        body:
            '**must** → iç zorunluluk, kural / regülasyon (güçlü)\n  → Pilots **must** hold a valid medical certificate.\n  → Olumsuz: **must not** = yasak!\n\n**have to / has to** → dış zorunluluk, koşulların getirdiği mecburiyet\n  → We **have to** divert — fuel is critical.\n  → Olumsuz: **don\'t have to** = gerek yok (yasak değil!)\n\n**should / ought to** → tavsiye, beklenti, öneri\n  → You **should** review the weather before every flight.\n  → Olumsuz: **should not** = tavsiye edilmez\n\n⚠️ must not ≠ don\'t have to:\n• "You **must not** enter the runway." (kesinlikle yasak)\n• "You **don\'t have to** wear a jacket." (gerek yok, ama yasak değil)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'All crew members must wear their ID badges in the security zone.', highlight: 'must wear', translation: 'Tüm ekip üyeleri güvenlik bölgesinde kimlik kartı takmalıdır.'),
          ExampleSentence(sentence: 'You should always brief the alternate fuel requirements before departure.', highlight: 'should always brief', translation: 'Kalkıştan önce her zaman alternatif yakıt gereksinimlerini brifing etmelisiniz.'),
          ExampleSentence(sentence: 'We have to go around — the runway is not clear.', highlight: 'have to go around', translation: 'Tekrar tur yapmak zorundayız — pist açık değil.'),
          ExampleSentence(sentence: 'Passengers must not use electronic devices during takeoff.', highlight: 'must not', translation: 'Yolcular kalkış sırasında elektronik cihaz kullanmamalıdır.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1291, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Crew members ………… enter the cockpit without authorisation.',
            options: ['should not', 'must not', 'don\'t have to', 'ought not'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1292, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'You ………… carry a parachute on this training flight — it is optional.',
            options: ['must not', 'should not', 'don\'t have to', 'cannot'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1293, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The TCAS RA said "CLIMB" — the crew ………… follow it immediately.',
            options: ['should', 'must', 'have to', 'both b and c'], correctIndex: 3, difficulty: Difficulty.medium),
          QuestionModel(id: -1294, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'We ………… divert — our fuel has dropped below the final reserve.',
            options: ['should', 'must', 'have to', 'ought to'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 31: Tag Questions ─────────────────────────────────────
  static const tagQuestions = LessonContent(
    id: 'std_31',
    title: 'Ek Sorular',
    subtitle: 'Tag Questions — onay ve bilgi doğrulama',
    categoryId: 'grammar',
    estimatedTime: '7 dk',
    emoji: '❔',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Ek Soru nedir?',
        body:
            'Ek sorular (tag questions), cümlenin sonuna eklenerek **onay veya doğrulama** amacı taşır. Havacılık brifinglerinde ve ekip iletişiminde "readback" benzeri bir işlev görür:\n"The runway is clear, **isn\'t it?**"\n"You\'ve received the ATIS, **haven\'t you?**"',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı Kuralı',
        body:
            '**Olumlu cümle → Olumsuz tag**\n  → The aircraft is serviceable, **isn\'t it?**\n  → The crew completed the check, **didn\'t they?**\n\n**Olumsuz cümle → Olumlu tag**\n  → The fuel hasn\'t been loaded yet, **has it?**\n  → We can\'t continue, **can we?**\n\n**Kural:** Cümledeki yardımcı fiil tag\'de tekrarlanır.\n• am/is/are → isn\'t/aren\'t / am I?\n• was/were → wasn\'t/weren\'t?\n• have/has → haven\'t/hasn\'t?\n• will → won\'t?\n• can → can\'t?\n• do/does → don\'t/doesn\'t?\n• did → didn\'t?\n\n**I am → aren\'t I?** (özel kural)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The fuel has been uploaded, hasn\'t it?', highlight: 'hasn\'t it', translation: 'Yakıt yüklendi, değil mi?'),
          ExampleSentence(sentence: 'We can\'t take off in these conditions, can we?', highlight: 'can we', translation: 'Bu koşullarda kalkış yapamayız, değil mi?'),
          ExampleSentence(sentence: 'The captain briefed the crew, didn\'t she?', highlight: 'didn\'t she', translation: 'Kaptan ekibi brifing etti, değil mi?'),
          ExampleSentence(sentence: 'The NOTAM mentions runway closures, doesn\'t it?', highlight: 'doesn\'t it', translation: 'NOTAM pist kapatmalarından bahsediyor, değil mi?'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1301, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The maintenance release has been signed, ………… ?',
            options: ['isn\'t it', 'hasn\'t it', 'didn\'t it', 'wasn\'t it'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1302, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'We can\'t proceed without ATC clearance, ………… ?',
            options: ['can\'t we', 'can we', 'don\'t we', 'aren\'t we'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1303, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The captain will brief the cabin crew before boarding, ………… ?',
            options: ['will he', 'won\'t he', 'doesn\'t he', 'didn\'t he'], correctIndex: 1, difficulty: Difficulty.medium),
          QuestionModel(id: -1304, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft was grounded for inspection last week, ………… ?',
            options: ['wasn\'t it', 'isn\'t it', 'hasn\'t it', 'didn\'t it'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 32: Wish / If Only ────────────────────────────────────
  static const wishIfOnly = LessonContent(
    id: 'std_32',
    title: 'Wish & If Only',
    subtitle: 'Wishes & Regrets — gerçekleşmeyenler için dilekler',
    categoryId: 'grammar',
    estimatedTime: '9 dk',
    emoji: '🌠',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Wish ve If Only ne anlama gelir?',
        body:
            '**Wish** ve **If only**, gerçekleşmesini istediğimiz ama gerçek olmayan durumları ya da geçmişteki pişmanlıkları ifade eder.\n\nHavacılık kaza analizlerinde sıkça kullanılır:\n"I **wish** the crew had followed the checklist."\n"**If only** the weather had been better."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Yapı',
        body:
            '**Şimdiki gerçekdışı dilek → Past Simple**\n  → I **wish** I **had** more fuel. (şu an yok)\n  → **If only** the runway **were** longer. (şu an değil)\n\n**Geçmişteki pişmanlık → Past Perfect**\n  → I **wish** the crew **had** noticed the warning earlier.\n  → **If only** we **hadn\'t taken** that route.\n\n**Gelecek değişim isteği → would + V1**\n  → I **wish** the controller **would** give us a lower altitude.\n  → I **wish** the weather **would** improve.\n\n**If only = Wish** (daha güçlü, dramatik anlatım)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'I wish we had more fuel — diversion is now unavoidable.', highlight: 'wish we had', translation: 'Keşke daha fazla yakıtımız olsaydı — sapma artık kaçınılmaz.'),
          ExampleSentence(sentence: 'If only the crew had checked the weather before departure.', highlight: 'If only ... had checked', translation: 'Keşke ekip kalkıştan önce havayı kontrol etmiş olsaydı.'),
          ExampleSentence(sentence: 'I wish ATC would give us a direct routing — we are running low on fuel.', highlight: 'wish ATC would give', translation: 'Keşke ATC bize doğrudan rota verse — yakıtımız azalıyor.'),
          ExampleSentence(sentence: 'If only the maintenance team had caught the fault earlier.', highlight: 'had caught ... earlier', translation: 'Keşke bakım ekibi arızayı daha erken fark etmiş olsaydı.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1311, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'I wish the de-icing ………… completed before the weather got worse.',
            options: ['is', 'were', 'had been', 'will be'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1312, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'If only the runway ………… longer — we could operate heavier aircraft.',
            options: ['is', 'was', 'were', 'has been'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1313, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'I wish the dispatcher ………… us about the NOTAM closure earlier.',
            options: ['tells', 'told', 'had told', 'would tell'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1314, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The captain wished ATC ………… a lower altitude.',
            options: ['approves', 'approved', 'would approve', 'had approved'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 33: Used to / Would ───────────────────────────────────
  static const usedToWould = LessonContent(
    id: 'std_33',
    title: 'Used to & Would',
    subtitle: 'Past Habits — geçmişteki alışkanlıklar ve tekrarlanan eylemler',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '🔁',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Geçmişteki alışkanlıklar',
        body:
            '**Used to** ve **would**, geçmişte tekrarlanan ama artık yapılmayan eylemleri anlatır. Havacılık tarihini ve eski prosedürleri anlatırken sıkça kullanılır:\n"Pilots **used to** navigate by stars before GPS."\n"Mechanics **would** overhaul engines every 1,000 hours."',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Fark ve Kullanım',
        body:
            '**Used to + V1** → geçmiş alışkanlıklar VE geçmiş durumlar\n  → Aircraft **used to** have fewer safety systems. (eski durum)\n  → The crew **used to** file paper flight plans. (alışkanlık)\n\n**Would + V1** → yalnızca geçmiş tekrarlayan eylemler (durum için kullanılmaz!)\n  → The captain **would** always check the weather three times. (alışkanlık ✓)\n  → ✗ The airport **would** be smaller. → ✓ The airport **used to be** smaller.\n\n**Olumsuz:**\n  → Pilots didn\'t **use to** have autopilot systems.\n  → They **wouldn\'t** depart without a manual weather check.\n\n**Soru:**\n  → **Did** pilots **use to** navigate differently?',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'Pilots used to navigate by radio beacons before GPS became available.', highlight: 'used to navigate', translation: 'Pilotlar GPS yaygınlaşmadan önce radyo işaretçileriyle seyrüsefer yapardı.'),
          ExampleSentence(sentence: 'The old training syllabus would include celestial navigation exercises.', highlight: 'would include', translation: 'Eski eğitim müfredatı gök cisimleri seyrüseferi alıştırmalarını kapsardı.'),
          ExampleSentence(sentence: 'Aircraft used to be smaller and less fuel-efficient.', highlight: 'used to be', translation: 'Uçaklar eskiden daha küçük ve daha az yakıt verimli olurdu.'),
          ExampleSentence(sentence: 'Did pilots use to file paper flight plans in the 1970s?', highlight: 'Did ... use to', translation: 'Pilotlar 1970\'lerde kâğıt uçuş planı doldurur muydu?'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1321, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Airlines ………… require passengers to show paper tickets before boarding.',
            options: ['would', 'used to', 'both a and b', 'will'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1322, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Cockpit voice recorders ………… exist in early commercial aircraft.',
            options: ['didn\'t use to', 'wouldn\'t', 'used to not', 'didn\'t would'], correctIndex: 0, difficulty: Difficulty.medium),
          QuestionModel(id: -1323, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The control tower ………… guide aircraft using light signals before radio.',
            options: ['used to', 'would', 'both a and b', 'has'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1324, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The hangar ………… much bigger — it could accommodate 10 aircraft.',
            options: ['would be', 'used to be', 'was used to be', 'would being'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 34: Quantifiers ───────────────────────────────────────
  static const quantifiers = LessonContent(
    id: 'std_34',
    title: 'Miktar Belirleyiciler',
    subtitle: 'Quantifiers — some, any, much, many, a lot of, few',
    categoryId: 'grammar',
    estimatedTime: '8 dk',
    emoji: '🔢',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Miktar belirleyiciler neden önemlidir?',
        body:
            'Havacılık iletişiminde yakıt miktarı, görüş mesafesi ve yolcu sayısı gibi nicelikler doğru kelimelerle ifade edilmelidir:\n"We have **little** fuel remaining." (az ama belirtilebilir)\n"There is **no** fuel reserve." (hiç yok)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Sayılabilen ve Sayılamayan İsimler',
        body:
            '**Sayılabilen isimler (countable):** passenger, flight, error, runway\n**Sayılamayan isimler (uncountable):** fuel, turbulence, visibility, information\n\n| Miktar | Sayılabilen | Sayılamayan |\n|--------|------------|-------------|\n| Az (olumsuz) | few | little |\n| Az (yeterli) | a few | a little |\n| Çok | many | much |\n| Genel çok | a lot of / lots of | a lot of |\n| Bazı (olumlu) | some | some |\n| Bazı (olumsuz/soru) | any | any |\n| Hiç | no / none | no / none |\n\n✓ We have **a few** minutes before pushback.\n✓ There is **little** time to complete the checklist.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'We have very little fuel — we must divert immediately.', highlight: 'very little', translation: 'Çok az yakıtımız var — derhal sapma yapmalıyız.'),
          ExampleSentence(sentence: 'There were a few passengers who needed medical assistance.', highlight: 'a few', translation: 'Tıbbi yardıma ihtiyaç duyan birkaç yolcu vardı.'),
          ExampleSentence(sentence: 'Is there any ice on the wings?', highlight: 'any', translation: 'Kanatlarda herhangi bir buz var mı?'),
          ExampleSentence(sentence: 'Many airports have implemented new noise abatement procedures.', highlight: 'Many', translation: 'Pek çok havalimanı yeni gürültü azaltma prosedürleri uygulamaya koymuştur.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1331, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'We have ………… fuel — just enough to reach the alternate.',
            options: ['few', 'little', 'many', 'much'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1332, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Are there ………… passengers who have not boarded yet?',
            options: ['some', 'any', 'much', 'little'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1333, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: '………… engineers have been trained on the new system so far.',
            options: ['Much', 'A little', 'A few', 'Little'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1334, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'There is ………… turbulence expected — the ride will be smooth.',
            options: ['no', 'any', 'some', 'many'], correctIndex: 0, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 35: Phrasal Verbs ─────────────────────────────────────
  static const phrasalVerbs = LessonContent(
    id: 'std_35',
    title: 'Deyimsel Fiiller',
    subtitle: 'Phrasal Verbs — havacılıkta sık kullanılan yapılar',
    categoryId: 'vocabulary',
    estimatedTime: '9 dk',
    emoji: '✈️',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Phrasal Verb nedir?',
        body:
            'Deyimsel fiiller (phrasal verbs), bir fiil + edat/zarf kombinasyonuyla oluşur ve genellikle özgün bir anlam taşır. Havacılık İngilizcesinde radyo konuşmalarından teknik dokümanlara kadar her yerde karşılaşırsın.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Havacılıkta Temel Phrasal Verbs',
        body:
            '**take off** → kalkış yapmak\n  → The aircraft **took off** at 0830 UTC.\n\n**touch down** → inmek, piste değmek\n  → We **touched down** on runway 36 at 1420.\n\n**set out** → yola çıkmak, başlamak\n  → The crew **set out** on a 12-hour duty.\n\n**carry out** → gerçekleştirmek, uygulamak\n  → Engineers **carry out** a 500-hour check.\n\n**hand over** → devretmek, teslim etmek\n  → ATC **handed over** the flight to Istanbul Radar.\n\n**run out of** → tükenmek\n  → We are about to **run out of** fuel.\n\n**hold up** → geciktirmek\n  → The departure was **held up** by a technical fault.\n\n**call off** → iptal etmek\n  → The approach was **called off** due to windshear.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The captain called off the approach after receiving a windshear alert.', highlight: 'called off', translation: 'Kaptan rüzgar tepmesi alarmı aldıktan sonra yaklaşmayı iptal etti.'),
          ExampleSentence(sentence: 'Maintenance carried out a full inspection after the hard landing.', highlight: 'carried out', translation: 'Bakım, sert inişin ardından tam bir kontrol gerçekleştirdi.'),
          ExampleSentence(sentence: 'We are running out of fuel — request immediate descent.', highlight: 'running out of', translation: 'Yakıtımız tükeniyor — acil alçalma talep ediyoruz.'),
          ExampleSentence(sentence: 'Istanbul Control handed over the flight to Ankara Approach.', highlight: 'handed over', translation: 'İstanbul Kontrol uçuşu Ankara Yaklaşmaya devretti.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1341, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The flight was ………… due to a technical defect found during pre-flight.',
            options: ['held up', 'run out', 'taken off', 'set out'], correctIndex: 0, difficulty: Difficulty.easy),
          QuestionModel(id: -1342, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Engineers need to ………… a complete engine run-up before the first flight of the day.',
            options: ['call off', 'carry out', 'hand over', 'run out of'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1343, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The captain ………… the approach when the runway was reported as contaminated.',
            options: ['carried out', 'ran out of', 'called off', 'set out'], correctIndex: 2, difficulty: Difficulty.medium),
          QuestionModel(id: -1344, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The flight was ………… to Ankara Radar when leaving Istanbul\'s airspace.',
            options: ['held up', 'handed over', 'called off', 'run out of'], correctIndex: 1, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );

  // ── STD 36: Word Formation ────────────────────────────────────
  static const wordFormation = LessonContent(
    id: 'std_36',
    title: 'Sözcük Türetme',
    subtitle: 'Word Formation — prefix, suffix ve türetme kuralları',
    categoryId: 'vocabulary',
    estimatedTime: '9 dk',
    emoji: '🧱',
    lessonType: LessonType.standard,
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Sözcük türetme neden önemlidir?',
        body:
            'ICAO dil testlerinde kelime türetme sıkça sınananır. Bir kelimenin kök anlamını bilerek ön ek (prefix) ve son ek (suffix) kurallarını uygulamak, bilinmeyen kelimelerin anlamını tahmin etmemizi sağlar.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Temel Prefix ve Suffix\'ler',
        body:
            '**Olumsuz yapan prefix\'ler:**\n• un- → unserviceable, unsafe, unplanned\n• in-/im- → inaccurate, incomplete, impossible\n• dis- → disconnect, disembark, disallow\n• mis- → misread, miscommunicate, misidentify\n• non- → non-essential, non-standard, non-precision\n\n**İsim yapan suffix\'ler:**\n• -tion/-sion → navigation, inspection, revision\n• -ment → assessment, adjustment, deployment\n• -ity → visibility, stability, capability\n• -ance/-ence → clearance, turbulence, performance\n• -er/-or → controller, operator, inspector\n\n**Sıfat yapan suffix\'ler:**\n• -able/-ible → serviceable, controllable, visible\n• -al → procedural, operational, technical\n• -ous → hazardous, numerous, continuous',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Örnekler',
        examples: [
          ExampleSentence(sentence: 'The aircraft is unserviceable and must not be flown.', highlight: 'unserviceable (un + service + able)', translation: 'Uçak uçuşa elverişsiz ve uçurulmamalıdır.'),
          ExampleSentence(sentence: 'Poor visibility reduced the operational capability of the airport.', highlight: 'visibility / operational / capability', translation: 'Düşük görüş havalimanının operasyonel kapasitesini düşürdü.'),
          ExampleSentence(sentence: 'A miscommunication between the crew and ATC led to the incident.', highlight: 'miscommunication (mis + communication)', translation: 'Ekip ve ATC arasındaki iletişim hatası olaya yol açtı.'),
          ExampleSentence(sentence: 'The non-precision approach requires higher weather minima.', highlight: 'non-precision', translation: 'Kesin olmayan yaklaşma daha yüksek hava minimumları gerektirir.'),
        ],
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Pratik',
        practiceQuestions: [
          QuestionModel(id: -1351, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The sensor gave an ………… reading — it must be faulty.',
            options: ['accurate', 'inaccurate', 'accurately', 'accuracy'], correctIndex: 1, difficulty: Difficulty.easy),
          QuestionModel(id: -1352, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'Poor ………… conditions delayed all departures for two hours.',
            options: ['visible', 'visibly', 'visibility', 'vision'], correctIndex: 2, difficulty: Difficulty.easy),
          QuestionModel(id: -1353, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The crew ………… the landing gear selector — the gear did not retract.',
            options: ['missed', 'misread', 'misidentified', 'misoperated'], correctIndex: 3, difficulty: Difficulty.medium),
          QuestionModel(id: -1354, category: QuestionCategory.grammar, originalNumber: 0,
            questionText: 'The aircraft is not ………… for passenger service due to the unresolved defect.',
            options: ['operate', 'operation', 'operational', 'operationally'], correctIndex: 2, difficulty: Difficulty.medium),
        ],
      ),
    ],
  );
}
