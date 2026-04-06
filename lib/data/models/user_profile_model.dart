import 'package:equatable/equatable.dart';

enum UserRole { pilot, atc, cabinCrew, student }

enum ProficiencyLevel { beginner, elementary, intermediate, advanced }

class UserProfileModel extends Equatable {
  final String role;
  final int experienceYears;
  final DateTime? targetExamDate;
  final ProficiencyLevel level;
  final int totalXp;
  final int streakDays;
  final String? lastActiveDate;
  final Map<String, double> categoryProgress;

  // Onboarding — Step 1: Kim olduğun
  final String licenseLevel;   // ppl_student | cpl_student | ppl_holder
  final String flightHours;    // 0_50 | 50_200 | 200_plus
  final String nativeLanguage; // turkish | arabic | other

  // Onboarding — Step 2: Nerede olduğun
  final String englishLevel;   // a2 | b1 | b2 | c1
  final String icaoLevel;      // none | level_3 | level_4 | level_5
  final String examTimeline;   // not_planned | 6_months_plus | 6_months | 1_month

  // Onboarding — Step 3: Ne istediğin
  final String hardestArea;      // phraseology | vocabulary | listening | pronunciation
  final String flyingEnvironment;// domestic | international | both
  final String aircraftType;     // sep | multi | jet
  final String dailyTime;        // 5_10 | 15_20 | 30_plus

  const UserProfileModel({
    required this.role,
    this.experienceYears = 0,
    this.targetExamDate,
    required this.level,
    required this.totalXp,
    required this.streakDays,
    this.lastActiveDate,
    required this.categoryProgress,
    this.licenseLevel = '',
    this.flightHours = '',
    this.nativeLanguage = '',
    this.englishLevel = '',
    this.icaoLevel = '',
    this.examTimeline = '',
    this.hardestArea = '',
    this.flyingEnvironment = '',
    this.aircraftType = '',
    this.dailyTime = '',
  });

  static UserProfileModel empty() => const UserProfileModel(
        role: 'pilot',
        level: ProficiencyLevel.beginner,
        totalXp: 0,
        streakDays: 0,
        categoryProgress: {},
      );

  UserProfileModel copyWith({
    String? role,
    int? experienceYears,
    DateTime? targetExamDate,
    ProficiencyLevel? level,
    int? totalXp,
    int? streakDays,
    String? lastActiveDate,
    Map<String, double>? categoryProgress,
    String? licenseLevel,
    String? flightHours,
    String? nativeLanguage,
    String? englishLevel,
    String? icaoLevel,
    String? examTimeline,
    String? hardestArea,
    String? flyingEnvironment,
    String? aircraftType,
    String? dailyTime,
  }) {
    return UserProfileModel(
      role: role ?? this.role,
      experienceYears: experienceYears ?? this.experienceYears,
      targetExamDate: targetExamDate ?? this.targetExamDate,
      level: level ?? this.level,
      totalXp: totalXp ?? this.totalXp,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      categoryProgress: categoryProgress ?? this.categoryProgress,
      licenseLevel: licenseLevel ?? this.licenseLevel,
      flightHours: flightHours ?? this.flightHours,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      englishLevel: englishLevel ?? this.englishLevel,
      icaoLevel: icaoLevel ?? this.icaoLevel,
      examTimeline: examTimeline ?? this.examTimeline,
      hardestArea: hardestArea ?? this.hardestArea,
      flyingEnvironment: flyingEnvironment ?? this.flyingEnvironment,
      aircraftType: aircraftType ?? this.aircraftType,
      dailyTime: dailyTime ?? this.dailyTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'experienceYears': experienceYears,
        'targetExamDate': targetExamDate?.toIso8601String(),
        'level': level.name,
        'totalXp': totalXp,
        'streakDays': streakDays,
        'lastActiveDate': lastActiveDate,
        'categoryProgress': categoryProgress,
        'licenseLevel': licenseLevel,
        'flightHours': flightHours,
        'nativeLanguage': nativeLanguage,
        'englishLevel': englishLevel,
        'icaoLevel': icaoLevel,
        'examTimeline': examTimeline,
        'hardestArea': hardestArea,
        'flyingEnvironment': flyingEnvironment,
        'aircraftType': aircraftType,
        'dailyTime': dailyTime,
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      role: json['role'] as String? ?? 'pilot',
      experienceYears: json['experienceYears'] as int? ?? 0,
      targetExamDate: json['targetExamDate'] != null
          ? DateTime.tryParse(json['targetExamDate'] as String)
          : null,
      level: ProficiencyLevel.values.firstWhere(
        (l) => l.name == json['level'],
        orElse: () => ProficiencyLevel.beginner,
      ),
      totalXp: json['totalXp'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] as String?,
      categoryProgress: (json['categoryProgress'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      licenseLevel: json['licenseLevel'] as String? ?? '',
      flightHours: json['flightHours'] as String? ?? '',
      nativeLanguage: json['nativeLanguage'] as String? ?? '',
      englishLevel: json['englishLevel'] as String? ?? '',
      icaoLevel: json['icaoLevel'] as String? ?? '',
      examTimeline: json['examTimeline'] as String? ?? '',
      hardestArea: json['hardestArea'] as String? ?? '',
      flyingEnvironment: json['flyingEnvironment'] as String? ?? '',
      aircraftType: json['aircraftType'] as String? ?? '',
      dailyTime: json['dailyTime'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [role, licenseLevel, flightHours, level, totalXp, streakDays];
}
