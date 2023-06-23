import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/home/home1.dart';
import 'package:flutter_application_2/login/login.dart';
import 'package:flutter_application_2/login/main2.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Screenmain extends StatefulWidget {
  const Screenmain({super.key});

  @override
  State<Screenmain> createState() => _ScreenmainState();
}

class _ScreenmainState extends State<Screenmain> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    color: Colors.red,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('an onMessageOpenedApp');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print('haii');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return (const Center(
              child: CircularProgressIndicator(),
            ));
          } else if (snapshot.hasError) {
            return (const Center(
              child: Text("Something went wrong !"),
            ));
          } else if (snapshot.hasData) {
            print('i have data');
            return const HomeScreen1();
          } else {
            return const Authpage();
          }
        },
      ),
    );
  }
}
