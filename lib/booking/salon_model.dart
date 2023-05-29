import 'package:cloud_firestore/cloud_firestore.dart';

class Salonmodel {
  String name = '';
  String address = '';
  String docId = '';
  late DocumentReference reference;
  Salonmodel();
  Salonmodel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    return data;
  }
}
