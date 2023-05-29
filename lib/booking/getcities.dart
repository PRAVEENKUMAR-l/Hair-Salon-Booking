import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/booking/barber_model.dart';
import 'package:flutter_application_2/booking/cities_model.dart';
import 'package:flutter_application_2/booking/salon_model.dart';
import 'package:flutter_application_2/booking/state_management.dart';
import 'package:flutter_application_2/booking/submit_model.dart';
import 'package:flutter_application_2/home/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<Citymodel>> fetchCityData() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('AllSalons').get();
  List<Citymodel> cities = [];
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in querySnapshot.docs) {
    cities.add(Citymodel.fromJson(documentSnapshot.data()));
  }
  return cities;
}

Future<List<Salonmodel>> fetchSalonData(String cityName) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection('AllSalons')
      .doc(cityName)
      .collection('Branch')
      .get();
  List<Salonmodel> salon = [];
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in querySnapshot.docs) {
    var salons = Salonmodel.fromJson(documentSnapshot.data());
    salons.docId = documentSnapshot.id;
    salons.reference = documentSnapshot.reference;
    salon.add(salons);
  }
  return salon;
}

Future<List<BarberModel>> fetchBarberData(Salonmodel salon) async {
  var barbers = List<BarberModel>.empty(growable: true);
  var barberRef = salon.reference.collection('Barber');
  var snapshot = await barberRef.get();
  for (var element in snapshot.docs) {
    var barber = BarberModel.fromJson(element.data());
    barber.docId = element.id;
    barber.reference = element.reference;
    barbers.add(barber);
  }
  return barbers;
}

Future<List<int>> getTimeSlotOfBarber(
    BarberModel barberModel, String date) async {
  List<int> result = List<int>.empty(growable: true);
  var bookingRef = barberModel.reference.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  for (var element in snapshot.docs) {
    result.add(int.parse(element.id));
  }
  return result;
}

Future<List<BookingModel>> getUserHistory() async {
  var listBooking = List<BookingModel>.empty(growable: true);
  var userref = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('Booking_${FirebaseAuth.instance.currentUser!.uid}');
  var snapshot = await userref.orderBy('timestamp', descending: true).get();
  for (var element in snapshot.docs) {
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  }
  return listBooking;
}
