class Landmark {
  final int? id;
  final String title;
  final double lat;
  final double lon;
  final String? image; // URL or local path
  final String? localImagePath; // For offline storage
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Landmark({
    this.id,
    required this.title,
    required this.lat,
    required this.lon,
    this.image,
    this.localImagePath,
    this.createdAt,
    this.updatedAt,
  });

  // From JSON (API response)
  factory Landmark.fromJson(Map<String, dynamic> json) {
    // Fix relative image paths
    String? imageUrl = json['image'];
    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Convert relative path to absolute URL if needed
      if (!imageUrl.startsWith('http://') && 
          !imageUrl.startsWith('https://') && 
          !imageUrl.startsWith('file://')) {
        imageUrl = 'https://labs.anontech.info/cse489/t3/$imageUrl';
      }
    }
    
    return Landmark(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      title: json['title'] ?? '',
      lat: double.tryParse(json['lat'].toString()) ?? 0.0,
      lon: double.tryParse(json['lon'].toString()) ?? 0.0,
      image: imageUrl,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  // To JSON (API request)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'lat': lat.toString(),
      'lon': lon.toString(),
      if (image != null) 'image': image,
    };
  }

  // From database
  factory Landmark.fromDatabase(Map<String, dynamic> map) {
    // Fix relative image paths from database too
    String? imageUrl = map['image'];
    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Convert relative path to absolute URL if needed
      if (!imageUrl.startsWith('http://') && 
          !imageUrl.startsWith('https://') && 
          !imageUrl.startsWith('file://')) {
        imageUrl = 'https://labs.anontech.info/cse489/t3/$imageUrl';
      }
    }
    
    return Landmark(
      id: map['id'],
      title: map['title'],
      lat: map['lat'],
      lon: map['lon'],
      image: imageUrl,
      localImagePath: map['local_image_path'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : null,
    );
  }

  // To database
  Map<String, dynamic> toDatabase() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'lat': lat,
      'lon': lon,
      'image': image,
      'local_image_path': localImagePath,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Copy with
  Landmark copyWith({
    int? id,
    String? title,
    double? lat,
    double? lon,
    String? image,
    String? localImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Landmark(
      id: id ?? this.id,
      title: title ?? this.title,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      image: image ?? this.image,
      localImagePath: localImagePath ?? this.localImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
