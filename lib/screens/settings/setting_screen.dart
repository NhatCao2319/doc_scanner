import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/widgets/custom_appbar.dart';

import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/SettingScreen';
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        title: "Settings",
        color: Colors.green.shade200,
        actions: const [],
      ),
    );
  }
}
