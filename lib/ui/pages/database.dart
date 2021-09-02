import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('journey');

class Database {
  static String userUid;

  static Future<void> addItem({
    String firstName,
    String lastName,
    String date,
    String height,
    String weight,
    String gender,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('users').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "firstName": firstName,
      "lastName": lastName,
      "date": date,
      "height": height,
      "weight": weight,
      "gender": gender,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Notes item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
        _mainCollection.doc(userUid).collection('items');

    return notesItemCollection.get();
  }

  static Future<void> updateItem({
    String docId,
    String firstName,
    String lastName,
    String date,
    String height,
    String weight,
    String gender,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      "firstName": firstName,
      "lastName": lastName,
      "date": date,
      "height": height,
      "weight": weight,
      "gender": gender,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteItem({
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
