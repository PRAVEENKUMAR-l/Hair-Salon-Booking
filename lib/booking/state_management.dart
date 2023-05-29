import 'package:flutter_application_2/booking/barber_model.dart';
import 'package:flutter_application_2/booking/cities_model.dart';
import 'package:flutter_application_2/booking/salon_model.dart';
import 'package:flutter_application_2/booking/submit_model.dart';
import 'package:flutter_application_2/home/user.dart';
import 'package:flutter_application_2/staff/service_model.dart';
import 'package:riverpod/riverpod.dart';

final currentstep = StateProvider<int>((ref) => 1);
final selectedSalon = StateProvider((ref) => Salonmodel());
final selectedCity = StateProvider((ref) => Citymodel(name: ''));
final selectedBarber = StateProvider((ref) => BarberModel());
final selectedDate = StateProvider((ref) => DateTime.now());
final selectedTimeSlot = StateProvider((ref) => -1);
final selectedTime = StateProvider((ref) => '');
final selectedName = StateProvider((ref) => UserData(
      firstname: '',
      age: 0,
      email: '',
      lastname: '',
      isStaff: false,
    ));
final deleteFlag = StateProvider((ref) => false);
final staffStep = StateProvider((ref) => 1);
final selectedBooking = StateProvider((ref) => BookingModel(
    Barberid: '',
    BarberName: '',
    CityBook: '',
    Username: '',
    Email: '',
    SaloonAddress: '',
    SaloonId: '',
    SaloonName: '',
    customerId: '',
    time: '',
    services: '',
    totalPrice: 0.0,
    done: false,
    slot: 0,
    timestamp: 0));
final selectedService =
    StateProvider((ref) => List<ServiceModel>.empty(growable: true));
final barberHistoryDate = StateProvider((ref) => DateTime.now());
