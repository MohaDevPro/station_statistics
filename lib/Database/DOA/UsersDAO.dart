import 'package:floor/floor.dart';
import 'package:station_statistics/Database/Entities/User.dart';
// import 'package:flutter/'

@dao
abstract class UserDAO {
  @Query("SELECT * FROM User")
  Future<List<User>> getAllUsers();

  @Query(
      "SELECT * FROM User where userName = :userName And password = :password")
  Future<User> getUser(String userName, String password);

  @Query("SELECT * FROM User where userName = :userName")
  Future<User> getUserByUsername(String userName);

  @Query("SELECT * FROM User where type = :type")
  Future<User> getUserByType(int type);

  // @Query("SELECT * FROM UsersE where id=:id")
  // Stream<UsersE> getAllUsersEbyid(int id);

  @Query("DELETE FROM User")
  Future<void> deleteAllUsers();

  @insert
  Future<int> insertUser(User user);

  @update
  Future<void> updateUser(User user);

  @delete
  Future<void> deleteUser(User user);
}
