import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/landmark_provider.dart';
import '../models/landmark.dart';
import '../services/location_service.dart';

class LandmarkFormScreen extends StatefulWidget {
  final Landmark? landmark;

  const LandmarkFormScreen({super.key, this.landmark});

  @override
  State<LandmarkFormScreen> createState() => _LandmarkFormScreenState();
}

class _LandmarkFormScreenState extends State<LandmarkFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final LocationService _locationService = LocationService();
  final ImagePicker _imagePicker = ImagePicker();
  final MapController _mapController = MapController();
  
  File? _selectedImage;
  bool _isLoadingLocation = false;
  bool _isSubmitting = false;
  LatLng _mapCenter = LatLng(23.8103, 90.4125); 

  bool get isEditing => widget.landmark != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.landmark!.title;
      _latController.text = widget.landmark!.lat.toString();
      _lonController.text = widget.landmark!.lon.toString();
      _mapCenter = LatLng(widget.landmark!.lat, widget.landmark!.lon);
    } else {
      _detectLocation();
    }

    _latController.addListener(_updateMapFromFields);
    _lonController.addListener(_updateMapFromFields);
  }

  void _updateMapFromFields() {
    final lat = double.tryParse(_latController.text);
    final lon = double.tryParse(_lonController.text);
    if (lat != null && lon != null && lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180) {
      setState(() {
        _mapCenter = LatLng(lat, lon);
      });
      _mapController.move(_mapCenter, _mapController.camera.zoom);
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateMapFromFields);
    _lonController.removeListener(_updateMapFromFields);
    _titleController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    setState(() => _isLoadingLocation = true);

    final coordinates = await _locationService.getCurrentCoordinates();
    
    if (coordinates != null && mounted) {
      _latController.text = coordinates['lat']!.toStringAsFixed(6);
      _lonController.text = coordinates['lon']!.toStringAsFixed(6);
      setState(() {
        _mapCenter = LatLng(coordinates['lat']!, coordinates['lon']!);
      });
      _mapController.move(_mapCenter, 15.0);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location detected'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to detect location. Please enable location services.'),
          backgroundColor: Colors.orange,
        ),
      );
    }

    setState(() => _isLoadingLocation = false);
  }

  Future<void> _pickImage() async {
    try {
      PermissionStatus status;
      if (Platform.isAndroid) {
        final androidInfo = await Permission.photos.status;
        if (androidInfo.isDenied) {
          status = await Permission.photos.request();
        } else {
          status = androidInfo;
        }
      } else {
        status = PermissionStatus.granted;
      }

      if (status.isDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo permission is required to select images'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please enable photo permission in settings'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      final status = await Permission.camera.request();

      if (status.isDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission is required to take photos'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please enable camera permission in settings'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to take picture: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SELECT IMAGE SOURCE'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('GALLERY'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('CAMERA'),
              onTap: () {
                Navigator.pop(context);
                _takePicture();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!isEditing && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final provider = Provider.of<LandmarkProvider>(context, listen: false);
    final title = _titleController.text.trim();
    final lat = double.parse(_latController.text);
    final lon = double.parse(_lonController.text);

    bool success;
    if (isEditing) {
      success = await provider.updateLandmark(
        id: widget.landmark!.id!,
        title: title,
        lat: lat,
        lon: lon,
        imageFile: _selectedImage,
      );
    } else {
      success = await provider.createLandmark(
        title: title,
        lat: lat,
        lon: lon,
        imageFile: _selectedImage!,
      );
    }

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing 
              ? 'Landmark updated successfully' 
              : 'Landmark created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'Operation failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'EDIT LANDMARK' : 'NEW ENTRY',
          style: const TextStyle(letterSpacing: 2),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Map Section
            const Text(
              'TAP ON MAP TO SET LOCATION',
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF00F0FF),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF00F0FF), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F0FF).withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _mapCenter,
                    initialZoom: 13.0,
                    onTap: (tapPosition, latLng) {
                      setState(() {
                        _mapCenter = latLng;
                        _latController.text = latLng.latitude.toStringAsFixed(6);
                        _lonController.text = latLng.longitude.toStringAsFixed(6);
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.anontech.landmarks.bangladesh_landmarks',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _mapCenter,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.location_on,
                            size: 50,
                            color: Color(0xFFFF006E),
                            shadows: [
                              Shadow(
                                color: Color(0xFFFF006E),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Photo Section
            const Text(
              'PHOTO',
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFFFF006E),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 300,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0221),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF6B4D87), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B4D87).withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : widget.landmark?.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              widget.landmark!.image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 64, color: Color(0xFF6B4D87)),
                              SizedBox(height: 8),
                              Text(
                                'TAP TO SELECT IMAGE',
                                style: TextStyle(
                                  color: Color(0xFF6B4D87),
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 20),

            // Title field
            const Text(
              'TITLE',
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFFFFEA00),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter landmark title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Coordinates Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LATITUDE',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFF00F0FF),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _latController,
                        decoration: const InputDecoration(
                          hintText: '23.772571',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.arrow_upward),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          final lat = double.tryParse(value);
                          if (lat == null || lat < -90 || lat > 90) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LONGITUDE',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFF00F0FF),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _lonController,
                        decoration: const InputDecoration(
                          hintText: '90.424381',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.arrow_forward),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          final lon = double.tryParse(value);
                          if (lon == null || lon < -180 || lon > 180) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Detect Location Button
            OutlinedButton.icon(
              onPressed: _isLoadingLocation ? null : _detectLocation,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF006E), width: 2),
                foregroundColor: const Color(0xFFFF006E),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: _isLoadingLocation
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF006E)),
                    )
                  : const Icon(Icons.gps_fixed),
              label: Text(
                _isLoadingLocation ? 'DETECTING...' : 'USE MY CURRENT LOCATION',
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F0FF),
                  foregroundColor: const Color(0xFF0A0118),
                  shadowColor: const Color(0xFF00F0FF),
                  elevation: 12,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0A0118)),
                      )
                    : const Icon(Icons.save, size: 24),
                label: Text(
                  isEditing ? 'UPDATE LANDMARK' : 'CREATE LANDMARK',
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
