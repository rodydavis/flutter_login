import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.token,
    this.avatar,
    this.firstname,
    this.id,
    this.lastname,
  });

  final int id;

  @JsonKey(name: "first_name")
  final String firstname;

  @JsonKey(name: "last_name")
  final String lastname;

  final String avatar;

  @JsonKey(nullable: true)
  String token;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "$firstname $lastname".toString();
  }
}
