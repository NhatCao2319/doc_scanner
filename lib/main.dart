import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: () => ChangeNotifierProvider.value(
        value: DocumentProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Document Scanner',
          theme: ThemeData(
            primaryColor: Colors.white,
          ),
          home: const MainScreen(),
        ),
      ),
    );
  }
}
