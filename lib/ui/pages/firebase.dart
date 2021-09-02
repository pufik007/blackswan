import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser extends StatelessWidget {
  // final String firstName;
  // final String lastName;
  final String date;
  final String height;
  final String weight;
  final String sex;

  AddUser(
    // this.firstName,
    // this.lastName,
    this.date,
    this.height,
    this.weight,
    this.sex,
  );

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            // 'firstName': firstName, // John Doe
            // 'lastName': lastName, // Stokes and Sons
            'date': date, // 42
            'height': height, // 42
            'weight': weight, // 42
            'sex': sex, // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return ElevatedButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}
