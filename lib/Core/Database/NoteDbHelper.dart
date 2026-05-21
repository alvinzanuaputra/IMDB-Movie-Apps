import 'package:cloud_firestore/cloud_firestore.dart';

class FavMovielist {
  static const tablename = 'favoriatelist';
  static const columnId = 'id';
  static const columnfavid = 'tmdbid';
  static const columnfavtype = 'tmdbtype';
  static const columnfavname = 'tmdbname';
  static const columnfavrating = 'tmdbrating';
  static const columnCreatedAt = 'created_at';

  static final FavMovielist _instance = FavMovielist._internal();

  factory FavMovielist() {
    return _instance;
  }

  FavMovielist._internal();

  Future<dynamic> insert(Map<String, dynamic> row) async {
    row[columnCreatedAt] = FieldValue.serverTimestamp();
    return await FirebaseFirestore.instance.collection(tablename).add(row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(tablename).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> delete(dynamic id) async {
    await FirebaseFirestore.instance
        .collection(tablename)
        .doc(id.toString())
        .delete();
  }

//delete from database by tmdbid and tmdbtype
  Future deletespecific(String id, String type) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(tablename)
        .where(columnfavid, isEqualTo: id)
        .where(columnfavtype, isEqualTo: type)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<int> search(String id, String name, String type) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(tablename)
        .where(columnfavid, isEqualTo: id)
        .where(columnfavname, isEqualTo: name)
        .where(columnfavtype, isEqualTo: type)
        .get();
    return snapshot.docs.length;
  }

  ////sort by name

  Future<List<Map<String, dynamic>>> queryAllSorted() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(tablename)
        .orderBy(columnfavname, descending: false)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  ////sort by rating

  Future<List<Map<String, dynamic>>> queryAllSortedRating() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(tablename)
        .orderBy(columnfavrating, descending: true)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> queryAllSortedDate() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(tablename)
        .orderBy(columnCreatedAt, descending: true)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future close() async {
    // No longer required for Firestore
  }
}
