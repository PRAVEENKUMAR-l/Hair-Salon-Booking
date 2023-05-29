// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/booking/barber_model.dart';
import 'package:flutter_application_2/booking/cities_model.dart';
import 'package:flutter_application_2/booking/getcities.dart';
import 'package:flutter_application_2/booking/salon_model.dart';
import 'package:flutter_application_2/booking/state_management.dart';
import 'package:flutter_application_2/booking/submit_model.dart';
import 'package:flutter_application_2/booking/util.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class BookScreen extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  BookScreen({super.key});
  late Future<DocumentSnapshot> userDataFuture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var step = ref.watch(currentstep.state).state;
    var citywatch = ref.watch(selectedCity.state).state;
    var salonwatch = ref.watch(selectedSalon.state).state;
    var barberwatch = ref.watch(selectedBarber.state).state;
    var dateWatch = ref.watch(selectedDate.state).state;
    var timewatch = ref.watch(selectedTime.state).state;
    var timeslotwatch = ref.watch(selectedTimeSlot.state).state;

    confirmbooking(BuildContext context) {
      var hour = ref.read(selectedTime.state).state.length <= 10
          ? int.parse(ref
              .read(selectedTime.state)
              .state
              .toString()
              .split(':')[0]
              .substring(0, 1))
          : int.parse(ref
              .read(selectedTime.state)
              .state
              .toString()
              .split(':')[0]
              .substring(0, 2));
      var minutes = ref.read(selectedTime.state).state.length <= 10
          ? int.parse(ref
              .read(selectedTime.state)
              .state
              .toString()
              .split(':')[1]
              .substring(0, 1))
          : int.parse(ref
              .read(selectedTime.state)
              .state
              .toString()
              .split(':')[1]
              .substring(0, 2));
      var timestamp = DateTime(
              ref.read(selectedDate.state).state.year,
              ref.read(selectedDate.state).state.month,
              ref.read(selectedDate.state).state.day,
              hour,
              minutes)
          .millisecondsSinceEpoch;

      var bookingModel = BookingModel(
          Barberid: ref.read(selectedBarber.state).state.docId,
          BarberName: ref.read(selectedBarber.state).state.name,
          CityBook: ref.read(selectedCity.state).state.name,
          Username: ref.read(selectedName.state).state.firstname,
          Email: ref.read(selectedName.state).state.email,
          customerId: FirebaseAuth.instance.currentUser!.uid,
          SaloonAddress: ref.read(selectedSalon.state).state.address,
          SaloonId: ref.read(selectedSalon.state).state.docId,
          SaloonName: ref.read(selectedSalon.state).state.name,
          time:
              '${ref.read(selectedTime.state).state}-${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}',
          done: false,
          totalPrice: 0.0,
          services: '',
          slot: ref.read(selectedTimeSlot.state).state,
          timestamp: timestamp);
      var batch = FirebaseFirestore.instance.batch();
      DocumentReference barberBooking = ref
          .read(selectedBarber.state)
          .state
          .reference
          .collection(DateFormat('dd_MM_yyyy')
              .format(ref.read(selectedDate.state).state))
          .doc(ref.read(selectedTimeSlot.state).state.toString());

      DocumentReference userBooking = FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('Booking_${FirebaseAuth.instance.currentUser!.uid}')
          .doc(
              '${ref.read(selectedBarber.state).state.docId}_${DateFormat('dd_MM_yyyy').format(ref.read(selectedDate.state).state)}_${ref.read(selectedTimeSlot.state).state}');

      batch.set(barberBooking, bookingModel.toJson());
      batch.set(userBooking, bookingModel.toJson());
      batch.commit().then((value) {
        print({ref.read(selectedTimeSlot.state).state});
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Booking successfull')));
        ref.read(selectedDate.state).state = DateTime.now();
        ref.read(selectedBarber.state).state = BarberModel();
        ref.read(selectedCity.state).state = Citymodel(name: '');
        ref.read(selectedSalon.state).state = Salonmodel();
        ref.read(currentstep.state).state = 1;
        ref.read(selectedTime.state).state = '';
        ref.read(selectedTimeSlot.state).state = -1;
      });
    }

    displayconfirmbooking(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                  ))),
          Expanded(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Thank you for Booking our Service !'.toUpperCase(),
                    style: GoogleFonts.robotoFlex(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Booking information'.toUpperCase(),
                    style: GoogleFonts.radioCanada(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${ref.read(selectedTime.state).state}-${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}'
                            .toUpperCase(),
                        style: GoogleFonts.radioCanada(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person_add),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        ref.read(selectedBarber.state).state.name.toUpperCase(),
                        style: GoogleFonts.radioCanada(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.home),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        ref.read(selectedSalon.state).state.name.toUpperCase(),
                        style: GoogleFonts.radioCanada(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_city),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        ref
                            .read(selectedSalon.state)
                            .state
                            .address
                            .toUpperCase(),
                        style: GoogleFonts.radioCanada(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.verified_user),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        ref
                            .read(selectedName.state)
                            .state
                            .firstname
                            .toUpperCase(),
                        style: GoogleFonts.radioCanada(),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () => confirmbooking(context),
                      child: const Text('confirm'))
                ],
              ),
            )),
          ))
        ],
      );
    }

    displayTimeslot(BuildContext context, BarberModel barberModel) {
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
                int maxtimeslot = snapshot.data as int;

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
                              onTap: maxtimeslot > index ||
                                      listTimeSlot.contains(index)
                                  ? null
                                  : () {
                                      print(maxtimeslot);
                                      ref.read(selectedTime.state).state =
                                          TIME_SLOT.elementAt(index);
                                      ref.read(selectedTimeSlot.state).state =
                                          index;
                                    },
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
                              leading: const Icon(Icons.home_outlined),
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

    displayBarber(Salonmodel salonmodel) {
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
                          onTap: () => ref.read(selectedBarber.state).state =
                              barber[index],
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
        child: Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFDF9EE),
      body: Column(
        children: [
          NumberStepper(
            activeStep: step - 1,
            direction: Axis.horizontal,
            enableNextPreviousButtons: false,
            steppingEnabled: false,
            numbers: const [1, 2, 3, 4, 5],
            stepColor: Colors.black,
            activeStepColor: Colors.grey,
            numberStyle: const TextStyle(color: Colors.white),
          ),
          Expanded(
            flex: 10,
            child: step == 1
                ? displayCity()
                : step == 2
                    ? displaySalon(citywatch.name)
                    : step == 3
                        ? displayBarber(salonwatch)
                        : step == 4
                            ? displayTimeslot(context, barberwatch)
                            : step == 5
                                ? displayconfirmbooking(context)
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
                    onPressed: step == 1
                        ? null
                        : () => ref.read(currentstep.state).state = step - 1,
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
                    onPressed: (step == 1 &&
                                ref.read(selectedCity.state).state.name ==
                                    '') ||
                            (step == 2 &&
                                ref
                                        .read(selectedSalon.state)
                                        .state
                                        .docId ==
                                    '') ||
                            (step == 3 &&
                                ref.read(selectedBarber.state).state.docId ==
                                    '') ||
                            (step == 4 &&
                                ref.read(selectedTimeSlot.state).state == -1)
                        ? null
                        : step == 5
                            ? null
                            : () =>
                                ref.read(currentstep.state).state = step + 1,
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
      ),
    ));
  }
}
