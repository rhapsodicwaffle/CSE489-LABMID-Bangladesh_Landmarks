import 'dart:io';
import 'package:dio/dio.dart';
import '../models/landmark.dart';

class ApiService {
  static const String baseUrl = 'https://labs.anontech.info/cse489/t3/api.php';
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Map<String, dynamic>> createLandmark({
    required String title,
    required double lat,
    required double lon,
    required File imageFile,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create landmark: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<Landmark>> getAllLandmarks() async {
    try {
      final response = await _dio.get('');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => Landmark.fromJson(json))
              .toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load landmarks: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> updateLandmark({
    required int id,
    required String title,
    required double lat,
    required double lon,
    File? imageFile,
  }) async {
    try {
      print('DEBUG: Updating landmark with id: $id, title: $title');
      
      if (imageFile != null) {
        FormData formData = FormData.fromMap({
          'id': id.toString(),
          'title': title,
          'lat': lat.toString(),
          'lon': lon.toString(),
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        });

        print('DEBUG: Sending PUT update with image');
        final response = await _dio.put(
          '',
          data: formData,
        );

        print('DEBUG: Update response status: ${response.statusCode}');
        print('DEBUG: Update response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.data;
        } else {
          throw Exception('Failed to update landmark: ${response.statusCode}');
        }
      } else {
        print('DEBUG: Sending PUT update without image');
        final response = await _dio.put(
          '',
          data: FormData.fromMap({
            'id': id.toString(),
            'title': title,
            'lat': lat.toString(),
            'lon': lon.toString(),
          }),
        );

        print('DEBUG: Update response status: ${response.statusCode}');
        print('DEBUG: Update response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.data;
        } else {
          throw Exception('Failed to update landmark: ${response.statusCode}');
        }
      }
    } on DioException catch (e) {
      print('DEBUG: Update error: ${e.message}');
      print('DEBUG: Update error response: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> deleteLandmark(int id) async {
    try {
      final response = await _dio.delete(
        '?id=$id',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to delete landmark: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
