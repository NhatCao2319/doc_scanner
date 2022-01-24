import 'package:document_scanner_app/Models/doc_page.dart';
import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/db/document_database.dart';
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
  List<DocPage> list = [];

  void getAllPages() {
    final l = Provider.of<DocumentProvider>(context).getAllPages();
    l.then((value) => {
          setState(() {
            if (list.isNotEmpty) {
              list.clear();
            }
            list.addAll(value);
          })
        });
  }

  String getFirstPage(String docId) {
    List<DocPage> pages = [];
    for (DocPage page in list) {
      if (page.documentId == docId) {
        pages.add(page);
      }
    }
    if (pages.isNotEmpty) {
      return pages[0].pagePath!;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    getAllPages();
    final docs = Provider.of<DocumentProvider>(context).docItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildAppbar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return DocumentItem(
                  docId: docs[index].id.toString(),
                  imagePath: getFirstPage(docs[index].id.toString()),
                  title: docs[index].name!,
                  subtitle: docs[index].createAt!.toIso8601String(),
                );
              },
              itemCount: docs.length,
            ),
          ),
        ],
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
