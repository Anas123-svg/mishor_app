import 'package:get/get.dart';
import 'package:mishor_app/models/assessment_stats.dart';
import 'package:mishor_app/services/home_screen_service.dart';

class HomeController {
  final HomeService _homeService = HomeService();
  final Rxn<AssessmentStats> _assessmentStats = Rxn<AssessmentStats>();
  AssessmentStats? get assessmentStats => _assessmentStats.value;

  Future<void> loadAssessmentCounts(String token) async {
    try {
      final stats = await _homeService.fetchAssessmentCounts(token);
      _assessmentStats.value = stats; 
      print("Assessment counts fetched successfully: ${stats.completedAssessments}");
    } catch (e) {
      print("Error fetching assessment counts: $e");
    }
  }

  final Rxn<AssessmentStats> _approvedAssessmentStats = Rxn<AssessmentStats>();
    AssessmentStats? get approvedAssessmentStats => _approvedAssessmentStats.value;

  Future<void> loadApprovedAssessmentCounts(String token) async {
    try {
      final approvedStats = await _homeService.fetchApprovedAssessment(token);
      _approvedAssessmentStats.value = approvedStats;
      print("Approved assessment counts fetched successfully: ${approvedStats.completedAssessments}");
    } catch (e) {
      print("Error fetching approved assessment counts: $e");
    }
  }



       final Rxn<AssessmentStats> _rejectedAssessmentStats = Rxn<AssessmentStats>();
    AssessmentStats? get rejectedAssessmentStats => _rejectedAssessmentStats.value;

  Future<void> loadRejectedAssessmentCounts(String token) async {
    try {
      final rejectedStats = await _homeService.fetchRejectedAssessment(token);
      _rejectedAssessmentStats.value= rejectedStats;
      print("Assessment counts fetched successfully: ${_rejectedAssessmentStats.value!.completedAssessments}");
    } catch (e) {
      print("Error fetching assessment counts: $e");
    }
  }

}
