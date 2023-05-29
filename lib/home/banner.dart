import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/home/image_maker.dart';

Future<List<ImageModel>> fetchBannerData() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Banner').get();
  List<ImageModel> banners = [];
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in querySnapshot.docs) {
    banners.add(ImageModel.fromJson(documentSnapshot.data()));
  }
  return banners;
}
