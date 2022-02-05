import 'package:document_scanner_app/Models/doc_page.dart';
import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/screens/pdfview/pdf_view_screen.dart';
import 'package:document_scanner_app/widgets/custom_appbar.dart';
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
          SizedBox(
            height: 10.h,
          ),
          docs.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: PdfViewScreen(document: docs[index]),
                            withNavBar: false,
                          );
                        },
                        child: DocumentItem(
                          docId: docs[index].id.toString(),
                          imagePath: getFirstPage(docs[index].id.toString()),
                          title: docs[index].name!,
                          subtitle: docs[index].createAt!.toIso8601String(),
                        ),
                      );
                    },
                    itemCount: docs.length,
                  ),
                )
              : SizedBox(
                  height: 400.h,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 100,
                        color: Colors.pink.shade100,
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
      actions: const [],
    );
  }
}
