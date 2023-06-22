// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:ui';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/booking/state_management.dart';
import 'package:flutter_application_2/booking/util.dart';
import 'package:flutter_application_2/staff/get_service.dart';
import 'package:flutter_application_2/staff/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../booking/submit_model.dart';

class DoneService extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DoneService({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(selectedService.state).state.clear();
    cancelDone(BuildContext context) {
      var batch = FirebaseFirestore.instance.batch();
      var barberBook = ref.read(selectedBooking.state).state;
      var userBook = FirebaseFirestore.instance
          .collection('user')
          .doc(barberBook.Email)
          .collection('Booking_${barberBook.customerId}')
          .doc(
              '${barberBook.Barberid}_${DateFormat('dd_MM_yyyy').format(DateTime.fromMillisecondsSinceEpoch(barberBook.timestamp))}_${barberBook.slot}');
      Map<String, dynamic> cancelDone = {};
      print(DateFormat('dd_MM_yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(barberBook.timestamp)));
      print(barberBook.slot);
      print(barberBook.Barberid);
      cancelDone['isCancelled'] = true;
      batch.update(userBook, cancelDone);
      batch.update(barberBook.reference, cancelDone);
      batch.commit().then((value) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('cancellation Done')))
            .closed
            .then((value) => Navigator.of(context).pop());
      });
    }

    finishService(BuildContext context) {
      var batch = FirebaseFirestore.instance.batch();
      var barberBook = ref.read(selectedBooking.state).state;
      var userBook = FirebaseFirestore.instance
          .collection('user')
          .doc(barberBook.Email)
          .collection('Booking_${barberBook.customerId}')
          .doc(
              '${barberBook.Barberid}_${DateFormat('dd_MM_yyyy').format(DateTime.fromMillisecondsSinceEpoch(barberBook.timestamp))}_${ref.read(selectedTimeSlot.state).state}');

      Map<String, dynamic> updateDone = {};

      print(DateFormat('dd_MM_yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(barberBook.timestamp)));
      print(ref.read(selectedTimeSlot.state).state);
      print(barberBook.Barberid);
      updateDone['done'] = true;
      updateDone['services'] =
          convertService(ref.read(selectedService.state).state);
      updateDone['totalPrice'] = ref
          .read(selectedService.state)
          .state
          .map((e) => e.price)
          .fold(0.0, (previousValue, element) => previousValue + element);
      batch.update(userBook, updateDone);
      batch.update(barberBook.reference, updateDone);
      batch.commit().then((value) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Service Done')))
            .closed
            .then((value) => Navigator.of(context).pop());
      });
    }

    Future<BookingModel> getBookingDet(
        BuildContext context, int timeSlot) async {
      CollectionReference userRef = FirebaseFirestore.instance
          .collection('AllSalons')
          .doc(ref.read(selectedCity.state).state.name)
          .collection('Branch')
          .doc(ref.read(selectedSalon.state).state.docId)
          .collection('Barber')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection(DateFormat('dd_MM_yyyy')
              .format(ref.read(selectedDate.state).state));
      DocumentSnapshot snapshot = await userRef.doc(timeSlot.toString()).get();
      if (snapshot.exists) {
        var bookingModel =
            BookingModel.fromJson(json.decode(json.encode(snapshot.data())));
        bookingModel.docId = snapshot.id;
        bookingModel.reference = snapshot.reference;
        ref.read(selectedBooking.state).state = bookingModel;
        return bookingModel;
      } else {
        return BookingModel(
            Email: '',
            Barberid: '',
            BarberName: '',
            CityBook: '',
            Username: '',
            customerId: '',
            SaloonAddress: '',
            SaloonId: '',
            SaloonName: '',
            time: '',
            done: false,
            isCancelled: false,
            services: '',
            totalPrice: 0.0,
            slot: 0,
            timestamp: 0);
      }
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Done Service'),
          backgroundColor: const Color.fromARGB(255, 87, 81, 81),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFFDF9EE),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: FutureBuilder(
                      future: getBookingDet(
                          context, ref.read(selectedTimeSlot.state).state),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var bookingModel = snapshot.data as BookingModel;
                          return Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Colors.black,
                                        child: Icon(
                                          Icons.account_box,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bookingModel.Username,
                                            style: GoogleFonts.robotoMono(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Consumer(builder: (context, ref, _) {
                                        var serviceSelected = ref
                                            .watch(selectedService.state)
                                            .state;
                                        var totalPrice = serviceSelected
                                            .map((e) => e.price)
                                            .fold(
                                                0.0,
                                                (previousValue, element) =>
                                                    previousValue + element);
                                        return Text(
                                          'Price : Rs.${ref.read(selectedBooking.state).state.totalPrice == 0.0 ? totalPrice : ref.read(selectedBooking.state).state.totalPrice}',
                                          style: GoogleFonts.robotoMono(
                                              fontSize: 20),
                                        );
                                      }),
                                      ref.read(selectedBooking.state).state.done
                                          ? const Chip(label: Text('Finish'))
                                          : ref
                                                  .read(selectedBooking.state)
                                                  .state
                                                  .isCancelled
                                              ?  Chip(
                                                  label: Text('Cancelled'))
                                              : Container()
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      })),
              Padding(
                padding: const EdgeInsets.all(8),
                child: FutureBuilder(
                  future: getService(context, ref),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var services = snapshot.data as List<ServiceModel>;

                      return Consumer(builder: ((context, ref, _) {
                        var Services = ref.watch(selectedService.state).state;
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                color: Colors.white10,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: services.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var service = services[index];
                                    return CheckboxListTile(
                                      title: Text(
                                          '${service.name} : Rs.${service.price}'),
                                      value: Services.contains(service),
                                      onChanged: (val) {
                                        var newSelectedServices =
                                            List<ServiceModel>.from(Services);
                                        if (val!) {
                                          newSelectedServices.add(service);
                                        } else {
                                          newSelectedServices.remove(service);
                                        }
                                        ref.read(selectedService.state).state =
                                            newSelectedServices;
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    onPressed: ref
                                                .read(selectedBooking.state)
                                                .state
                                                .done ||
                                            ref
                                                .read(selectedBooking.state)
                                                .state
                                                .isCancelled
                                        ? null
                                        : services.isNotEmpty
                                            ? () => finishService(context)
                                            : null,
                                    child: Text(
                                      'Finish',
                                      style: GoogleFonts.robotoMono(),
                                    )),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    onPressed: ref
                                                .read(selectedBooking.state)
                                                .state
                                                .isCancelled ||
                                            ref
                                                .read(selectedBooking.state)
                                                .state
                                                .done
                                        ? null
                                        : () => cancelDone(context),
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.robotoMono(
                                          color: Colors.red),
                                    )),
                              )
                            ],
                          ),
                        );
                      }));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
