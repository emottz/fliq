import '../models/lesson_content_model.dart';
import '../models/question_model.dart';

/// All lesson content. Practice questions are embedded directly so they
/// remain self-contained even before the JSON question bank is loaded.
class LessonContentData {
  LessonContentData._();

  static const List<LessonContent> all = [
    _passiveVoice,
    _modalVerbs,
    _aircraftComponents,
    _atcFillBlanks,
    _conditionals,
    _weatherNavigation,
    _atcPhraseology,
    _notamReading,
    _reportedSpeech,
    _emergencyCompletion,
    _accidentReport,
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
