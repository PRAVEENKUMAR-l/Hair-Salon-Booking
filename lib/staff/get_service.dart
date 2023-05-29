// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/booking/state_management.dart';
import 'package:flutter_application_2/staff/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<ServiceModel>> getService(
    BuildContext context, WidgetRef ref) async {
  var service = List<ServiceModel>.empty(growable: true);
  var serviceRef = FirebaseFirestore.instance.collection('Services');
  var snapshot = await serviceRef
      .where(ref.read(selectedSalon.state).state.docId, isEqualTo: true)
      .get();
  for (var element in snapshot.docs) {
    var serviceModel = ServiceModel.fromJson(element.data());
    serviceModel.docId = element.id;
    service.add(serviceModel);
  }
  return service;
}
