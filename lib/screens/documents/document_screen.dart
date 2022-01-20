import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/widgets/custom_appbar.dart';
import 'package:document_scanner_app/screens/searchs/search_screen.dart';
import 'package:document_scanner_app/widgets/document_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class DocumentScreen extends StatefulWidget {
  static const routeName = '/DocumentScreen';
  const DocumentScreen({Key? key}) : super(key: key);
  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
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
              Consumer<DocumentProvider>(
                builder: (context, value, child) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65.h,
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
    );
  }

  CustomAppbar buildAppbar(BuildContext context) {
    return CustomAppbar(
      title: "Documents",
      color: Colors.pink.shade200,
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
