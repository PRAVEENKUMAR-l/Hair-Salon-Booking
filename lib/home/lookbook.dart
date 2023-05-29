import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/home/image_lookbook.dart';

Future<List<ImageModellook>> fetchLookbookData() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Lookbook').get();
  List<ImageModellook> lookbooks = [];
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in querySnapshot.docs) {
    lookbooks.add(ImageModellook.fromJson(documentSnapshot.data()));
  }
  return lookbooks;
}
