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

  // Onboarding fields
  final String licenseLevel;    // not_started | theory | flight_training | ppl_holder
  final String nativeLanguage;  // turkish | other
  final String englishLevel;    // weak | medium | good
  final String goal;            // icao | general | both
  final String dailyTime;       // 5_10 | 15_20 | 30_plus
  final String examTimeline;    // not_planned | 6_months_plus | 6_months | 1_month

  // Legacy / unused (kept for model compat)
  final String flightHours;
  final String icaoLevel;
  final String hardestArea;
  final String flyingEnvironment;
  final String aircraftType;

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
    this.nativeLanguage = '',
    this.englishLevel = '',
    this.goal = '',
    this.dailyTime = '',
    this.examTimeline = '',
    this.flightHours = '',
    this.icaoLevel = '',
    this.hardestArea = '',
    this.flyingEnvironment = '',
    this.aircraftType = '',
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
    String? nativeLanguage,
    String? englishLevel,
    String? goal,
    String? dailyTime,
    String? examTimeline,
    String? flightHours,
    String? icaoLevel,
    String? hardestArea,
    String? flyingEnvironment,
    String? aircraftType,
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
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      englishLevel: englishLevel ?? this.englishLevel,
      goal: goal ?? this.goal,
      dailyTime: dailyTime ?? this.dailyTime,
      examTimeline: examTimeline ?? this.examTimeline,
      flightHours: flightHours ?? this.flightHours,
      icaoLevel: icaoLevel ?? this.icaoLevel,
      hardestArea: hardestArea ?? this.hardestArea,
      flyingEnvironment: flyingEnvironment ?? this.flyingEnvironment,
      aircraftType: aircraftType ?? this.aircraftType,
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
        'nativeLanguage': nativeLanguage,
        'englishLevel': englishLevel,
        'goal': goal,
        'dailyTime': dailyTime,
        'examTimeline': examTimeline,
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
      nativeLanguage: json['nativeLanguage'] as String? ?? '',
      englishLevel: json['englishLevel'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      dailyTime: json['dailyTime'] as String? ?? '',
      examTimeline: json['examTimeline'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [role, licenseLevel, flightHours, level, totalXp, streakDays];
}
