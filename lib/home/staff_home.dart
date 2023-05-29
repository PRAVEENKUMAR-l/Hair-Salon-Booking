// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/booking/barber_model.dart';
import 'package:flutter_application_2/booking/cities_model.dart';
import 'package:flutter_application_2/booking/getcities.dart';
import 'package:flutter_application_2/booking/salon_model.dart';

import 'package:flutter_application_2/booking/state_management.dart';
import 'package:flutter_application_2/booking/util.dart';
import 'package:flutter_application_2/history/Barber_history.dart';
import 'package:flutter_application_2/staff/done.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StaffScreeen extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  StaffScreeen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var staffstep = ref.watch(staffStep.state).state;
    var citywatch = ref.watch(selectedCity.state).state;
    var salonwatch = ref.watch(selectedSalon.state).state;
    var barberwatch = ref.watch(selectedBarber.state).state;
    var dateWatch = ref.watch(selectedDate.state).state;
    var slot = ref.watch(selectedTimeSlot.state).state;

    processDone(BuildContext context, int index, int maxtime) {
      print(index);
      ref.read(selectedTimeSlot.state).state = index;
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => DoneService())));
    }

    Column displaySlot(BuildContext context, BarberModel barberModel) {
      var now = ref.read(selectedDate.state).state;
      return Column(
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
                          DateFormat.MMMM().format(now),
                          selectionColor: Colors.white,
                          style: GoogleFonts.abyssinicaSil(color: Colors.white),
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          '${now.day}',
                          style: GoogleFonts.adamina(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat.EEEE().format(now),
                          style: GoogleFonts.abrilFatface(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: now.add(const Duration(days: 31)),
                                onConfirm: (date) =>
                                    ref.read(selectedDate.state).state = date);
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
            future:
                getMaxAvailableTimmeslot(ref.read(selectedDate.state).state),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var maxtimeslot = snapshot.data as int;

                return FutureBuilder(
                  future: getTimeSlotOfBarber(
                      barberModel,
                      DateFormat('dd_MM_yyyy')
                          .format(ref.read(selectedDate.state).state)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data found'));
                    } else {
                      var listTimeSlot = snapshot.data as List<int>;

                      return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemCount: TIME_SLOT.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: !listTimeSlot.contains(index)
                                  ? null
                                  : () =>
                                      processDone(context, index, maxtimeslot),
                              child: Card(
                                color: listTimeSlot.contains(index)
                                    ? Colors.white10
                                    : maxtimeslot > index
                                        ? const Color.fromARGB(
                                            179, 129, 122, 122)
                                        : ref.read(selectedTime.state).state ==
                                                TIME_SLOT.elementAt(index)
                                            ? Colors.white70
                                            : Colors.white,
                                child: GridTile(
                                    header:
                                        ref.read(selectedTime.state).state ==
                                                TIME_SLOT.elementAt(index)
                                            ? const Icon(Icons.check)
                                            : null,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(TIME_SLOT.elementAt(index)),
                                          Text(listTimeSlot.contains(index)
                                              ? 'full'
                                              : maxtimeslot > index
                                                  ? 'Not available'
                                                  : 'available')
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          }));
                    }
                  },
                );
              }
            },
          )),
        ],
      );
    }

    displaySalon(String cityName) {
      return FutureBuilder(
          future: fetchSalonData(cityName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            } else {
              List<Salonmodel> salon = snapshot.data!;
              return ListView.builder(
                  itemCount: salon.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => ref.read(selectedSalon.state).state =
                              salon[index],
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.home_outlined),
                              title: Text(
                                salon[index].name,
                              ),
                              subtitle: Text(
                                salon[index].address,
                                style: GoogleFonts.robotoMono(),
                              ),
                              trailing:
                                  ref.read(selectedSalon.state).state.docId ==
                                          salon[index].docId
                                      ? const Icon(Icons.check)
                                      : null,
                            ),
                          ),
                        ));
                  }));
            }
          });
    }

    displayCity() {
      return FutureBuilder(
          future: fetchCityData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            } else {
              List<Citymodel> cities = snapshot.data!;
              return ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => ref.read(selectedCity.state).state =
                              cities[index],
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.location_city_rounded),
                              title: Text(
                                cities[index].name,
                              ),
                              trailing:
                                  ref.read(selectedCity.state).state.name ==
                                          cities[index].name
                                      ? const Icon(Icons.check)
                                      : null,
                            ),
                          ),
                        ));
                  }));
            }
          });
    }

    dispalyBarber(BuildContext context, Salonmodel salonmodel) {
      return FutureBuilder(
          future: fetchBarberData(salonmodel),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            } else {
              List<BarberModel> barber = snapshot.data!;

              return ListView.builder(
                  itemCount: barber.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            ref.read(selectedBarber.state).state =
                                barber[index];

                            if (ref.read(selectedBarber.state).state.email !=
                                FirebaseAuth.instance.currentUser!.email) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      icon: const Icon(Icons.dangerous),
                                      iconColor: Colors.red,
                                      title:
                                          const Text('YOU ARE NOT VALID !!!'),
                                      content:
                                          const Text('SELECT YOUR VALID SALON'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'))
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(
                                barber[index].name,
                              ),
                              subtitle: RatingBar.builder(
                                itemBuilder: (context, _) =>
                                    const Icon(Icons.star_half_sharp),
                                itemSize: 16,
                                allowHalfRating: true,
                                initialRating: barber[index].rating,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                ignoreGestures: true,
                                onRatingUpdate: (value) => {},
                              ),
                              trailing:
                                  ref.read(selectedBarber.state).state.docId ==
                                          barber[index].docId
                                      ? const Icon(Icons.check)
                                      : null,
                            ),
                          ),
                        ));
                  }));
            }
          });
    }

    return SafeArea(
      key: scaffoldKey,
      child: Scaffold(
          appBar: AppBar(
            title: Text(staffstep == 1
                ? 'Select City'
                : staffstep == 2
                    ? 'Select Salon'
                    : staffstep == 3
                        ? 'Barber Details'
                        : staffstep == 4
                            ? 'Booking Details'
                            : 'Home'),
            backgroundColor: const Color.fromARGB(255, 87, 81, 81),
            actions: [
              staffstep == 4
                  ? InkWell(
                      child: const Icon(Icons.history_edu_outlined),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => BarberHistoryScreen()))))
                  : Container()
            ],
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFFFDF9EE),
          body: Column(
            children: [
              Expanded(
                flex: 10,
                child: staffstep == 1
                    ? displayCity()
                    : staffstep == 2
                        ? displaySalon(citywatch.name)
                        : staffstep == 3
                            ? dispalyBarber(context, salonwatch)
                            : staffstep == 4
                                ? displaySlot(context, barberwatch)
                                : Container(),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: staffstep == 1
                            ? null
                            : () =>
                                ref.read(staffStep.state).state = staffstep - 1,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              letterSpacing: 2,
                            )),
                        child: const Text('previous'),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (staffstep == 1 &&
                                    ref.read(selectedCity.state).state.name ==
                                        '') ||
                                (staffstep == 2 &&
                                    ref.read(selectedSalon.state).state.docId ==
                                        '') ||
                                (staffstep == 3 &&
                                    ref
                                            .read(selectedBarber.state)
                                            .state
                                            .email !=
                                        FirebaseAuth
                                            .instance.currentUser!.email)
                            ? null
                            : staffstep == 5
                                ? null
                                : () => ref.read(staffStep.state).state =
                                    staffstep + 1,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              letterSpacing: 2,
                            )),
                        child: const Text('next'),
                      ),
                    )
                  ],
                ),
              ))
            ],
          )),
    );
  }
}
