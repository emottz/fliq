import '../models/lesson_content_model.dart';
import '../models/question_model.dart';

/// All lesson content. Practice questions are embedded directly so they
/// remain self-contained even before the JSON question bank is loaded.
class LessonContentData {
  LessonContentData._();

  static const List<LessonContent> all = [
    // ── BEGINNER ──────────────────────────────────────────────
    _passiveVoice,
    _modalVerbs,
    _simpleTenses,
    _aircraftComponents,
    _airportGround,
    _safetyEquipment,
    _atcFillBlanks,
    _preflightChecklist,
    // ── ELEMENTARY ────────────────────────────────────────────
    _conditionals,
    _weatherNavigation,
    _emergencyVocab,
    _atcPhraseology,
    _metarTranslation,
    _approachLanding,
    _atisReading,
    // ── INTERMEDIATE ──────────────────────────────────────────
    _notamReading,
    _reportedSpeech,
    _articlesAviation,
    _instrumentSystems,
    _flightPlanReading,
    _engineFailureLanguage,
    _opsManualTranslation,
    _emergencyCompletion,
    // ── ADVANCED ──────────────────────────────────────────────
    _complexStructures,
    _expertVocab,
    _sidStarReading,
    _accidentReport,
    _cat3Completion,
    _advancedAtcClearances,
    _accidentTranslation,
    _airworthinessDirectives,
    _advancedCompletion,
  ];

