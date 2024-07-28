import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpiie/Widgets/BottomNavigationbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0;
  void changeOpacity() {
    setState(() => opacity = opacity == 0 ? 1.0 : 0.0);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      changeOpacity();
    });
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => BottomNavigationbar()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 239, 239),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: opacity,
              duration: Duration(seconds: 2),
              child: SizedBox(
                  height: 160,
                  width: 170,
                  child: Image.asset('assets/iconImage/wallpie.jpg')),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Wallpie',
            style: GoogleFonts.tiltWarp(
                fontWeight: FontWeight.bold,
                fontSize: 42,
                letterSpacing: 1.5,
                color: Colors.black),
          )
        ],
      ),
    );
  }
}
