import 'dart:io';
import 'package:document_scanner_app/Models/document.dart';
import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/const/photo_filter.dart';
import 'package:document_scanner_app/screens/combines/combine_screen.dart';
import 'package:document_scanner_app/screens/edits/modules/add_signature/add_signature_screen.dart';
import 'package:document_scanner_app/screens/edits/modules/add_text/add_text_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class EditScreen extends StatefulWidget {
  final Document? document;
  final String imgPath;
  const EditScreen({Key? key, required this.imgPath, this.document})
      : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  int currentTabSelected = 1;
  int currentFilter = 0;
  Size? imgSize;
  bool isShow = true;
  int _rotateState = 0;
  late String imgFile;

  @override
  void initState() {
    super.initState();
    imgFile = widget.imgPath;
    imgSize = ImageSizeGetter.getSize(FileInput(File(widget.imgPath)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.7,
                color: Colors.transparent,
                child: Screenshot(
                  controller: screenshotController,
                  child: RotatedBox(
                    quarterTurns: _rotateState,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(
                          FILTERS[currentFilter].filterMatrix),
                      child: Image.file(
                        File(imgFile),
                        height: imgSize!.height.toDouble(),
                        width: imgSize!.width.toDouble(),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isShow ? 1 : 0,
                    child: Container(
                      color: Colors.transparent,
                      height: 70.h,
                      width: double.maxFinite,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 6.h),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isShow) {
                                        currentFilter = index;
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    )),
                                    width: 45.w,
                                    height: 50.w,
                                    child: ClipRRect(
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.matrix(
                                            FILTERS[index].filterMatrix),
                                        child: Image.asset(
                                          'assets/images/jisoo.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  FILTERS[index].name,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 9.sp,
                                    letterSpacing: -0.2,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: FILTERS.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 30,
          color: Colors.black54,
        ),
      ),
      title: Text(
        "Edit Document",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0.4,
      backgroundColor: Colors.grey.shade200,
      automaticallyImplyLeading: true,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: GFButton(
            onPressed: () async {
              String imgPath = await ScreenCap();
              setState(() {
                imgFile = imgPath;
              });

              if (widget.document == null) {
                Future<Document> result =
                    Provider.of<DocumentProvider>(context, listen: false)
                        .createDoc("Doc ${DateTime.now()}", DateTime.now());
                result.then((value) {
                  Provider.of<DocumentProvider>(context, listen: false)
                      .createPage(value.id.toString(), imgFile);
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CombineScreen(document: value)));
                  });
                });
              } else {
                Provider.of<DocumentProvider>(context, listen: false)
                    .createPage(widget.document!.id.toString(), imgFile);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CombineScreen(document: widget.document!)));
              }
            },
            text: "Save",
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            color: Colors.pink.shade200,
            borderShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0.r)),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.grey.shade200,
      elevation: 0.0,
      selectedItemColor: Colors.pink.shade200,
      unselectedItemColor: Colors.black45,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.text_fields,
            color: Colors.black45,
          ),
          activeIcon: Icon(
            Icons.text_fields,
            color: Colors.pink.shade300,
          ),
          label: "Text",
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.photo_filter_rounded,
            color: Colors.black45,
          ),
          activeIcon: Icon(
            Icons.photo_filter_rounded,
            color: Colors.pink.shade300,
          ),
          label: "Filter",
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.rotate_left,
            color: Colors.black45,
          ),
          activeIcon: Icon(
            Icons.rotate_left,
            color: Colors.pink.shade300,
          ),
          label: "Rotate",
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.edit,
            color: Colors.black45,
          ),
          activeIcon: Icon(
            Icons.edit,
            color: Colors.pink.shade300,
          ),
          label: "Signature",
        ),
      ],
      onTap: (int index) async {
        setState(() {
          currentTabSelected = index;
        });
        switch (index) {
          case 0:
            String imgPath = await ScreenCap();

            final imgWithAddText = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => AddTextScreen(imageFilePath: imgPath)));

            setState(() {
              imgFile = imgWithAddText ?? imgFile;
              currentFilter = 0;
            });

            isShow = false;
            break;
          case 1:
            setState(() {
              isShow = !isShow;
            });
            break;
          case 2:
            setState(() {
              _rotateState++;
            });
            isShow = false;
            break;
          case 3:
            String imgPath = await ScreenCap();
            final imgWithSignature = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        AddSignatureScreen(imageFilePath: imgPath)));
            setState(() {
              imgFile = imgWithSignature ?? imgFile;
            });
            isShow = false;
            break;
        }
      },
      currentIndex: currentTabSelected,
    );
  }

  Future<String> ScreenCap() async {
    late String imgPath;
    final appStorage = await getApplicationDocumentsDirectory();
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final result = screenshotController.captureAndSave(appStorage.path,
        delay: const Duration(milliseconds: 10), fileName: fileName);
    await result.then((value) => {imgPath = value!});
    return imgPath;
  }
}
