// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/booking/state_management.dart';
import 'package:flutter_application_2/booking/submit_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<List<BookingModel>> getBarberHistory(
    BuildContext context, DateTime dateTime, WidgetRef ref) async {
  var listBooking = List<BookingModel>.empty(growable: true);
  var barberDocument = FirebaseFirestore.instance
      .collection('AllSalons')
      .doc(ref.read(selectedCity.state).state.name)
      .collection('Branch')
      .doc(ref.read(selectedSalon.state).state.docId)
      .collection('Barber')
      .doc('${FirebaseAuth.instance.currentUser!.email}')
      .collection(DateFormat('dd_MM_yyyy').format(dateTime));

  var snapshot = await barberDocument.get();
  for (var element in snapshot.docs) {
    var barberBooking = BookingModel.fromJson(element.data());
    barberBooking.docId = element.id;
    barberBooking.reference = element.reference;
    listBooking.add(barberBooking);
  }
  return listBooking;
}
