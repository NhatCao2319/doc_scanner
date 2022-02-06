import 'package:document_scanner_app/Models/doc_page.dart';
import 'package:document_scanner_app/Models/document.dart';
import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/screens/combines/combine_screen.dart';
import 'package:document_scanner_app/screens/pdfview/pdf_view_screen.dart';
import 'package:document_scanner_app/widgets/document_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<DocPage> list = [];
  List<Document> queryList = [];
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.loose,
        children: [
          buildFloatingSearchBar(docs),
        ],
      ),
    );
  }

  Future<void> showOptionsDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
            titlePadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
            title: const Center(
                child: Text(
              'Open with',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black54),
            )),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
            insetPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GFButton(
                    size: GFSize.SMALL,
                    elevation: 3.0,
                    onPressed: () {
                      Navigator.pop(context);
                      pushNewScreen(
                        context,
                        screen: PdfViewScreen(document: queryList[index]),
                        withNavBar: false,
                      );
                    },
                    text: "View",
                    color: Colors.pink.shade300,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GFButton(
                    size: GFSize.SMALL,
                    elevation: 3.0,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CombineScreen(document: queryList[index])));
                    },
                    text: "Edit",
                    color: Colors.pink.shade300,
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget buildFloatingSearchBar(List<Document> list) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      openWidth: 700.w,
      hint: 'Find your documents...',
      scrollPadding: EdgeInsets.only(top: 6.h, bottom: 8.h),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,

      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onFocusChanged: (isFocused) => {
        if (isFocused == true)
          {
            if (queryList.isNotEmpty)
              {queryList.clear()}
            else
              {queryList.addAll(list)}
          }
      },
      onQueryChanged: (query) {
        if (queryList.isNotEmpty) {
          queryList.clear();
        }
        queryList.addAll(list
            .where((item) =>
                item.name!.toLowerCase().contains(query.toLowerCase()))
            .toList());
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        if (queryList.isNotEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Material(
              color: Colors.grey.shade300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 500.h,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 5.h),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showOptionsDialog(context, index);
                          },
                          // child: Container(),
                          child: DocumentItem(
                            docId: queryList[index].id.toString(),
                            imagePath:
                                getFirstPage(queryList[index].id.toString()),
                            title: queryList[index].name!,
                            subtitle:
                                queryList[index].createAt!.toIso8601String(),
                          ),
                        );
                      },
                      itemCount: queryList.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
