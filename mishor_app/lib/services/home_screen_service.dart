import 'package:dio/dio.dart';
import 'package:mishor_app/models/assessment_stats.dart';


class HomeService {
  final Dio _dio = Dio();
  final String _baseUrl = "http://127.0.0.1:8000/api";


  Future<AssessmentStats> fetchAssessmentCounts(String token) async {
        try {
                    print("getting2");

      final response = await _dio.get(
        '$_baseUrl/user/assessment-counts',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data;
        return AssessmentStats.fromJson(data);
      } else {
        throw Exception("Failed to load assessment counts: Unexpected response format");
      }
    } on DioError catch (e) {
      throw Exception("Failed to load assessment counts: ${e.message}");
    }
  }

    Future<AssessmentStats> fetchApprovedAssessment(String token) async {
        try {
          print("getting");
      final response = await _dio.get(
        '$_baseUrl/user/completed-assessment-counts',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data;
        return AssessmentStats.fromJson(data);
      } else {
        throw Exception("Failed to load assessment counts: Unexpected response format");
      }
    } on DioError catch (e) {
      throw Exception("Failed to load assessment counts: ${e.message}");
    }
  }
  
}