  static LessonContent? findById(String id) {
    try {
      return all.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // LESSON 1 — Passive Voice
  // ─────────────────────────────────────────────────────────────
  static const _passiveVoice = LessonContent(
    id: 'grammar_1',
    title: 'Passive Voice',
    subtitle: 'How aviation tasks are described',
    categoryId: 'grammar',
    estimatedTime: '10 min',
    emoji: '🔧',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Why passive voice matters in aviation',
        body:
            'Aviation English relies heavily on the **passive voice**. Maintenance manuals, checklists, and ATC instructions frequently use passive constructions because **the action is more important than who performs it**.\n\nFor example, "The fuel filter must be replaced" is more precise and professional than "You must replace the fuel filter."',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'See the transformation',
        animationType: GrammarAnimationType.passiveVoice,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Formation Rule',
        body:
            '**Active:** Subject + **verb** + object\n**Passive:** Object + **be** + past participle (+ by + agent)\n\n**Tense mapping:**\n• Simple Present → is/are + V3\n• Simple Past → was/were + V3\n• Must/Should → must/should + be + V3\n• Has/Have → has/have + been + V3',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Aviation Examples',
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
        type: LessonSectionType.tip,
        title: '✈️ Exam Tip',
        body:
            'In multiple-choice questions, look for clues:\n• If the subject is a **thing** (not a person), passive is likely correct.\n• "………… by the engine" → passive form needed.\n• Modal verbs + passive: **must be + past participle** is the most common pattern in aviation maintenance English.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Modal Verbs in Aviation',
    subtitle: 'must, should, may, can — knowing when to use each',
    categoryId: 'grammar',
    estimatedTime: '12 min',
    emoji: '📋',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Modals express obligation and permission',
        body:
            'Modal verbs are essential in aviation English because they express **degrees of obligation**. The difference between "must" and "should" can have safety implications.\n\n**must** = mandatory (regulatory requirement)\n**should** = recommended (best practice)\n**may** = permitted (allowed)\n**can** = ability / theoretical possibility',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Modal strength spectrum',
        animationType: GrammarAnimationType.modalVerbs,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Modal + Verb Structure',
        body:
            '**Rule:** Modal verb + **base infinitive** (no "to", no "-s", no "-ing")\n\n✓ The pilot **must check** the fuel level.\n✗ The pilot must **checks** / must **checking** / must **to check**\n\n**With passive:**\nModal + **be** + past participle\n✓ The engine **must be shut down** before maintenance.\n✓ Parts **should be inspected** visually.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Modals in Context',
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
        title: '✈️ Exam Tip',
        body:
            'Common distractors in modal questions:\n• "must checking" → WRONG (modal + base form, not -ing)\n• "should to inspect" → WRONG (no "to" after modals)\n• "must performed" → WRONG (passive needs "be": must **be** performed)\n\nIf you see a modal verb + gap, check: is an active or passive meaning needed?',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Aircraft Components',
    subtitle: 'Key technical vocabulary for exams',
    categoryId: 'vocabulary',
    estimatedTime: '8 min',
    emoji: '✈️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Why technical vocabulary matters',
        body:
            'Aviation exams test your ability to understand and use precise technical terms. A technician saying "the thing that lifts the plane" instead of "the **aileron**" is unprofessional and dangerous.\n\nThis lesson covers the most frequently tested components grouped by aircraft system.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛩️ Flight Control Surfaces',
        body:
            '**Ailerons** — on the wings; control roll (bank left/right)\n**Elevator** — on the horizontal stabilizer; controls pitch (nose up/down)\n**Rudder** — on the vertical stabilizer; controls yaw (nose left/right)\n**Flaps** — on wing trailing edge; increase lift and drag during takeoff/landing\n**Spoilers** — on wings; reduce lift, increase drag, assist in roll control',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚙️ Powerplant & Fuel Systems',
        body:
            '**Turbine engine** — compressor → combustion chamber → turbine → nozzle\n**HP fuel shutoff valve** — high-pressure fuel control valve\n**Fuel manifold** — distributes fuel to combustion chambers\n**Gearbox** — transfers power between engine components\n**Nacelle** — streamlined housing enclosing the engine',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔧 Hydraulic & Landing Gear',
        body:
            '**Hydraulic actuator** — converts hydraulic pressure to mechanical movement\n**Hydraulic pump** — pressurizes hydraulic fluid\n**Landing gear strut** — shock-absorbing leg of landing gear\n**Torque link** — scissors linkage preventing wheel rotation on strut\n**Brake assembly** — disc brakes on main landing gear wheels',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'In-Context Examples',
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
        title: '✈️ Exam Tip',
        body:
            'Vocabulary questions often ask for **synonyms**. Common traps:\n• "nacelle" ≠ "fuselage" (nacelle is the engine housing)\n• "aileron" controls **roll**, not yaw\n• "elevator" controls **pitch**, not roll\n\nMemory trick: **A**ileron → **A**xis of roll, **E**levator → **E**levation (pitch), **R**udder → **R**otation around yaw axis.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Fill in the Blanks: ATC',
    subtitle: 'Completing ATC communication phrases',
    categoryId: 'fill_blanks',
    estimatedTime: '9 min',
    emoji: '🗼',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'ATC phraseology is standardized',
        body:
            'Air Traffic Control communications follow ICAO standard phraseology. Fill-in-the-blank questions test whether you know the **exact words** used in clearances, instructions, and readbacks.\n\nThe key is understanding the **structure** of each phrase type so you can identify the missing word even without memorizing every phrase.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛫 Clearance Structure',
        body:
            'A standard ATC clearance follows this pattern:\n\n**Aircraft ID** + clearance limit + route + altitude + speed + squawk\n\nExample: "THY123, **cleared to** Istanbul, via KEMER, **climb and maintain** FL350, squawk 4521."\n\nKey verbs: **cleared**, **maintain**, **climb**, **descend**, **turn**, **contact**, **report**',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📻 Readback Rules',
        body:
            'Pilots must **read back** all:\n• Runway in use\n• Altimeter settings\n• Altitude/flight level\n• Heading instructions\n• Speed instructions\n• Frequency changes\n• Transponder codes\n• Taxi instructions (at controlled airports)\n\n**Standard phrase:** "Cleared to FL350, THY123." (call sign at end in readback)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Phraseology Examples',
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
        title: '✈️ Exam Strategy',
        body:
            'For fill-in-the-blank ATC questions:\n1. Read the **whole sentence** first — understand the situation\n2. Identify the **verb type** needed (is it a clearance, instruction, or report?)\n3. Use **elimination** — remove grammatically wrong options first\n4. Check for **prepositions**: "cleared **to**", "cleared **for**", "climb **to**", "maintain **at**"',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Conditional Sentences',
    subtitle: 'Real and hypothetical situations in aviation',
    categoryId: 'grammar',
    estimatedTime: '11 min',
    emoji: '🔀',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Conditionals describe cause and effect',
        body:
            'Aviation procedures often describe what happens **if** a certain condition occurs. Emergency checklists, operational manuals, and exam questions rely heavily on conditional sentences.\n\nUnderstanding which conditional type to use depends on whether the situation is **real/possible** or **hypothetical/impossible**.',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Conditional types at a glance',
        animationType: GrammarAnimationType.conditionals,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'The Three Main Types',
        body:
            '**Type 1 — Real/Possible (present/future)**\nIf + present simple, will/can/must + base verb\n→ "If the oil pressure drops, the pilot **will** declare an emergency."\n\n**Type 2 — Hypothetical (present/future)**\nIf + past simple, would/could + base verb\n→ "If the engine **failed**, the crew **would** follow the ECAM."\n\n**Type 3 — Impossible (past)**\nIf + past perfect, would/could + have + past participle\n→ "If the crew **had noticed** the leak, they **would have** diverted."',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Aviation Conditionals',
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
        title: '✈️ Exam Tip',
        body:
            'Quick identification trick:\n• See "will" in the result clause → **Type 1** (real)\n• See "would" + present base → **Type 2** (hypothetical)\n• See "would have" + past participle → **Type 3** (past)\n\nWatch for "unless" = "if not":\n"Unless the checklist is completed, departure is not permitted."\n= "If the checklist is **not** completed, departure is not permitted."',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Weather & Navigation',
    subtitle: 'METAR, TAF and navigation terminology',
    categoryId: 'vocabulary',
    estimatedTime: '10 min',
    emoji: '🌤️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Weather is critical to aviation',
        body:
            'Weather reports and navigation documents use highly standardized vocabulary. METAR, TAF, NOTAM, and ATIS use specific terms that pilots and controllers must understand instantly.\n\nThis lesson covers the most frequently tested weather and navigation terms.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🌦️ Weather Phenomena',
        body:
            '**CAVOK** — Ceiling And Visibility OK (vis >10km, no cloud below 5000ft, no significant weather)\n**BECMG** — Becoming (gradual change within a period)\n**TEMPO** — Temporary fluctuations lasting less than 1 hour\n**CB** — Cumulonimbus (thunderstorm cloud, avoid by 20nm)\n**TSRA** — Thunderstorm with rain\n**FG** — Fog | **BR** — Mist | **RA** — Rain | **SN** — Snow',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🧭 Navigation Terms',
        body:
            '**Track** — actual path over the ground\n**Heading** — direction the nose is pointing\n**Bearing** — direction from one point to another\n**QNH** — altimeter setting (sea level pressure in hPa)\n**QFE** — altimeter setting (airfield elevation, reads zero on ground)\n**ATIS** — Automatic Terminal Information Service\n**VOR/DME** — VHF Omni Range / Distance Measuring Equipment',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'METAR Example',
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
        title: '✈️ Exam Tip',
        body:
            'METAR reading order (always the same):\nStation → Date/Time → Wind → Visibility → Weather → Cloud → Temperature/Dewpoint → QNH → Trend\n\n"QNH" vs "QFE":\n• **QNH** → altitude above sea level (standard, used for en-route)\n• **QFE** → altitude above aerodrome (shows 0 when on ground)\n\nMost exam questions ask about QNH.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'ATC Phraseology EN→TR',
    subtitle: 'Translating standard ATC phrases accurately',
    categoryId: 'translation',
    estimatedTime: '10 min',
    emoji: '🗣️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Precise translation in aviation',
        body:
            'Translation questions test whether you understand **both** the technical meaning of aviation phrases and their accurate Turkish equivalents.\n\nA wrong translation can indicate a misunderstanding of the procedure, which is why these questions carry significant weight in exams.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔑 Key Phrase Translations',
        body:
            '"**Cleared to land**" → Piste inişe yetkilendirildiniz\n"**Go around**" → Tırmaniş yapın / Alçalışı iptal edin\n"**Hold short**" → Girmeden bekleyin\n"**Line up and wait**" → Sıraya girin ve bekleyin\n"**Contact [unit] on [freq]**" → [birim] ile [frekans] üzerinde temasa geçin\n"**Report final**" → Final pistine geldiğinizde bildirin\n"**Confirm**" → Teyit edin\n"**Affirm**" → Evet/Doğru (Teyit ederim)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Translation Examples',
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
        title: '✈️ Translation Tips',
        body:
            'Common translation mistakes to avoid:\n• "Hold position" ≠ "pisti tutun" → Correct: "bulunduğunuz yerde bekleyin"\n• "Expedite" ≠ "acele edin" → Correct: "mümkün olan en kısa sürede (yapın)"\n• "Wilco" ≠ "tamam" → Correct: "anlıyorum ve gereğini yapacağım"\n• "Roger" = "mesajınız alındı" (not agreement, just acknowledgement)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'NOTAM Reading',
    subtitle: 'Understanding Notices to Air Missions',
    categoryId: 'reading',
    estimatedTime: '12 min',
    emoji: '📄',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'What is a NOTAM?',
        body:
            'A **NOTAM** (Notice to Air Missions) is an official notice distributed to personnel concerned with flight operations, containing information about the establishment, condition, or change of any aeronautical facility, service, procedure, or hazard.\n\nReading comprehension questions often use NOTAM-style texts or maintenance/inspection documents.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 NOTAM Structure',
        body:
            'A NOTAM contains:\n**Q)** — Subject/condition/traffic codes\n**A)** — Location (ICAO code)\n**B)** — Begin date/time\n**C)** — End date/time\n**E)** — Full text description\n\nExample structure:\n"A0123/24 NOTAMN\nQ) LTAA/QMRLC/IV/NBO/A/000/999/4059N02858E005\n**A) LTBA B) 2401150600 C) 2401152359**\n**E) RWY 36L/18R CLOSED FOR MAINTENANCE"**',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔍 Reading Comprehension Strategy',
        body:
            'For any aviation text (NOTAM, report, manual extract):\n1. **Scan first** — identify the type of document and subject\n2. **Read the question before re-reading** — know what to look for\n3. **Find key facts** — dates, locations, restrictions, requirements\n4. **Watch for negatives** — "not", "except", "unless" change the meaning completely\n5. **Avoid assumptions** — answer only from the given text',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Sample Passage',
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
        title: '✈️ Reading Tips',
        body:
            'Watch for question types:\n• **"What is the main purpose?"** → look for the opening definition sentence\n• **"Which is NOT required?"** → find the list and identify the missing/excluded item\n• **"According to the passage"** → the answer must be explicitly stated, not inferred\n• **"What does X examine?"** → find the direct object of the key verb',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Reported Speech',
    subtitle: 'Incident reports and crew statements',
    categoryId: 'grammar',
    estimatedTime: '11 min',
    emoji: '💬',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Reported speech in aviation reports',
        body:
            'Aviation incident and accident reports frequently quote what crew members or controllers **said** or **thought**. The grammar used to report these statements is called **indirect/reported speech**.\n\nExam questions often ask you to convert between direct and reported speech, or complete a reported speech sentence correctly.',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Watch the tense shift',
        animationType: GrammarAnimationType.reportedSpeech,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Tense Backshift Rule',
        body:
            'When the reporting verb is **past** (said, told, reported), tenses shift back:\n\n| Direct | Reported |\n|---|---|\n| is/am/are | **was/were** |\n| was/were | **had been** |\n| will | **would** |\n| can | **could** |\n| must | **had to** |\n| has/have + V3 | **had** + V3 |\n\n"The system **is** malfunctioning." →\nThe pilot said the system **was** malfunctioning.',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Aviation Reported Speech',
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
        title: '✈️ Exam Tip',
        body:
            'Key reporting verbs and their prepositions:\n• said (that) — general statement\n• told + person + (that) — "told him/her"\n• reported (that) — formal/written report\n• informed + person + (that) — official notification\n• warned + person + (that/about) — hazard warning\n\nNo preposition after "said": ✓ "said **that**" / ✗ "said **to** him that"',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Emergency Procedures',
    subtitle: 'Completing emergency communication phrases',
    categoryId: 'sentence_completion',
    estimatedTime: '10 min',
    emoji: '🚨',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Emergency language must be precise',
        body:
            'Emergency communications follow strict ICAO phraseology. In sentence completion questions, you must choose the word or phrase that **precisely and completely** fills the meaning of the sentence.\n\nThe distractor options often look plausible — the key is selecting the **most accurate** aviation term.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🚨 Emergency Levels',
        body:
            '**MAYDAY** (×3) — Distress: immediate danger to life\n"MAYDAY MAYDAY MAYDAY — THY123 — engine fire — declaring emergency"\n\n**PAN-PAN** (×3) — Urgency: serious situation, not immediate danger\n"PAN-PAN PAN-PAN PAN-PAN — THY123 — medical emergency on board"\n\n**SQUAWK 7700** — General emergency\n**SQUAWK 7600** — Radio failure\n**SQUAWK 7500** — Unlawful interference (hijack)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📡 Emergency Checklist Language',
        body:
            'Emergency checklists use specific sentence patterns:\n• "In the event of ………, the crew should…"\n• "If ……… is observed, immediately…"\n• "………… and report to ATC"\n• "Declare ………… and request priority landing"\n\nCommon verbs: **declare, squawk, divert, dump, depressurize, evacuate, report**',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Emergency Completions',
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
        title: '✈️ Exam Strategy for Completion Questions',
        body:
            '1. Read the **full sentence** — understand the aviation situation\n2. Identify the **grammatical slot** — noun? verb? adjective? preposition?\n3. Check **collocations** — "declare an emergency" not "announce an emergency"\n4. Aviation-specific collocations:\n   • declare **an emergency** / mayday\n   • squawk **a code** (7700)\n   • divert **to** an alternate\n   • request **immediate** / priority assistance',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Accident Report Analysis',
    subtitle: 'Advanced reading comprehension',
    categoryId: 'reading',
    estimatedTime: '14 min',
    emoji: '📑',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Accident reports are complex texts',
        body:
            'Aviation accident investigation reports (such as those produced by ICAO Annex 13 standards) are among the most complex texts tested in aviation English exams.\n\nThey contain technical terminology, passive constructions, reported speech, and conditional reasoning — all combined in a single document.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Report Structure',
        body:
            'A standard accident report contains:\n1. **Synopsis** — brief summary of the accident\n2. **Factual information** — aircraft, crew, weather, airport data\n3. **Analysis** — what happened and why (cause chain)\n4. **Findings** — established facts\n5. **Cause** — probable cause(s)\n6. **Safety recommendations** — what should change\n\nExam questions usually target **Factual Information** and **Analysis** sections.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔍 Critical Reading Skills',
        body:
            'For accident report passages:\n• **Sequence words**: prior to, during, following, subsequently, as a result\n• **Causal language**: due to, caused by, attributed to, led to, resulted in\n• **Finding vs. Recommendation**: findings are facts; recommendations are suggestions\n• **Contributing factor** ≠ **Probable cause**: contributing factors worsen the situation; probable cause is the primary reason',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Report Language Examples',
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
        title: '✈️ Advanced Reading Strategy',
        body:
            'The 3-read method for complex passages:\n1. **First read**: skim for topic and structure (30 seconds)\n2. **Read question**: understand exactly what is asked\n3. **Second read**: focus on the relevant paragraph only\n\nNever answer from memory — always verify in the text. Advanced questions often have **plausible but incorrect** distractors that use words from the passage in the wrong context.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Simple & Continuous Tenses',
    subtitle: 'When to use each tense in aviation contexts',
    categoryId: 'grammar',
    estimatedTime: '10 min',
    emoji: '⏰',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Tense signals when an action happens',
        body:
            'In aviation English, choosing the right tense is critical. ATC uses **present simple** for permanent facts, **present continuous** for current actions, and **past simple** for completed events in reports.\n\nMixing tenses in checklists or reports is a common exam error.',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Tenses on a timeline',
        animationType: GrammarAnimationType.tensesTimeline,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Simple vs. Continuous',
        body:
            '**Present Simple** — facts, routines, permanent states\n→ "The ILS localizer **operates** on frequencies 108–111.95 MHz."\n\n**Present Continuous** — actions happening now, temporary\n→ "The aircraft **is climbing** through flight level 180."\n\n**Past Simple** — completed events (reports, logs)\n→ "The crew **performed** the before-start checklist at 0612Z."\n\n**Past Continuous** — ongoing past action interrupted\n→ "The aircraft **was taxiing** when the bird strike **occurred**."',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Tense in Context',
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
        title: '✈️ Exam Tip',
        body:
            'Time signal words give away the tense:\n• **now / currently / at the moment** → present continuous\n• **always / usually / every flight** → present simple\n• **at 14:32 / yesterday / last night** → past simple\n• **while / when / as** → look for two simultaneous past actions\n\nAviation logs and reports always use **past simple** — they record completed events.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Airport & Ground Operations',
    subtitle: 'Ramps, taxiways, gates and ground handling',
    categoryId: 'vocabulary',
    estimatedTime: '9 min',
    emoji: '🏗️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'The airport environment has precise terminology',
        body:
            'Ground operations vocabulary is tested heavily in fill-in-the-blank and reading comprehension questions. Knowing the difference between a **taxiway**, **runway**, **apron**, and **ramp** is essential for safe operations and exam success.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛬 Airport Movement Areas',
        body:
            '**Runway** — paved surface for takeoff and landing\n**Taxiway** — paved path connecting runways to aprons (named A, B, C…)\n**Apron (Ramp)** — area for parking, loading, servicing aircraft\n**Holding Bay** — area where aircraft wait before entering runway\n**Threshold** — beginning of the runway available for landing\n**Displaced Threshold** — landing threshold moved from physical runway end\n**Stopway** — paved area beyond runway end, usable for stopping only',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🚧 Ground Movement Terms',
        body:
            '**Pushback** — towing aircraft backward from gate using a tug\n**Tow** — moving aircraft with a ground vehicle\n**Ground power unit (GPU)** — provides external electrical power\n**Chocks** — wheel blocks preventing movement\n**Jet bridge / Jetway** — passenger boarding bridge\n**FOD** — Foreign Object Debris (anything on runway/taxiway that could damage aircraft)\n**Ground stop** — ATC directive halting departures',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Ground Operations in Context',
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
        title: '✈️ Exam Tip',
        body:
            'Common confusion pairs:\n• **Apron** = parking/service area | **Tarmac** = informal term for apron/taxiway (avoid in formal use)\n• **Taxiway** = movement path | **Runway** = takeoff/landing only\n• **Gate** = passenger boarding position | **Stand/Bay** = parking position (no gate)\n• **Pushback** = aircraft moves backward | **Tow** = any direction with a vehicle',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Safety Equipment',
    subtitle: 'Emergency equipment terminology for exams',
    categoryId: 'vocabulary',
    estimatedTime: '8 min',
    emoji: '🦺',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Safety equipment names must be exact',
        body:
            'Using incorrect names for safety equipment can cause dangerous misunderstandings. Exam questions test precise knowledge of equipment names, their function, and the verbs used with them.\n\nThis lesson covers the most frequently examined safety equipment terms across all aviation roles.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛡️ Cabin Safety Equipment',
        body:
            '**Portable oxygen unit** — portable O₂ bottle for crew use\n**Drop-down oxygen mask** — passenger masks, auto-deploys above 10,000 ft cabin alt\n**Life vest / Life jacket** — under-seat flotation device\n**Emergency exit** — floor-level lighting marks the path\n**Escape slide** — inflatable slide for rapid evacuation\n**Fire extinguisher** — Halon type in cockpit, water/CO₂ in cabin\n**ELT** — Emergency Locator Transmitter (activates on impact)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔧 Technical Safety Equipment',
        body:
            '**Circuit breaker (CB)** — protects electrical circuits from overload\n**Fire detector** — senses smoke/heat in engine, APU, cargo compartment\n**Fire suppression system** — discharges extinguisher agent into engine nacelle\n**Overheat detector** — warns of bleed air duct overheating\n**TCAS** — Traffic Collision Avoidance System\n**GPWS/EGPWS** — Ground Proximity Warning System',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Safety Equipment in Use',
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
        title: '✈️ Exam Tip',
        body:
            'Key verbs used with safety equipment:\n• **don** = put on (life vest, oxygen mask) — formal aviation term\n• **deploy** = activate automatically (escape slide, oxygen mask)\n• **arm** = set to automatic deployment mode (door slide)\n• **discharge** = release extinguishing agent\n• **arm/disarm** doors = cabin crew action before departure/after arrival\n\nNever use "put on" in formal exam answers — use **don**.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Pre-flight Checklist Language',
    subtitle: 'Completing checklist phrases correctly',
    categoryId: 'fill_blanks',
    estimatedTime: '9 min',
    emoji: '📝',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Checklists follow fixed language patterns',
        body:
            'Aviation checklists use a highly standardized language structure. Unlike conversational English, checklist language is **compressed and precise** — each word is chosen for accuracy and brevity.\n\nFill-in-the-blank questions test whether you know the correct technical term or phrase for each checklist item.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Checklist Language Patterns',
        body:
            'Checklists use three main patterns:\n\n**Challenge / Response:**\n"PARKING BRAKE — **SET**"\n"SEAT BELTS — **ON**"\n"FUEL QUANTITY — **CHECKED**"\n\n**Action items:**\n"……… the altimeters to QNH"\n"……… the ILS frequency and course"\n"……… the transponder to 2000"\n\nCommon action verbs: **set, check, confirm, select, arm, position, verify, engage**',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Checklist Phrases in Context',
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
        title: '✈️ Exam Tip',
        body:
            'Checklist verb distinctions:\n• **Set** = adjust to a specific value ("set altimeter to 1013")\n• **Check** = confirm current state without adjusting\n• **Verify** = confirm a specific condition is met\n• **Confirm** = obtain acknowledgment from another crew member\n• **Arm** = place in automatic activation mode\n• **Select** = choose from available options ("select flaps 5")',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Emergency Terminology',
    subtitle: 'Words and phrases used in abnormal situations',
    categoryId: 'vocabulary',
    estimatedTime: '10 min',
    emoji: '🚨',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Emergency language must be learned exactly',
        body:
            'In real emergencies and in exam questions, using the right word can make a critical difference. ICAO standards define specific terms for emergencies — these cannot be paraphrased.\n\nThis lesson focuses on the vocabulary that appears most frequently in emergency-related exam questions.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🚨 Emergency Classification',
        body:
            '**Distress** — state of being threatened by serious and/or imminent danger, requiring immediate assistance (MAYDAY)\n\n**Urgency** — condition concerning the safety of an aircraft or other vehicle, or of some person on board or in sight, but not requiring immediate assistance (PAN-PAN)\n\n**Emergency** — broad term covering both distress and urgency situations\n\n**Incident** — occurrence other than an accident associated with flight operation\n**Accident** — occurrence resulting in death, injury, or substantial aircraft damage',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔥 Emergency Action Vocabulary',
        body:
            '**Declare** — formally announce an emergency state\n**Divert** — change destination to an alternate airport\n**Squawk** — set transponder code\n**Dump fuel** — jettison fuel to reduce landing weight (on equipped aircraft)\n**Depressurize** — controlled or rapid loss of cabin pressure\n**Evacuate** — rapid exit of passengers and crew\n**Ditch** — emergency landing on water\n**Abort** — discontinue a takeoff roll',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Emergency Communication',
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
        title: '✈️ Exam Tip',
        body:
            '"Incident" vs. "Accident" is a common exam question:\n• **Incident**: something happened but no one died and no major damage occurred\n• **Accident**: death, serious injury, OR substantial damage occurred\n\n"Distress" vs. "Urgency":\n• **Distress (MAYDAY)**: needs help NOW — immediate danger to life\n• **Urgency (PAN-PAN)**: serious concern, but not an immediate threat to life',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Approach & Landing',
    subtitle: 'Phraseology for the critical final phase',
    categoryId: 'fill_blanks',
    estimatedTime: '10 min',
    emoji: '🛬',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Approach phraseology is highly structured',
        body:
            'The approach and landing phase uses the most regulated phraseology in aviation. Precise language is essential because misunderstandings during approach have caused accidents.\n\nFill-in-the-blank questions in this area test knowledge of exact ICAO phrases and their correct prepositions and keywords.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛬 Approach Clearance Phrases',
        body:
            '"Cleared **ILS approach** runway 36R"\n"Cleared **visual approach** runway 18L"\n"Cleared **RNAV(GPS) approach** runway 05"\n"**Descend** on the glide path"\n"**Established** on localizer / on the ILS"\n"**Report** outer marker / FAF / visual"\n"**Missed approach** — go around, climb to 4000 feet"\n"**Wind check**: 270/15, **cleared to land**"',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📏 Approach Distance & Height',
        body:
            '**Final approach** — last straight segment to runway\n**Short final** — within 4nm of runway threshold\n**Glide slope** — vertical guidance component of ILS\n**Localizer** — horizontal guidance component of ILS\n**Decision altitude (DA)** — height at which missed approach must be initiated if no visual contact\n**Minimum Descent Altitude (MDA)** — minimum height in non-precision approach\n**Touch-down zone** — first 3,000 feet of runway used for landing',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Approach Phrases',
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
        title: '✈️ Key Prepositions',
        body:
            'Prepositions are frequently tested in approach phraseology:\n• Cleared **for** ILS approach (not "to")\n• Established **on** the localizer (not "in")\n• Descend **to** 3,000 feet (not "until")\n• Report **at** the outer marker (not "on")\n• Cleared **to land** (two words, not "for landing" in ICAO standard)\n\nMemorise: **"Cleared for approach"** vs. **"Cleared to land"** — different phrases!',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'METAR Translation',
    subtitle: 'Decoding weather reports in plain English',
    categoryId: 'translation',
    estimatedTime: '11 min',
    emoji: '📊',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Every METAR element has a precise meaning',
        body:
            'Translation questions often ask you to interpret METAR or TAF codes and express them in plain English — or to identify the correct Turkish translation of a weather observation.\n\nEach element of a METAR appears in fixed order and has an exact meaning. Getting the order wrong or misinterpreting an abbreviation loses marks.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🌦️ METAR Element Order',
        body:
            '**METAR** LTBA **120850Z** **35015KT** **9999** **FEW030** **18/08** **Q1013** **NOSIG**\n\n1. Station ICAO code: LTBA (Istanbul)\n2. Date/Time: 12th at 08:50 UTC\n3. Wind: 350°/15 knots\n4. Visibility: 9999 = 10km or more\n5. Cloud: FEW at 3,000ft AGL\n6. Temp/Dewpoint: 18°C / 8°C\n7. QNH: 1013 hPa\n8. Trend: NOSIG = no significant change',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '☁️ Cloud Cover Codes',
        body:
            '**FEW** — 1–2 oktas (1/8–2/8 coverage)\n**SCT (Scattered)** — 3–4 oktas\n**BKN (Broken)** — 5–7 oktas\n**OVC (Overcast)** — 8 oktas (full coverage)\n**NSC** — No Significant Cloud\n**NCD** — No Cloud Detected (auto station)\n\nHeight is given in hundreds of feet AGL:\n"BKN015" = broken cloud at 1,500 feet AGL\n"OVC008" = overcast at 800 feet AGL',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Translation Examples',
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
        title: '✈️ Exam Tip',
        body:
            'Most common METAR translation errors:\n• **9999** = 10km or more visibility (NOT "9,999 meters exactly")\n• **FEW030** = clouds at 3,000ft (add two zeros to METAR cloud height)\n• **18/08** = temperature 18°C, dewpoint 8°C (NOT "18 to 8")\n• **NOSIG** = no significant change expected in next 2 hours (NOT "no signal")\n• Wind "35015KT" = FROM 350°, speed 15 knots (direction is WHERE wind comes FROM)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'ATIS Messages',
    subtitle: 'Reading and understanding terminal information',
    categoryId: 'reading',
    estimatedTime: '9 min',
    emoji: '📻',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'ATIS delivers critical pre-flight information',
        body:
            'ATIS (Automatic Terminal Information Service) broadcasts updated airport information continuously. Pilots must obtain the current ATIS information before contacting ATC and must confirm they have received it with the ATIS letter (Alpha, Bravo, Charlie…).\n\nReading comprehension questions often use ATIS-style texts and ask you to extract specific information.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📻 Standard ATIS Content',
        body:
            'An ATIS broadcast includes (in order):\n1. Airport name and ATIS information letter\n2. Observation time\n3. Active runway(s) in use\n4. Approach type in use (ILS/VOR/Visual)\n5. Wind direction and speed\n6. Visibility\n7. Weather phenomena\n8. Cloud layers\n9. Temperature and dewpoint\n10. QNH\n11. NOTAMs/special notices\n12. "Advise on initial contact you have information [letter]"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Sample ATIS Passage',
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
        title: '✈️ Reading Strategy',
        body:
            'For ATIS-type reading questions:\n• The **ATIS letter** changes every 30–60 minutes — questions may ask "what does Bravo indicate?"\n• **Runway in use** may differ for arrivals and departures\n• **Transition level** = lowest usable flight level above the transition altitude\n• **Special notices** at the end often contain the detail that is tested\n• Questions often ask: "According to the ATIS, which runway is available for…?" — read carefully',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Articles in Aviation',
    subtitle: 'a, an, the — and when to use zero article',
    categoryId: 'grammar',
    estimatedTime: '10 min',
    emoji: '📖',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Articles signal definiteness and context',
        body:
            'While articles seem simple, they are among the most frequently tested grammar points in aviation English because technical documents, manuals, and ATC communications all follow specific article usage patterns.\n\nA wrong article changes the meaning: "**a** hydraulic pump" (any one) vs. "**the** hydraulic pump" (a specific one we are discussing).',
      ),
      LessonSection(
        type: LessonSectionType.animation,
        title: 'Article usage guide',
        animationType: GrammarAnimationType.articleUsage,
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Article Rules',
        body:
            '**"a / an"** — indefinite: first mention, one of many, job/type\n→ "A hydraulic pump pressurizes the fluid."\n→ "He is a licensed aircraft engineer."\n\n**"the"** — definite: previously mentioned, unique, specific system\n→ "The hydraulic pump (mentioned before) failed."\n→ "The captain (there is only one) made the decision."\n\n**Zero article** — general statements, uncountable nouns, proper names\n→ "Aviation safety depends on training." (general)\n→ "ILS runway 36L is available." (proper name)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Articles in Technical Texts',
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
        title: '✈️ Exam Tip',
        body:
            'Use "an" (not "a") before vowel **sounds** — not just vowel letters:\n• **an** ILS approach (I = vowel sound)\n• **an** RNAV procedure (R = consonant sound, but "RNAV" starts with vowel sound "ar")\n• **a** NOTAM (N = consonant sound)\n• **a** VOR (V = consonant sound)\n\nZero article with aviation systems in general context:\n✓ "Hydraulic systems are used in …" (NOT "The hydraulic systems")\n✓ "ILS provides guidance" (NOT "The ILS provides")',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
  // LESSON I4 — Instrument & Navigation Systems
  // ─────────────────────────────────────────────────────────────
  static const _instrumentSystems = LessonContent(
    id: 'vocab_6',
    title: 'Instrument Systems',
    subtitle: 'Avionics and navigation instrument vocabulary',
    categoryId: 'vocabulary',
    estimatedTime: '11 min',
    emoji: '🎛️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Modern aircraft rely on complex instrument systems',
        body:
            'Avionics vocabulary appears in reading comprehension, vocabulary fill-in, and sentence completion questions. Understanding what each instrument does and how it is described in manuals is essential for intermediate and advanced levels.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '✈️ Primary Flight Instruments',
        body:
            '**ADI (Attitude Director Indicator)** — shows pitch and bank\n**HSI (Horizontal Situation Indicator)** — combined heading + navigation\n**VSI (Vertical Speed Indicator)** — rate of climb/descent in feet per minute\n**ASI (Airspeed Indicator)** — shows IAS in knots\n**Altimeter** — shows altitude using static pressure\n**Turn & Slip Indicator** — shows rate of turn and coordination',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛰️ Navigation Systems',
        body:
            '**FMS (Flight Management System)** — computerized navigation, flight planning, and performance\n**GPS (Global Positioning System)** — satellite-based positioning\n**IRS/INS (Inertial Reference System)** — self-contained navigation using accelerometers\n**DME (Distance Measuring Equipment)** — ground-based range measurement\n**ADF (Automatic Direction Finder)** — homes to NDB stations\n**TCAS II** — provides Resolution Advisories (RA) to avoid traffic',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Navigation System Context',
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
        title: '✈️ Exam Tip',
        body:
            'Common exam confusion pairs:\n• **IAS** (Indicated Airspeed) vs. **TAS** (True Airspeed) — TAS increases with altitude\n• **FMS** manages the whole route | **autopilot** controls the aircraft\n• **TCAS RA** = mandatory evasive action | **TCAS TA** = Traffic Advisory (awareness only)\n• **DME** measures **slant range** (not ground distance)\n• **IRS** is self-contained (no external signals) | **GPS** needs satellites',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Flight Plan Documents',
    subtitle: 'Reading ICAO flight plan forms and OFPs',
    categoryId: 'reading',
    estimatedTime: '12 min',
    emoji: '📋',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Flight plans encode critical operational data',
        body:
            'ICAO flight plan forms (ICAO Doc 4444, Appendix 2) and Operational Flight Plans (OFPs) contain dense coded information. Reading comprehension questions at this level require you to extract specific data from these documents and understand their structure.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 ICAO Flight Plan Fields',
        body:
            '**Field 7** — Aircraft ID (call sign): "THY123"\n**Field 8** — Flight rules (I=IFR, V=VFR) and type (S=scheduled): "IS"\n**Field 9** — Number and type of aircraft / wake turbulence: "B738/M"\n**Field 10** — Equipment: "SDFGRY/S" (comms/nav/approach/SSR)\n**Field 15** — Route: SID + airways + waypoints + STAR\n**Field 16** — Destination + EET + alternates\n**Field 18** — Other information (PBN, DAT, SUR, etc.)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚠️ Wake Turbulence Categories',
        body:
            '**J — Super** (A380, AN-124): wingspan >80m\n**H — Heavy** (B747, B777, A330): MTOW >136,000kg\n**M — Medium** (B737, A320): MTOW 7,000–136,000kg\n**L — Light** (Cessna, DA-42): MTOW <7,000kg\n\nSeparation minima increase behind heavier aircraft:\n• H behind J: 6nm\n• M behind H: 5nm\n• L behind H: 6nm\n\nWake turbulence is most severe at **low speed, high angle of attack** (on approach)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Flight Plan Data',
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
        title: '✈️ Exam Tip',
        body:
            'Flight plan questions often focus on:\n• **Aircraft type / wake category** — know ICAO aircraft designators\n• **EET** (Estimated Elapsed Time) vs. **ETA** (Estimated Time of Arrival)\n• **Alternate airport** requirements — when is one required?\n• **PBN** (Performance Based Navigation) codes in Field 18\n\nCommon trick: "EOBT" = Estimated Off-Blocks Time (when pushback starts), NOT takeoff time.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Engine Failure Procedures',
    subtitle: 'Language patterns in abnormal and emergency checklists',
    categoryId: 'fill_blanks',
    estimatedTime: '10 min',
    emoji: '🔥',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Abnormal checklists have fixed language patterns',
        body:
            'Engine failure and other abnormal/emergency checklists use the most precise language in aviation. Fill-in-the-blank questions from this area test both technical knowledge and vocabulary accuracy.\n\nThe correct procedure verb is critical — using the wrong action word is never acceptable in aviation.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔥 Engine Failure Vocabulary',
        body:
            '**Thrust lever** — controls engine power (throttle)\n**Fuel control lever** — starts/stops fuel to engine\n**Engine fire handle** — emergency shut-off and fire suppression control\n**HP fuel cock / Shutoff valve** — high-pressure fuel control\n**N1 / N2** — fan speed (%) / core speed (%)\n**EGT** — Exhaust Gas Temperature\n**ITT** — Interstage Turbine Temperature\n**Surge** — compressor stall; loud bang, rpm fluctuation',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Checklist Action Patterns',
        body:
            'Engine failure checklist sequence uses these exact phrases:\n\n"Engine fire, failure or severe damage — **ECAM ACTIONS**... **PERFORM**"\n"Thrust lever — **IDLE**"\n"If engine does not recover — engine **MASTER switch** — **OFF**"\n"Engine fire pushbutton — **PUSH**"\n"If fire not extinguished — **DISCHARGE** second agent"\n"Land at nearest suitable aerodrome — **CONSIDER**"\n\nKey pattern verbs: **idle, push, pull, discharge, confirm, verify, cross-check**',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Abnormal Checklist Language',
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
        title: '✈️ Exam Tip',
        body:
            'Checklist action verbs that are tested:\n• **Pull** fire handle (not "activate" or "turn")\n• **Discharge** extinguisher (not "release" or "fire")\n• **Cross-check** — never skip this step in exams\n• **Monitor** vs. **Check**: monitoring is continuous; checking is a single action\n• "Land at nearest suitable" ≠ "divert immediately" — the crew must assess "suitability"',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Operations Manual Language',
    subtitle: 'Translating formal operations and maintenance texts',
    categoryId: 'translation',
    estimatedTime: '11 min',
    emoji: '📕',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Formal aviation documents have specific language patterns',
        body:
            'Operations manuals, maintenance manuals (AMM), and airworthiness directives use formal English with precise legal and technical implications. Translation questions at this level require understanding not just the words, but the **regulatory intent** behind them.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📕 Regulatory Language',
        body:
            '**Shall** — mandatory requirement (legal obligation in ICAO documents)\n**Should** — recommended practice (not legally binding, but expected)\n**May** — permitted (optional)\n**Must** — mandatory (operational context, not formal ICAO legal text)\n\n**Compliance** — acting in accordance with a regulation\n**In accordance with (IAW)** — following specified requirements\n**Subject to** — conditional upon something\n**Notwithstanding** — despite; even though\n**Hereinafter** — from this point forward in the document',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Manual Language Examples',
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
        title: '✈️ Translation Tips',
        body:
            'Critical translation distinctions:\n• "**shall**" in ICAO docs ≠ "will" (future) — it means **mandatory**\n• "**notwithstanding**" ≠ "noting" — it means **despite** or **regardless of**\n• "**in the event of**" = "eğer … olursa/durumunda" (conditional)\n• "**prior to**" = "…dan önce" (before) — formal version of "before"\n• "**subsequent to**" = "…dan sonra" (after) — formal version of "after"',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Complex Sentence Structures',
    subtitle: 'Relative clauses, participles, and inversion',
    categoryId: 'grammar',
    estimatedTime: '13 min',
    emoji: '🧩',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Advanced texts use complex grammatical structures',
        body:
            'Aviation documents, accident reports, and ICAO publications use complex sentence structures that combine multiple clauses. At the advanced level, you must handle these accurately in both comprehension and production questions.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Relative Clauses',
        body:
            '**Defining** (no commas): identifies which one\n→ "The component **that failed** was the hydraulic pump."\n\n**Non-defining** (with commas): adds extra information\n→ "The hydraulic pump, **which had just been serviced**, failed."\n\n**Reduced relative clause** (participle phrase):\n→ "The pilot **flying the aircraft** reported vibration." (= who was flying)\n→ "The component **installed last week** is defective." (= that was installed)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: 'Participial Phrases & Inversion',
        body:
            '**Present participle** (active, simultaneous):\n→ "**Having received** the clearance, the crew began the takeoff roll."\n\n**Past participle** (passive, completed first):\n→ "**Notified by ATC**, the pilot diverted to the alternate."\n\n**Negative inversion** (formal/reports):\n→ "**Under no circumstances should** the aircraft depart without a clearance."\n→ "**Not until the checks were completed** did the captain approve departure."',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Complex Structure Examples',
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
        title: '✈️ Exam Tip',
        body:
            'Inversion signals in exam questions:\n• "Under no circumstances…" → should/must come before subject\n• "Not until…" → did/could comes before subject in main clause\n• "Only after…" → inversion in main clause\n\nParticiple phrases — check the subject:\n• "**Having landed**, the aircraft was directed to the gate." ✓ (aircraft landed)\n• "**Having landed**, the gate was assigned." ✗ (gate didn\'t land — dangling participle)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Expert ICAO Vocabulary',
    subtitle: 'High-frequency advanced aviation terminology',
    categoryId: 'vocabulary',
    estimatedTime: '12 min',
    emoji: '🏆',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Advanced vocabulary separates good from excellent',
        body:
            'ICAO Level 5 and 6 proficiency requires mastery of low-frequency but high-stakes technical vocabulary. This lesson covers the terms that distinguish advanced candidates and that frequently appear in the hardest exam questions.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🏆 Advanced Operational Terms',
        body:
            '**EDTO/ETOPS** — Extended Diversion Time Operations (flying far from alternate airports)\n**RVSM** — Reduced Vertical Separation Minima (300m / 1,000ft between FL290–FL410)\n**PBN** — Performance-Based Navigation (RNP, RNAV specs)\n**MNPS** — Minimum Navigation Performance Specification (oceanic)\n**MEL** — Minimum Equipment List (approved deferred defects)\n**CDL** — Configuration Deviation List (approved structural deviations)\n**AOG** — Aircraft on Ground (urgent unserviceable aircraft)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚠️ Safety-Critical Vocabulary',
        body:
            '**Controlled flight into terrain (CFIT)** — aircraft in controlled flight strikes terrain\n**Loss of control in-flight (LOC-I)** — most fatal accident category\n**Runway incursion** — unauthorized presence on runway\n**Airspace infringement** — entering controlled airspace without clearance\n**Human factors** — study of human performance in aviation systems\n**Crew Resource Management (CRM)** — effective use of all resources\n**Threat and Error Management (TEM)** — proactive safety model',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Expert Vocabulary in Context',
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
        title: '✈️ Exam Strategy',
        body:
            'For advanced vocabulary questions:\n• **EDTO/ETOPS** = about how far from alternates you can fly (oceanic/remote operations)\n• **MEL** = what you CAN fly with broken; **CDL** = approved structural missing parts\n• **PBN** includes both **RNAV** and **RNP** (RNP has on-board monitoring + alerting)\n• **Runway incursion** vs. **airspace infringement** — both are serious safety events but involve different areas\n• **CRM** is about **using available resources** — not just communication',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'SID/STAR Procedures',
    subtitle: 'Reading departure and arrival procedure documents',
    categoryId: 'reading',
    estimatedTime: '13 min',
    emoji: '🗺️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Procedure documents are dense with technical information',
        body:
            'Standard Instrument Departures (SIDs) and Standard Terminal Arrival Routes (STARs) are documented procedures that contain altitudes, speeds, waypoints, and restrictions. Advanced reading questions use extracts from these documents and require precise interpretation.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛫 SID — Departure Procedure',
        body:
            'A SID (Standard Instrument Departure) provides:\n• Routing from runway to en-route structure\n• Altitude restrictions ("at or above 3,000 ft at waypoint TURPO")\n• Speed restrictions ("250 KIAS below 10,000 ft")\n• Transition codes (RNAV, conventional)\n\n**Altitude coding:**\n• **"A030+"** = at or above 3,000 ft\n• **"A050-"** = at or below 5,000 ft\n• **"A060B080"** = between 6,000 and 8,000 ft\n• **"S220"** = maintain speed 220 KIAS or below',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🛬 STAR — Arrival Procedure',
        body:
            'A STAR (Standard Terminal Arrival Route) provides:\n• Routing from en-route to terminal area / approach\n• Speed reduction profile\n• Transition to IAF (Initial Approach Fix)\n\n**Common STAR terminology:**\n• **IAF** — Initial Approach Fix (start of approach)\n• **IF** — Intermediate Fix\n• **FAF** — Final Approach Fix\n• **MAP** — Missed Approach Point\n• **Published hold** — holding pattern on procedure\n• **"Expect vectors"** — ATC will give radar headings instead',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Procedure Language',
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
        title: '✈️ Exam Tip',
        body:
            '"At or above" / "at or below" in procedure documents:\n• "A030+" = at or **above** 3,000 ft (plus sign = higher)\n• "A050-" = at or **below** 5,000 ft (minus sign = lower)\n\nIf you see both a speed and altitude restriction at a waypoint, **both** must be complied with simultaneously.\n\n"Expect vectors" on a STAR does not mean ATC will always give vectors — it means the pilot should expect them (but must fly the published procedure if not given vectors).',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'CAT III Approach Procedures',
    subtitle: 'Low visibility operations and completion phrases',
    categoryId: 'sentence_completion',
    estimatedTime: '12 min',
    emoji: '🌫️',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Low visibility operations demand precise language',
        body:
            'CAT II and CAT III approaches are conducted in very low visibility using autoland systems. The phraseology, alerts, and callouts in these procedures are among the most precisely defined in aviation English.\n\nSentence completion questions in this area require exact knowledge of procedure terminology.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🌫️ ILS Categories',
        body:
            '**CAT I** — DH ≥200ft, RVR ≥550m (standard ILS)\n**CAT II** — DH 100–200ft, RVR ≥300m (needs specific aircraft/crew cert)\n**CAT IIIA** — DH <100ft OR no DH, RVR ≥200m\n**CAT IIIB** — DH <50ft OR no DH, RVR 50–200m\n**CAT IIIC** — No DH, No RVR limit (still not in service)\n\n**LVP** — Low Visibility Procedures (activated by airport when RVR <600m)\n**LVT** — Low Visibility Takeoff',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📢 CAT III Callouts',
        body:
            'Standard CAT III approach callouts (in order):\n1. "**Localizer alive**" — ILS localizer captured\n2. "**Glide slope alive**" — vertical guidance captured\n3. "**Land 3**" — autoland mode confirmed (A320 family)\n4. "**1,000 feet**" — standard check altitude\n5. "**500 feet**" — stability check\n6. "**100 feet**" — visual or go-around decision\n7. "**50, 40, 30, 20, 10**" — radio altimeter callouts\n8. "**Touchdown**" → "**Decelerate**" → "**Vacate**"',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'CAT III Completion Examples',
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
        title: '✈️ Exam Tip',
        body:
            'CAT II/III key distinctions for exams:\n• **DH** = Decision Height (radio altimeter based, CAT II/III)\n• **DA** = Decision Altitude (barometric, CAT I)\n• **RVR** = Runway Visual Range (measured by transmissometers)\n• A CAT IIIB approach may be conducted with **no Decision Height** if auto-rollout/auto-brake available\n• LVP does NOT cancel low-visibility departures automatically — there are separate LVT minima\n• "Required visual reference" for CAT III is **less** than for CAT I (may be just runway edge lights)',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Advanced ATC Clearances',
    subtitle: 'Complex clearance structures and oceanic phraseology',
    categoryId: 'fill_blanks',
    estimatedTime: '12 min',
    emoji: '🗼',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Advanced clearances combine multiple elements',
        body:
            'At the advanced level, ATC clearances contain multiple simultaneous instructions — altitude, heading, speed, frequency, and transponder — all in a single transmission. Parsing and completing these accurately is a high-level skill tested in expert-level exams.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🗼 Oceanic & Complex Clearance Elements',
        body:
            '**Oceanic clearance:** "THY1 is cleared to New York JFK via track Bravo, flight level 360, Mach 0.84, squawk 2341"\n\n**Complex enroute:** "THY456, cross TURPO at or above FL280, then direct EMEVI, reduce to Mach 0.80"\n\n**Conditional clearance:** "Behind the departing B777, line up runway 34L and wait"\n— Always read back: **type of aircraft + condition + instruction**\n\n**SELCAL** — Selective Calling system for oceanic comms\n**HF** — High Frequency radio (used in oceanic areas beyond VHF range)',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '🔄 Holding Clearance Language',
        body:
            '"THY123, hold at TURPO as published, expect approach in 20 minutes"\n"………… to the right on the 150 radial, 1-minute legs"\n\n**Key holding terms:**\n• **Inbound course** — heading toward the fix during holding\n• **Outbound leg** — time/distance spent flying away from fix\n• **Expect further clearance (EFC)** — time pilot can expect to leave the hold\n• **Published hold** — charted holding pattern; use standard values\n• "**Left / right turns**" — direction of turns in the hold',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Advanced Clearance Examples',
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
        title: '✈️ Advanced Exam Tips',
        body:
            'Conditional clearances — always identify:\n1. **Condition** — which aircraft / when\n2. **Instruction** — what to do\n3. **Readback** must include the condition: "Behind the B777 on final, cleared to land, THY456"\n\nOceanic clearances always include: track letter + FL + Mach number + squawk\n\nEFC (Expect Further Clearance) is NOT a clearance to leave the hold — the pilot must wait for the actual clearance.',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Accident Investigation Reports',
    subtitle: 'Translating ICAO Annex 13 investigation language',
    categoryId: 'translation',
    estimatedTime: '13 min',
    emoji: '📰',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Accident reports use precise legal and technical language',
        body:
            'ICAO Annex 13 accident investigation reports are among the most linguistically demanding documents in aviation. They combine legal precision, passive constructions, technical accuracy, and causal analysis in a single text.\n\nTranslation questions from these reports require understanding both the technical meaning and the legal implications of each phrase.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚠️ Causal Language',
        body:
            '**Probable cause** — the primary factor judged to have produced the accident\n**Contributing factor** — a condition that increased risk but was not the primary cause\n**Causal factor** — any element in the cause chain\n\nCausal verbs and phrases:\n• "**led to**" = caused/resulted in (direct chain)\n• "**attributed to**" = judged as the cause\n• "**resulted in**" = produced this outcome\n• "**was a factor in**" = contributed but not sole cause\n• "**was consistent with**" = evidence matches this explanation',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📋 Investigation Findings Language',
        body:
            '"The investigation **found** that…" → formal finding\n"Evidence **indicated** that…" → supported but not proven\n"**It could not be determined** whether…" → insufficient evidence\n"The crew **failed to**…" → did not perform required action\n"**Contrary to** the standard operating procedure…" → SOP violation\n"The accident **is survivable** / **was not survivable**" → survivability finding\n"**Safety recommendation**" → formal advisory to prevent recurrence',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'Report Passage Examples',
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
        title: '✈️ Translation Exam Strategy',
        body:
            'For accident report translation questions:\n• "**Probable cause**" ≠ "possible cause" — it is the MOST LIKELY established cause\n• "**Contributing factor**" ≠ "main reason" — it is a secondary, exacerbating condition\n• "**Crew failed to**" = they did not do something required — not necessarily negligence\n• "**It could not be determined**" = insufficient evidence — do NOT translate as "it is unknown"\n• "**Contrary to SOP**" = a procedure violation — always serious in reports',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Airworthiness Directives',
    subtitle: 'Reading and interpreting mandatory safety notices',
    categoryId: 'reading',
    estimatedTime: '13 min',
    emoji: '📜',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'ADs are mandatory safety compliance documents',
        body:
            'An Airworthiness Directive (AD) is a legally binding document issued by a civil aviation authority requiring specific action to correct an unsafe condition in an aircraft type. Non-compliance is illegal and grounds for operating certificate suspension.\n\nAD language is the most precise regulatory language in aviation — every word has legal weight.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📜 AD Structure',
        body:
            'A typical AD contains:\n1. **Applicability** — which aircraft/engines/parts are affected\n2. **Unsafe condition** — the hazard being addressed\n3. **Required action** — what must be done\n4. **Compliance time** — when it must be done (e.g., "within 50 flight hours")\n5. **Method** — how to comply (service bulletin, specific procedure)\n6. **Alternative Method of Compliance (AMOC)** — approved alternative\n7. **Costs** — estimated compliance cost',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚠️ Compliance Time Language',
        body:
            '**"Within 50 flight hours after the effective date"** — must be done before 50 more hours\n**"At the next scheduled maintenance"** — at next A/B/C check\n**"Before further flight"** — aircraft must not fly until complied with\n**"At first opportunity"** — as soon as practical (not as urgent as "before further flight")\n**"Repetitive inspection every 200 FH"** — not a one-time action; must be repeated\n**"Terminating action"** — permanently satisfies the AD (no more repetitive checks needed)',
      ),
      LessonSection(
        type: LessonSectionType.examples,
        title: 'AD Language Examples',
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
        title: '✈️ Advanced Reading Strategy',
        body:
            'For AD reading questions:\n• **Applicability** section tells you which aircraft are affected — check this first\n• "**Before further flight**" = the most urgent compliance time — aircraft is GROUNDED\n• "**Terminating action**" = once done, no more repetitive inspections needed\n• **AMOC** = alternative compliance method — must be approved by the authority\n• "**At the next scheduled**" does NOT mean "optional" — it is mandatory at that point\n• Read dates carefully — "after the effective date" vs. "from the date of manufacture"',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
    title: 'Advanced Completion',
    subtitle: 'Complex technical sentence completion',
    categoryId: 'sentence_completion',
    estimatedTime: '12 min',
    emoji: '🎯',
    sections: [
      LessonSection(
        type: LessonSectionType.intro,
        title: 'Advanced completion requires full context understanding',
        body:
            'At the advanced level, sentence completion questions involve complex technical sentences where multiple options may seem grammatically correct. The correct answer requires understanding both grammar **and** aviation technical knowledge.',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '⚙️ Technical Collocation Patterns',
        body:
            'Aviation technical writing has fixed collocations — word combinations that are always used together:\n\n• perform/carry out/conduct (**a maintenance check**) — not "make" or "do"\n• comply with (**regulations**) — not "follow to"\n• in accordance with (**AMM/CMM**) — standard phrase\n• prior to/following (**departure**) — formal time expressions\n• serviceability of (**equipment**) — airworthiness term\n• within the limits (**specified in**) — compliance language',
      ),
      LessonSection(
        type: LessonSectionType.rule,
        title: '📐 Precision Language',
        body:
            'Aviation English values **precision** over elegance. Words are not interchangeable:\n• **inspect** = visually examine | **test** = functionally verify | **check** = confirm state\n• **fault** = specific defect | **failure** = complete loss of function | **malfunction** = partial/intermittent failure\n• **serviceable** = fit for use | **unserviceable** = not fit for use (technical term, not informal)\n• **advise** = inform/recommend | **instruct** = give mandatory direction',
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
        title: '✈️ Final Exam Strategy',
        body:
            'For advanced completion:\n1. Identify the **technical context** (maintenance, operations, ATC)\n2. Look for **register** — is this formal documentation or communication?\n3. Check **grammatical function** — what part of speech fits?\n4. Use aviation **technical vocabulary** — general English word may be wrong in aviation context\n5. If two options seem correct, choose the **more specific/technical** one',
      ),
      LessonSection(
        type: LessonSectionType.practice,
        title: 'Practice Questions',
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
}
