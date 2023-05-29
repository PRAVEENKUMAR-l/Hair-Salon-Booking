// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/booking/state_management.dart';
import 'package:flutter_application_2/history/get_details.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../booking/submit_model.dart';
import '../booking/util.dart';

class BarberHistoryScreen extends ConsumerWidget {
  const BarberHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dateWatch = ref.watch(barberHistoryDate.state).state;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFDF9EE),
      appBar: AppBar(
        title: const Text('Barber History'),
        backgroundColor: const Color.fromARGB(255, 87, 81, 81),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 20, 27, 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          DateFormat.MMMM().format(dateWatch),
                          selectionColor: Colors.white,
                          style: GoogleFonts.abyssinicaSil(color: Colors.white),
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          '${dateWatch.day}',
                          style: GoogleFonts.adamina(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat.EEEE().format(dateWatch),
                          style: GoogleFonts.abrilFatface(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                onConfirm: (date) => ref
                                    .read(barberHistoryDate.state)
                                    .state = date);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getBarberHistory(context, dateWatch, ref),
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            var synTime = snapshot.data as DateTime;
                            return ListView.builder(
                                itemCount: userBooking.length,
                                itemBuilder: ((context, index) {
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        'Date',
                                                        style: GoogleFonts
                                                            .akshar(),
                                                      ),
                                                      Text(
                                                        DateFormat("dd/MM/yy")
                                                            .format(DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    userBooking[
                                                                            index]
                                                                        .timestamp)),
                                                        style: GoogleFonts
                                                            .robotoMono(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        'Time',
                                                        style: GoogleFonts
                                                            .akshar(),
                                                      ),
                                                      Text(
                                                        TIME_SLOT.elementAt(
                                                            userBooking[index]
                                                                .slot),
                                                        style: GoogleFonts
                                                            .robotoMono(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                                          style: GoogleFonts
                                                              .robotoFlex(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      20)),
                                                      Text(
                                                          userBooking[index]
                                                              .BarberName,
                                                          style: GoogleFonts
                                                              .robotoFlex(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 10))
                                                    ],
                                                  ),
                                                  Text(
                                                      userBooking[index]
                                                          .SaloonAddress,
                                                      style: GoogleFonts
                                                          .robotoFlex(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 7))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }));
                          }
                        });
                  }
                }),
          )
        ],
      ),
    ));
  }
}
