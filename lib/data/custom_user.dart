class CustomUser {
  String name = "Default Name";
  String imagePath = "";

  CustomUser(this.name, this.imagePath);

  factory CustomUser.fromJson(dynamic json) {
    return CustomUser(
      json['login'] as String,
      json['avatar_url'] as String,
    );
  }
}
