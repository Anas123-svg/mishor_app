import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mishor_app/models/assessment_model.dart';


class TemplateService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/'));
  final String baseUrl ='http://127.0.0.1:8000/api';
  
  get http => null;
  Future<Assessment2> fetchTemplateData(int id) async {
    print(id);
    try {
      final response = await _dio.get('assessments/$id');

      if (response.statusCode == 200) {
        final jsonData = response.data;
        return Assessment2.fromJson(jsonData);
      } else {
        print((response.data));
        throw Exception('Failed to load template data');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error: ${e.response?.data}');
        throw Exception('Failed to load template data: ${e.response?.statusCode} and ${id}');
      } else {
        print('Dio error: ${e.message}');
        throw Exception('Failed to load template data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load template data');
    }
  }

    Future<void> updateTemplateData(int templateID, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/assessments/$templateID');
    
    try {
      print(data);
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_auth_token', 
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Template data updated successfully');
      } else {
        throw Exception('Failed to update template data: ${response.statusCode} and ${data}');
      }
    } catch (e) {
      throw Exception('Error updating template data: $e');
    }
  }

}
