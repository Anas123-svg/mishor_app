import 'package:dio/dio.dart';
import 'package:mishor_app/models/assessment_model.dart';
import 'package:mishor_app/utilities/api.dart';


class TemplateService {
  final Dio _dio = Dio(BaseOptions(baseUrl: Api.baseUrl));
  final String baseUrl =Api.baseUrl;
  
  get http => null;
  Future<Assessment2> fetchTemplateData(int id) async {
    print(id);
    try {
      final response = await _dio.get('/assessments/$id');

      if (response.statusCode == 200) {
        final jsonData = response.data;
        print(jsonData);
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



final Dio dio = Dio(BaseOptions(
  baseUrl: Api.baseUrl,
  headers: {
    'Content-Type': 'application/json',
  },
));

Future<void> updateTemplateData(int templateID, Map<String, dynamic> data) async {
  try {
    print('Attempting to update template data...');
    print(data);
    final response = await dio.put(
      '/assessments/$templateID', 
      data: data,
    );

    if (response.statusCode == 200) {
      print('Template data updated successfully');
      print(data);
    } else {
      throw Exception('Failed to update template data: ${response.statusCode} - ${response.data}');
    }
  } on DioError catch (e) {
    if (e.response != null) {
      print('Error updating template data: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Failed to update template data: ${e.response?.statusCode} - ${e.response?.data}');
    } else {
      print('Error sending request: ${e.message}');
      throw Exception('Error updating template data: ${e.message}');
    }
  } catch (e) {
    print('Unexpected error: $e');
    throw Exception('Unexpected error updating template data: $e');
  }
}

}
