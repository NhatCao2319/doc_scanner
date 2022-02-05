import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/screens/apps/image_to_text.dart';
import 'package:document_scanner_app/screens/apps/qr_generate_screen.dart';
import 'package:document_scanner_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ApplicationScreen extends StatefulWidget {
  static const routeName = '/AppScreen';
  const ApplicationScreen({Key? key}) : super(key: key);

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  String finalText = ' ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildAppbar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: const ImageToTextScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: GFCard(
                  boxFit: BoxFit.cover,
                  elevation: 5,
                  titlePosition: GFPosition.end,
                  image: Image.asset(
                    'assets/images/img2text2.png',
                    height: MediaQuery.of(context).size.height * 0.22,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  showImage: true,
                  content: Text(
                    'Convert your image to text',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: const QrGenerateScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: GFCard(
                  boxFit: BoxFit.cover,
                  elevation: 5,
                  titlePosition: GFPosition.end,
                  image: Image.asset(
                    'assets/images/barcode_scan.jpeg',
                    height: MediaQuery.of(context).size.height * 0.22,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  showImage: true,
                  content: Text(
                    'Scan vs generate your QR code',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CustomAppbar buildAppbar(BuildContext context) {
    return CustomAppbar(
      title: "Applications",
      color: Colors.purple.shade300,
      actions: const [],
    );
  }
}
