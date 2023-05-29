// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  late String docId,
      Barberid,
      BarberName,
      CityBook,
      Username,
      Email,
      SaloonAddress,
      customerId,
      SaloonId,
      services,
      SaloonName,
      time;
  late double totalPrice;
  late bool done;
  late int slot, timestamp;

  late DocumentReference reference;
  BookingModel(
      {required this.Barberid,
      required this.BarberName,
      required this.CityBook,
      required this.Username,
      required this.Email,
      required this.services,
      required this.totalPrice,
      required this.SaloonAddress,
      required this.SaloonId,
      required this.SaloonName,
      required this.customerId,
      required this.time,
      required this.done,
      required this.slot,
      required this.timestamp});

  BookingModel.fromJson(Map<String, dynamic> json) {
    Barberid = json['Barberid'];
    BarberName = json['BarberName'];
    CityBook = json['CityBook'];
    Username = json['Username'];
    Email = json['Email'];
    SaloonAddress = json['SaloonAddress'];
    SaloonId = json['SaloonId'];
    SaloonName = json['SaloonName'];
    customerId = json['customerId'];
    services = json['services'];
    time = json['time'];
    done = json['done'] as bool;
    slot = int.parse(json['slot'] == null ? '-1' : json['slot'].toString());
    totalPrice = double.parse(
        json['totalPrice'] == null ? '0' : json['totalPrice'].toString());
    timestamp = int.parse(
        json['timestamp'] == null ? '0' : json['timestamp'].toString());
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Barberid'] = Barberid;
    data['BarberName'] = BarberName;
    data['CityBook'] = CityBook;
    data['Username'] = Username;
    data['Email'] = Email;
    data['customerId'] = customerId;
    data['SaloonAddress'] = SaloonAddress;
    data['SaloonId'] = SaloonId;
    data['SaloonName'] = SaloonName;
    data['time'] = time;
    data['done'] = done;
    data['slot'] = slot;
    data['services'] = services;
    data['totalPrice'] = totalPrice;
    data['timestamp'] = timestamp;

    return data;
  }
}
