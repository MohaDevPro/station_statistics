import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey()
  final int id;
  String userName;
  String password;
  int type;
  User({
    this.id,
    this.userName,
    this.password,
    this.type,
  });
}
