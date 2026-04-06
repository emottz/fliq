class AiAnalysisResult {
  final String summary;
  final List<AiFocusArea> focusAreas;
  final List<String> studyTips;

  const AiAnalysisResult({
    required this.summary,
    required this.focusAreas,
    required this.studyTips,
  });

  factory AiAnalysisResult.fromJson(Map<String, dynamic> json) {
    return AiAnalysisResult(
      summary: json['summary'] as String? ?? '',
      focusAreas: (json['focus_areas'] as List<dynamic>? ?? [])
          .map((e) => AiFocusArea.fromJson(e as Map<String, dynamic>))
          .toList(),
      studyTips: (json['study_tips'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class AiFocusArea {
  final String title;
  final String description;
  final String priority; // 'high' | 'medium'

  const AiFocusArea({
    required this.title,
    required this.description,
    required this.priority,
  });

  factory AiFocusArea.fromJson(Map<String, dynamic> json) {
    return AiFocusArea(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String? ?? 'medium',
    );
  }

  bool get isHigh => priority == 'high';
}
