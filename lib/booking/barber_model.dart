import 'package:cloud_firestore/cloud_firestore.dart';

class BarberModel {
  String name = '';
  String email = '';
  String docId = '';
  double rating = 0.0;
  String status = '';
  late int ratingtime;
  late DocumentReference reference;
  BarberModel();
  BarberModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    status = json['status'];
    rating =
        double.parse(json['rating'] == null ? '0' : json['rating'].toString());
    ratingtime =
        int.parse(json['ratingtime'] == null ? '0' : json['rating'].toString());
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['rating'] = rating;
    data['ratingtime'] = ratingtime;

    return data;
  }
}
