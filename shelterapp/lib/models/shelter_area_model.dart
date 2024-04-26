class ShelterSearchModel {
  final String sidoCode, sidoName, sigunguCode, sigunguName;

  ShelterSearchModel.fromJson(Map<String, dynamic> json)
      : sidoCode = json['sido_code'] ?? '',
        sidoName = json['sido_name'] ?? '-',
        sigunguCode = json['sigungu_code'] ?? '',
        sigunguName = json['sigungu_name'] ?? '-';
}
