import 'package:document_scanner_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: const MainScreen(),
      title: Text(
        'Make your life better',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: Colors.pink,
        ),
      ),
      loadingText: Text(
        'Loading...',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      gradientBackground: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.blue.shade600,
          ],
          stops: const [
            0.475,
            1.0,
          ]),
      image: Image.asset('assets/images/logo.png'),
      photoSize: 160.sp,
      backgroundColor: Colors.white,
      loaderColor: Colors.pink,
    );
  }
}
