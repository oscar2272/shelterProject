class ShelterModel {
  final String facilityName, address, location;
  final int? area, capacity, capacityCount;
  final double latitude, longitude;
  final int shelterId;
  double? distance;
  ShelterModel({
    required this.shelterId,
    required this.facilityName,
    required this.address,
    required this.location,
    required this.area,
    required this.capacity,
    required this.capacityCount,
    required this.latitude,
    required this.longitude,
    this.distance,
  });

  ShelterModel.fromJson(Map<String, dynamic> json)
      : facilityName = json['facility_name'] ?? '',
        address = json['address'] ?? '',
        shelterId = json['id'],
        area = json['area'],
        capacity = json['capacity'],
        capacityCount = json['capacity_count'],
        location = json['location'] ?? '',
        latitude = json['latitude'],
        longitude = json['longitude'];
}
