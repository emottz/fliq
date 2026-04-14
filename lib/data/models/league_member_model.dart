class LeagueMemberModel {
  final String uid;
  final String displayName;
  final String? photoUrl;
  final int weeklyXp;
  final int streakDays;
  final String role;

  const LeagueMemberModel({
    required this.uid,
    required this.displayName,
    this.photoUrl,
    required this.weeklyXp,
    required this.streakDays,
    required this.role,
  });

  factory LeagueMemberModel.fromJson(String uid, Map<String, dynamic> json) {
    return LeagueMemberModel(
      uid: uid,
      displayName: json['displayName'] as String? ?? 'Kullanıcı',
      photoUrl: json['photoUrl'] as String?,
      weeklyXp: json['weeklyXp'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      role: json['role'] as String? ?? 'student',
    );
  }

  factory LeagueMemberModel.fromSupabase(Map<String, dynamic> row) {
    return LeagueMemberModel(
      uid:         row['uid'] as String? ?? '',
      displayName: row['display_name'] as String? ?? 'Kullanıcı',
      photoUrl:    row['photo_url'] as String?,
      weeklyXp:    row['weekly_xp'] as int? ?? 0,
      streakDays:  row['streak_days'] as int? ?? 0,
      role:        row['role'] as String? ?? 'student',
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'photoUrl': photoUrl,
        'weeklyXp': weeklyXp,
        'streakDays': streakDays,
        'role': role,
      };
}
