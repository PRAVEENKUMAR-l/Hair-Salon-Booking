// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/booking/book.dart';
import 'package:flutter_application_2/booking/state_management.dart';
import 'package:flutter_application_2/history/history.dart';
import 'package:flutter_application_2/home/banner.dart';
import 'package:flutter_application_2/home/home2.dart';
import 'package:flutter_application_2/home/image_lookbook.dart';
import 'package:flutter_application_2/home/image_maker.dart';
import 'package:flutter_application_2/home/lookbook.dart';
import 'package:flutter_application_2/home/staff_home.dart';
import 'package:flutter_application_2/home/user.dart';
import 'package:flutter_application_2/shop/shop.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen1 extends ConsumerWidget {
  const HomeScreen1({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<DocumentSnapshot> fetchUserData() async {
     return await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data found'));
                  } else {
                    UserData userData = UserData.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>);
                    ref.read(selectedName.state).state.firstname =
                        userData.firstname;
                    ref.read(selectedName.state).state.lastname =
                        userData.lastname;
                    ref.read(selectedName.state).state.age = userData.age;
                    ref.read(selectedName.state).state.email = userData.email;
                    ref.read(selectedName.state).state.isStaff =
                        userData.isStaff;

                    return Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 87, 81, 81)),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.black,
                            maxRadius: 24,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${ref.read(selectedName.state).state.firstname}'
                                  " "
                                  '${ref.read(selectedName.state).state.lastname}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ref.read(selectedName.state).state.email,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                          ref.read(selectedName.state).state.isStaff
                              ? IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                StaffScreeen())));
                                  },
                                  icon: const Icon(Icons.admin_panel_settings))
                              : GestureDetector(
                                  onTap: () {
                                    FirebaseAuth.instance.signOut();
                                  },
                                  child: const Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                )
                        ],
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ref.read(selectedName.state).state.isStaff
                        ? Cards(
                            icon1: Icons.book_online,
                            status: 'Signout',
                            ontaped: () {
                              FirebaseAuth.instance.signOut();
                            })
                        : Cards(
                            icon1: Icons.book_online,
                            status: 'booking',
                            ontaped: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => BookScreen())));
                            }),
                    Cards(
                      icon1: Icons.shopping_bag,
                      status: 'shop',
                      ontaped: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const Shopscreen())));
                      },
                    ),
                    Cards(
                      icon1: Icons.history,
                      status: 'history',
                      ontaped: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const Historyscreen();
                        }));
                      },
                    )
                  ],
                ),
              ),
              FutureBuilder<List<ImageModel>>(
                future: fetchBannerData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data found'));
                  } else {
                    List<ImageModel> banners = snapshot.data!;

                    return CarouselSlider.builder(
                      itemCount: banners.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Image.network(banners[index].image);
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.5,
                        viewportFraction: 0.8,
                        initialPage: 0,
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: const [
                    Text(
                      'LOOKBOOK',
                      style:
                          TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              ),
              FutureBuilder<List<ImageModellook>>(
                future: fetchLookbookData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data found'));
                  } else {
                    List<ImageModellook> lookbooks = snapshot.data!;

                    return Column(
                        children: lookbooks
                            .map((e) => Container(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(e.image),
                                  ),
                                ))
                            .toList());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
