import 'dart:io';
import 'package:document_scanner_app/screens/edits/const/color_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class AddTextScreen extends StatefulWidget {
  final String imageFilePath;

  const AddTextScreen({Key? key, required this.imageFilePath})
      : super(key: key);
  @override
  _AddTextScreenState createState() => _AddTextScreenState();
}

class _AddTextScreenState extends State<AddTextScreen> {
  final TextEditingController _textFieldController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  late String imgFilePath;
  int currentColor = 0;
  String? valueText;
  double rotateNum = 0;

  @override
  void initState() {
    super.initState();
    imgFilePath = widget.imageFilePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Flexible(
                flex: 8,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Image.file(
                                File(imgFilePath),
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(double.infinity),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: double.infinity,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  _displayTextInputDialog(context);
                                },
                                child: RotationTransition(
                                  turns:
                                      AlwaysStoppedAnimation(rotateNum / 360),
                                  child: Text(
                                    valueText ?? "Tap to change your text",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: COLORS_LIST[currentColor].color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          minScale: 0.5,
                          maxScale: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: SizedBox(
                        width: double.infinity,
                        height: 30.h,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentColor = index;
                                  });
                                },
                                child: COLORS_LIST[index].widget);
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: COLORS_LIST.length,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Text(
                            "Rotate",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Slider.adaptive(
                                thumbColor: Colors.pink,
                                activeColor: Colors.pink.shade200,
                                inactiveColor: Colors.grey.shade300,
                                value: rotateNum,
                                min: 0,
                                max: 360,
                                onChanged: (newValue) {
                                  setState(() {
                                    rotateNum = newValue;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: EdgeInsets.symmetric(horizontal: 20.w),
            title: const Text('Add Text'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    if (value.replaceAll(' ', '') != "") {
                      valueText = value;
                    }
                  });
                },
                controller: _textFieldController,
                decoration: InputDecoration(
                  hintText: "Add your text here",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink.shade200),
                  ),
                  suffixIcon: IconButton(
                    onPressed: _textFieldController.clear,
                    icon: Icon(
                      Icons.clear,
                      color: Colors.pink.shade300,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              GFButton(
                onPressed: () {
                  setState(() {
                    if (_textFieldController.text.replaceAll(' ', '') != "") {
                      valueText = _textFieldController.text;
                    } else {
                      valueText = 'Tap to change your text';
                    }
                  });
                  Navigator.pop(context);
                },
                text: "Ok",
                color: Colors.pink.shade200,
                fullWidthButton: true,
              ),
            ],
          );
        });
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
        "Add Text",
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
              String? imgPath;
              final appStorage = await getApplicationDocumentsDirectory();
              String fileName =
                  DateTime.now().microsecondsSinceEpoch.toString();
              final result = screenshotController
                  .captureAndSave(appStorage.path, fileName: fileName);
              await result.then((value) => {imgPath = value!});
              Navigator.pop(context, imgPath);
            },
            text: "Done",
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            color: Colors.pink.shade200,
            borderShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0.r)),
          ),
        ),
      ],
    );
  }
}
