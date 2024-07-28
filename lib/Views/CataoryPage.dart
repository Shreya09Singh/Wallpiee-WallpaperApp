import 'package:flutter/material.dart';
import 'package:wallpiie/Views/SearchScreen.dart';

class Cataorypage extends StatefulWidget {
  const Cataorypage({super.key});

  @override
  State<Cataorypage> createState() => _CataorypageState();
}

class _CataorypageState extends State<Cataorypage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Cataorypage'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SearchScreen()));
                },
                icon: Icon(Icons.search))
          ],
        ),
        body: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: height * .24,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
          ),
        ));
  }
}
