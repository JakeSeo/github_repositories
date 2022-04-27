class Repository {
  String? name;
  String? description;
  String? owner;
  int? numStars;
  bool starred;

  Repository(
    this.name,
    this.description,
    this.owner,
    this.numStars,
    this.starred,
  );
  factory Repository.fromJson(dynamic json) {
    return Repository(
      json['name'] as String,
      json['description'] == null ? null : json['description'] as String,
      json['owner']["login"] as String,
      json['stargazers_count'] as int,
      false,
    );
  }
}
