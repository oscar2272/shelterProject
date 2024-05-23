class User {
  final String name;
  final int? shelterId;
  final int? userId;

  User.fromJson(Map<String, dynamic> json)
      : userId = json["user_id"],
        name = json["username"] ?? '',
        shelterId = json["shelter_id"];
}
