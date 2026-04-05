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

  const UserProfileModel({
    required this.role,
    required this.experienceYears,
    this.targetExamDate,
    required this.level,
    required this.totalXp,
    required this.streakDays,
    this.lastActiveDate,
    required this.categoryProgress,
  });

  static UserProfileModel empty() => const UserProfileModel(
        role: 'student',
        experienceYears: 0,
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
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      role: json['role'] as String,
      experienceYears: json['experienceYears'] as int,
      targetExamDate: json['targetExamDate'] != null
          ? DateTime.tryParse(json['targetExamDate'] as String)
          : null,
      level: ProficiencyLevel.values.firstWhere(
        (l) => l.name == json['level'],
        orElse: () => ProficiencyLevel.beginner,
      ),
      totalXp: json['totalXp'] as int,
      streakDays: json['streakDays'] as int,
      lastActiveDate: json['lastActiveDate'] as String?,
      categoryProgress: (json['categoryProgress'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }

  @override
  List<Object?> get props => [role, experienceYears, level, totalXp, streakDays];
}
