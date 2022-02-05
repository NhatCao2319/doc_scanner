import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrGenerateScreen extends StatefulWidget {
  const QrGenerateScreen({Key? key}) : super(key: key);

  @override
  _QrGenerateScreenState createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController _dataTextController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? qrCodeFile;
  String? dataText;
  String? wifiData;
  bool isWifiMode = false;
  String? qrPath;

  @override
  void dispose() {
    _dataTextController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      //appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.blue,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple,
              Colors.pink.shade500,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60.h,
                ),
                Screenshot(
                  controller: screenshotController,
                  child: BarcodeWidget(
                    data: isWifiMode ? wifiData ?? '' : dataText ?? '',
                    barcode: Barcode.qrCode(),
                    width: 200.w,
                    height: 200.w,
                    padding: EdgeInsets.all(20.w),
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                isWifiMode ? buildWifiForm() : buildDataTextField(),
                SizedBox(
                  height: 320.h,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: buildButtonChangeMode(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Padding buildDataTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        controller: _dataTextController,
        decoration: InputDecoration(
          fillColor: Colors.white70,
          filled: true,
          hintText: "Write your data here...",
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.7),
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.7),
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                dataText = _dataTextController.text;
              });
              createQrFile();
            },
            icon: Icon(
              Icons.check,
              color: Colors.green,
              size: 30.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWifiForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              fillColor: Colors.white70,
              filled: true,
              hintText: "Your wifi name ...",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.7),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.7),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              fillColor: Colors.white70,
              filled: true,
              hintText: "Your wifi password ...",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.7),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.7),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    String data = MeCard.wifi(
                      ssid: _usernameController.text,
                      password: _passwordController.text,
                    ).toString();
                    wifiData = data;
                  });
                  createQrFile();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 30.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButtonChangeMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: GFIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            size: GFSize.MEDIUM,
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
            color: Colors.transparent,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GFButton(
              onPressed: () {
                setState(() {
                  isWifiMode = !isWifiMode;
                  qrPath = '';
                });
              },
              position: GFPosition.start,
              text: isWifiMode ? "QR CODE" : "WIFI",
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 15.sp),
              color: Colors.transparent,
              shape: GFButtonShape.square,
              size: GFSize.MEDIUM,
            ),
            GFIconButton(
              onPressed: () {
                _showDialogDownloadOption(context);
              },
              size: GFSize.SMALL,
              icon: const Icon(Icons.download_rounded,
                  color: Colors.white, size: 27),
              color: Colors.transparent,
            ),
          ],
        ),
      ],
    );
  }

  void showToast(String text) {
    GFToast.showToast(
      text,
      context,
      toastBorderRadius: 18.r,
      textStyle: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
      toastDuration: 1,
      toastPosition: GFToastPosition.BOTTOM,
    );
  }

  createQrFile() async {
    final appStorage = await getApplicationDocumentsDirectory();
    String fileName =
        'QR_${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';
    final result = screenshotController.captureAndSave('${appStorage.path}/qr/',
        fileName: fileName);
    await result.then((value) => {
          setState(() {
            qrPath = value!;
          }),
        });
  }

  _showDialogDownloadOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Options'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                if (qrPath == null || qrPath == '') {
                  showToast('Create your QR code first');
                } else {
                  GallerySaver.saveImage(qrPath!);
                  showToast('Saved');
                }
              },
              child: Text(
                'Save to gallery',
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
                List<String> list = [];
                if (qrPath == null || qrPath == '') {
                  showToast('Create your QR code first');
                } else {
                  list.add(qrPath!);
                  Share.shareFiles(list, text: 'Share your QR code');
                }
              },
              child: Text(
                'Share your QR code',
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
}
