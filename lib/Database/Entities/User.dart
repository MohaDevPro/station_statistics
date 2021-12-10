import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  String? userName;
  String? password;
  int? type;
  User({
    this.id,
    this.userName,
    this.password,
    this.type,
  });
}
