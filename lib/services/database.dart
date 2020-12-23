import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class Database {
  Future<dynamic> uploadFile({
    @required String path,
    @required File file,
  });
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
    @required bool merge,
  });

  Future<void> addDocument({
    @required String path,
    @required Map<String, dynamic> data,
  });
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
  });

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  });
}
