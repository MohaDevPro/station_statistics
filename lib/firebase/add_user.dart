import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  AddUser(this.fullName, this.company, this.age);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() async {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}

class DatabaseServices {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String username, String password, int type) async {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(username)
        .set({
          // 'username': username, // John Doe
          'password': password, // Stokes and Sons
          'type': type // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getAllUsers() async {
    List<QueryDocumentSnapshot<Object?>> list = [];
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      list.addAll(querySnapshot.docs);
      querySnapshot.docs.forEach((doc) {
        // print(doc["username"] + doc["password"]);
      });
    });
    return list;
  }

  Future<bool> validUser(
      {required String username, required String password}) async {
    var users = await getAllUsers();
    for (var user in users) {
      if (user["username"] == username && user["password"] == password) {
        return true;
      }
    }
    return false;
  }

  Future validUser2(
      {required String username, required String password}) async {
    var user = await users.doc(username).get();
    if (user.exists) {
      if (user["password"] == password) {
        return user;
      }
    }
    // for (var user in users) {
    //   if (user["username"] == username && user["password"] == password) {
    //     return true;
    //   }
    // }

    return false;
  }
}
