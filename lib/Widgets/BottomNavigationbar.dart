import 'package:flutter/material.dart';

import 'package:wallpiie/Model/PhotoModell.dart';
import 'package:wallpiie/Views/Catagoriescreen.dart';
import 'package:wallpiie/Views/SearchScreen.dart';
import 'package:wallpiie/Views/home.dart';

class BottomNavigationbar extends StatelessWidget {
  final List<PhotoModell> photos = [];
  BottomNavigationbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 229, 222, 224),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                  size: 35,
                ),
                text: "Search",
              ),
              Tab(
                icon: Icon(Icons.category_rounded),
                text: "Catagory",
              )
            ],
            unselectedLabelColor: Color(0xFF999999),
            labelColor: Colors.brown.shade900,
            indicatorColor: Colors.transparent,
          ),
          body: TabBarView(
              children: [HomeScreen(), SearchScreen(), Catagoriescreen()]),
        ));
  }
}
