import 'package:mishor_app/models/assessment_stats.dart';
import 'package:mishor_app/services/home_screen_service.dart';

class HomeController {
  final HomeService _homeService = HomeService();
  AssessmentStats? _assessmentStats;

  AssessmentStats? get assessmentStats => _assessmentStats;

  Future<void> loadAssessmentCounts(String token) async {
    try {
      _assessmentStats = await _homeService.fetchAssessmentCounts(token);
      print("Assessment counts fetched successfully: ${_assessmentStats!.completedAssessments}");
    } catch (e) {
      print("Error fetching assessment counts: $e");
    }
  }

  AssessmentStats? _approvedAssessmentStats;

  AssessmentStats? get approvedAssessmentStats => _approvedAssessmentStats;
  Future<void> loadApprovedAssessmentCounts(String token) async {
    try {
      _approvedAssessmentStats = await _homeService.fetchApprovedAssessment(token);
      print("Assessment counts fetched successfully: ${_approvedAssessmentStats!.completedAssessments}");
    } catch (e) {
      print("Error fetching assessment counts: $e");
    }
  }

}
