import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/screens/apps/image_to_text.dart';
import 'package:document_scanner_app/screens/apps/qr_generate_screen.dart';
import 'package:document_scanner_app/screens/apps/qr_scan_screen.dart';
import 'package:document_scanner_app/screens/combines/combine_screen.dart';
import 'package:document_scanner_app/screens/edits/edit_screen.dart';
import 'package:document_scanner_app/widgets/custom_appbar.dart';
import 'package:document_scanner_app/screens/searchs/search_screen.dart';
import 'package:document_scanner_app/widgets/app_widget.dart';
import 'package:edge_detection/edge_detection.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'document_home_item.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildAppbar(context),
      body: FutureBuilder(
        future: Provider.of<DocumentProvider>(context).getDocs(),
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1.h,
                  width: double.infinity,
                  child: buildAppWidget(context)),
              Consumer<DocumentProvider>(
                builder: (context, value, child) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45.h,
                    child: value.docItems.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 100,
                                color: Colors.blue.shade200,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                'You dont have any document yet !',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return GestureDetector(
                                onTap: () {
                                  pushNewScreen(
                                    context,
                                    screen: CombineScreen(
                                        document: value.docItems[index]),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: DocumentHomeItem(
                                  docId: value.docItems[index].id.toString(),
                                  imagePath: 'assets/images/pdf_icon2.png',
                                  title: value.docItems[index].name!,
                                  subtitle: value.docItems[index].createAt!
                                      .toIso8601String(),
                                ),
                              );
                            },
                            itemCount: value.docItems.length,
                          ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: FloatingActionButton(
              elevation: 4.0,
              backgroundColor: AppColors.floatingButton,
              mini: true,
              child: Icon(
                Icons.add_a_photo_rounded,
                color: Colors.white.withOpacity(0.85),
              ),
              onPressed: () async {
                String? imagePath = await EdgeDetection.detectEdge;
                if (imagePath != null) {
                  pushNewScreen(
                    context,
                    screen: EditScreen(imgPath: imagePath),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                }
              },
              heroTag: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppWidget(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            GestureDetector(
              onTap: () {
                _displayDialog(context);
              },
              child: const AppWidget(
                  icon: Icon(
                    Icons.qr_code_rounded,
                    color: AppColors.appbarIcon,
                  ),
                  title: "QR Scan"),
            ),
            GestureDetector(
              onTap: () {
                pushNewScreen(
                  context,
                  screen: const ImageToTextScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: const AppWidget(
                  icon: Icon(
                    Icons.text_fields_rounded,
                    color: AppColors.appbarIcon,
                  ),
                  title: "Image To Text"),
            ),
          ],
        ),
      ),
    );
  }

  _displayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Options'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                pushNewScreen(
                  context,
                  screen: const QrScanScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Text(
                'Scan Qr code',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: const Divider(
                height: 2,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                pushNewScreen(
                  context,
                  screen: const QrGenerateScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Text(
                'Generate Qr code',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
              ),
            ),
          ],
          elevation: 10,
          //backgroundColor: Colors.green,
        );
      },
    );
  }

  CustomAppbar buildAppbar(BuildContext context) {
    return CustomAppbar(
      title: "Document Scanner",
      color: Colors.blue.shade200,
      actions: [
        IconButton(
          onPressed: () {
            pushNewScreen(
              context,
              screen: const SearchScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          icon: Icon(
            Icons.search,
            size: 20.h,
            color: AppColors.appbarIcon,
          ),
        ),
      ],
    );
  }
}
