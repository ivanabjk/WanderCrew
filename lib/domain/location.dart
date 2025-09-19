class Location {
  final double latitude;
  final double longitude;
  final String? label;

  Location(this.latitude, this.longitude, [this.label]);

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'label': label,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      map['latitude'] as double,
      map['longitude'] as double,
      map['label'] as String?,
    );
  }
}