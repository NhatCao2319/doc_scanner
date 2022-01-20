import 'package:document_scanner_app/Models/document.dart';
import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/screens/edits/edit_screen.dart';
import 'package:document_scanner_app/widgets/custom_appbar.dart';
import 'package:document_scanner_app/screens/searchs/search_screen.dart';
import 'package:document_scanner_app/widgets/app_widget.dart';
import 'package:document_scanner_app/widgets/document_item.dart';
import 'package:edge_detection/edge_detection.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Document> docs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildAppbar(context),
      body: FutureBuilder(
        future: Provider.of<DocumentProvider>(context, listen: true).getDocs(),
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
                    height: MediaQuery.of(context).size.height * 0.55.h,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return DocumentItem(
                          docId: value.docItems[index].id.toString(),
                          imagePath: 'assets/images/jisoo.jpg',
                          title: value.docItems[index].name!,
                          subtitle:
                              value.docItems[index].createAt!.toIso8601String(),
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
          FloatingActionButton(
            elevation: 1.0,
            backgroundColor: AppColors.floatingButton,
            mini: true,
            child: const Icon(Icons.photo_library_rounded),
            onPressed: () async {
              String? imagePath = await EdgeDetection.detectEdge;
              pushNewScreen(
                context,
                screen: EditScreen(imgPath: imagePath!),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            heroTag: null,
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
              onTap: () async {
                Provider.of<DocumentProvider>(context, listen: false).createDoc(
                  "Doc 2",
                  DateTime.now(),
                );
              },
              child: const AppWidget(
                  icon: Icon(
                    Icons.qr_code_rounded,
                    color: AppColors.appbarIcon,
                  ),
                  title: "QR Scan"),
            ),
            const AppWidget(
                icon: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.appbarIcon,
                ),
                title: "Pdf Tools"),
            const AppWidget(
                icon: Icon(
                  Icons.text_fields_rounded,
                  color: AppColors.appbarIcon,
                ),
                title: "Image To Text"),
          ],
        ),
      ),
    );
  }

  CustomAppbar buildAppbar(BuildContext context) {
    return CustomAppbar(
      title: "Document Scanner",
      color: Colors.blue.shade200,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.document_scanner_outlined,
            size: 20.h,
            color: AppColors.appbarIcon,
          ),
        ),
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
