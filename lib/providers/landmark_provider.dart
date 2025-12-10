import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/landmark.dart';
import '../database/database_helper.dart';
import '../services/api_service.dart';
import '../services/image_service.dart';

class LandmarkProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final ImageService _imageService = ImageService();

  List<Landmark> _landmarks = [];
  bool _isLoading = false;
  String? _error;
  bool _isOfflineMode = false;

  List<Landmark> get landmarks => _landmarks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOfflineMode => _isOfflineMode;

  Future<void> loadLandmarks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiLandmarks = await _apiService.getAllLandmarks();
      _landmarks = apiLandmarks;
      _isOfflineMode = false;

      await _dbHelper.deleteAll();
      await _dbHelper.replaceAll(apiLandmarks);
    } catch (e) {
      _landmarks = await _dbHelper.readAllLandmarks();
      _isOfflineMode = true;
      _error = 'Using offline mode: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLandmark({
    required String title,
    required double lat,
    required double lon,
    required File imageFile,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final resizedImage = await _imageService.resizeImage(imageFile);

      await _apiService.createLandmark(
        title: title,
        lat: lat,
        lon: lon,
        imageFile: resizedImage,
      );

      await loadLandmarks();
      return true;
    } catch (e) {
      _error = 'Failed to create landmark: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLandmark({
    required int id,
    required String title,
    required double lat,
    required double lon,
    File? imageFile,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      File? resizedImage;
      if (imageFile != null) {
        resizedImage = await _imageService.resizeImage(imageFile);
      }

      await _apiService.updateLandmark(
        id: id,
        title: title,
        lat: lat,
        lon: lon,
        imageFile: resizedImage,
      );

      await loadLandmarks();
      return true;
    } catch (e) {
      _error = 'Failed to update landmark: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLandmark(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
 
      await _apiService.deleteLandmark(id);

    
      await _dbHelper.delete(id);

  
      await loadLandmarks();
      return true;
    } catch (e) {
      _error = 'Failed to delete landmark: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
