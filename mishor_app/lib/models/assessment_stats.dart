class AssessmentStats {
  final int completedAssessments;
  final int rejectedAssessments;
  final int pendingAssessments;
  final int totalAssessments;
  final Map<String, int> dailyApprovedCounts;
  final List<Assessment> rejectedAssessmentsList;

  AssessmentStats({
    required this.completedAssessments,
    required this.rejectedAssessments,
    required this.pendingAssessments,
    required this.totalAssessments,
    required this.dailyApprovedCounts,
    required this.rejectedAssessmentsList,
  });

  factory AssessmentStats.fromJson(Map<String, dynamic> json) {
    return AssessmentStats(
      completedAssessments: json['user']['completed_assessments'] ?? 0,
      rejectedAssessments: json['user']['rejected_assessments'] ?? 0,
      pendingAssessments: json['user']['pending_assessments'] ?? 0,
      totalAssessments: json['user']['total_assessments'] ?? 0,
      dailyApprovedCounts: Map<String, int>.from(json['daily_approved_counts'] ?? {}),
      rejectedAssessmentsList: (json['assigned_assessments'] as List)
          .map((assessment) => Assessment.fromJson(assessment))
          .toList(),
    );
  }
}


class Assessment {
  final int id;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String Location; 
  final String name;

  Assessment({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.Location,
    required this.name,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      status: json['status']??'',
      Location: json['location']??'',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      name: json['name']??'',
    );
  }
}
