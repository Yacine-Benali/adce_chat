import 'dart:io';

import 'package:adce_chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirestoreService implements Database {
  @override
  Future<dynamic> uploadFile({
    @required String path,
    @required File file,
  }) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    print("upload done ");
    String result = await storageTaskSnapshot.ref.getDownloadURL();
    print('uploadUrl $result');
    return result;
  }

  @override
  Future<void> setData(
      {@required String path,
      @required Map<String, dynamic> data,
      @required bool merge}) async {
    final dcumentReference = FirebaseFirestore.instance.doc(path);
    print('set $path: $data');
    await dcumentReference.set(data, SetOptions(merge: merge));
  }

  Future<void> addDocument({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(path);
    print('created ${collectionReference.path}: $data');
    await collectionReference.add(data);
  }

  @override
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final List<T> result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList();

      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  @override
  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => builder(snapshot.data(), snapshot.id),
    );
  }
}
