// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/booking/getcities.dart';
import 'package:flutter_application_2/booking/state_management.dart';
import 'package:flutter_application_2/booking/submit_model.dart';
import 'package:flutter_application_2/booking/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Historyscreen extends ConsumerWidget {
  const Historyscreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var delteFlag = ref.watch(deleteFlag.state).state;
    cancelBooking(BuildContext context, BookingModel bookingModel) {
      var batch = FirebaseFirestore.instance.batch();
      var barberbooking = FirebaseFirestore.instance
          .collection('AllSalons')
          .doc(bookingModel.CityBook)
          .collection('Branch')
          .doc(bookingModel.SaloonId)
          .collection('Barber')
          .doc(bookingModel.Barberid)
          .collection(DateFormat('dd_MM_yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(bookingModel.timestamp)))
          .doc(bookingModel.slot.toString());

      var userBooking = bookingModel.reference;
      batch.delete(userBooking);
      batch.delete(barberbooking);
      batch.commit().then((value) {
        Navigator.of(context).pop();

        ref.read(deleteFlag.state).state = !ref.read(deleteFlag.state).state;
      });
    }

    userHistorydisplay() {
      return FutureBuilder(
          future: getUserHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            } else {
              List<BookingModel> userBooking = snapshot.data!;
              return FutureBuilder(
                  future: syncTime(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      var synTime = snapshot.data as DateTime;
                      return ListView.builder(
                          itemCount: userBooking.length,
                          itemBuilder: ((context, index) {
                            var isExpired = DateTime.fromMillisecondsSinceEpoch(
                                    userBooking[index].timestamp)
                                .isBefore(synTime);
                            //print(isExpired);
                            //print(synTime);
                            return Card(
                              elevation: 8,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Date',
                                                  style: GoogleFonts.akshar(),
                                                ),
                                                Text(
                                                  DateFormat("dd/MM/yy").format(
                                                      DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              userBooking[index]
                                                                  .timestamp)),
                                                  style: GoogleFonts.robotoMono(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Time',
                                                  style: GoogleFonts.akshar(),
                                                ),
                                                Text(
                                                  TIME_SLOT.elementAt(
                                                      userBooking[index].slot),
                                                  style: GoogleFonts.robotoMono(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 3,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    userBooking[index]
                                                        .SaloonName,
                                                    style:
                                                        GoogleFonts.robotoFlex(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20)),
                                                Text(
                                                    userBooking[index]
                                                        .BarberName,
                                                    style:
                                                        GoogleFonts.robotoFlex(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 10))
                                              ],
                                            ),
                                            Text(
                                                userBooking[index]
                                                    .SaloonAddress,
                                                style: GoogleFonts.robotoFlex(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 7))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (isExpired ||
                                            userBooking[index].done)
                                        ? null
                                        : () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    icon: const Icon(
                                                        Icons.dangerous),
                                                    iconColor: Colors.red,
                                                    title: const Text(
                                                        'CANCELLATION !!!'),
                                                    content: const Text(
                                                        'do you want to cancel the alloted slot'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            cancelBooking(
                                                                context,
                                                                userBooking[
                                                                    index]);
                                                          },
                                                          child: const Text(
                                                              'yes')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('no'))
                                                    ],
                                                  );
                                                });
                                          },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(22),
                                              bottomRight:
                                                  Radius.circular(22))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              userBooking[index].done
                                                  ? 'FINISHED'
                                                  : isExpired
                                                      ? 'EXPIRED'
                                                      : 'CANCEL',
                                              style: GoogleFonts.robotoMono(
                                                  color: isExpired
                                                      ? Colors.grey
                                                      : userBooking[index].done
                                                          ? Colors.green
                                                          : Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }));
                    }
                  });
            }
          });
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('history'),
        backgroundColor: const Color.fromARGB(255, 87, 81, 81),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFDF9EE),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: userHistorydisplay(),
      ),
    ));
  }
}
