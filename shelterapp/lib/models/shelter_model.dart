class ShelterModel {
  final String facilityName, address, loaction;
  final int? area, capacity, capacityCount;
  ShelterModel.fromJson(Map<String, dynamic> json)
      : facilityName = json['facility_name'] ?? '',
        address = json['address'] ?? '',
        area = json['area'],
        capacity = json['capacity'],
        capacityCount = json['capacity_count'],
        loaction = json['loaction'] ?? '';
}
