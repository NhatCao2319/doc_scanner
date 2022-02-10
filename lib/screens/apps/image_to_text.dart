import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart' as cr;

import 'firebase_helper/firebase_helper.dart';

class ImageToTextScreen extends StatefulWidget {
  const ImageToTextScreen({Key? key}) : super(key: key);

  @override
  _ImageToTextScreenState createState() => _ImageToTextScreenState();
}

class _ImageToTextScreenState extends State<ImageToTextScreen> {
  final ImagePicker _picker = ImagePicker();
  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  final textDetector = GoogleMlKit.vision.textDetector();
  String? imgFilePath;

  String? finalText = '';

  @override
  void dispose() {
    textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade100.withOpacity(0.9),
                Colors.white,
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.475,
                child: imgFilePath != null
                    ? Image.file(
                        File(imgFilePath!),
                        width: double.infinity,
                        fit: BoxFit.contain,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 80,
                            color: Colors.black87.withOpacity(0.6),
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                          Text(
                            'No Image Selected',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GFButton(
                      onPressed: () async {
                        await showOptionPickImage(context);
                      },
                      elevation: 3.0,
                      text: "Pick image",
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      color: Colors.purple.shade200.withOpacity(0.9),
                      borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0.r)),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GFButton(
                      onPressed: () async {
                        if (imgFilePath != null) {
                          final text =
                              await FirebaseMLApi.recogniseText((imgFilePath!));
                          setState(() {
                            finalText = text;
                          });
                        } else {
                          showEmptyImageDialog(context);
                        }
                      },
                      elevation: 3.0,
                      text: "Detect",
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      color: Colors.purple.shade200.withOpacity(0.9),
                      borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0.r)),
                    ),
                    SizedBox(
                      width: 24.w,
                    ),
                    GFButton(
                      onPressed: () async {
                        setState(() {
                          imgFilePath = null;
                          finalText = '';
                        });
                      },
                      elevation: 3.0,
                      text: "Clear",
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      color: Colors.red.shade500.withOpacity(0.9),
                      borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0.r)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border:
                                Border.all(width: 1.w, color: Colors.black)),
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Center(
                          child: SelectableText(
                            finalText!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: IconButton(
                        icon: const Icon(Icons.copy, color: Colors.black),
                        color: Colors.grey[200],
                        onPressed: () {
                          copyToClipboard();
                        },
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

  void copyToClipboard() {
    if (finalText!.trim() != '') {
      FlutterClipboard.copy(finalText!);
      showToastCopySuccess();
    }
  }

  Future<void> showOptionPickImage(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Container(
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      File? cropped;
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (photo != null) {
                        cropped = await cr.ImageCropper.cropImage(
                          sourcePath: photo.path,
                          compressQuality: 100,
                          maxWidth: 700,
                          maxHeight: 700,
                          compressFormat: cr.ImageCompressFormat.jpg,
                          iosUiSettings: iosUiSettings(),
                          androidUiSettings: androidUiSettings(),
                        );
                      }

                      Navigator.pop(context);
                      if (cropped != null) {
                        setState(() {
                          imgFilePath = cropped!.path;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.photo_library_rounded,
                          color: Colors.grey,
                          size: 28,
                        ),
                        SizedBox(width: 20.w),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            'Gallery',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.appbarText.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);
                      File? cropped = await cr.ImageCropper.cropImage(
                        sourcePath: photo!.path,
                        compressQuality: 100,
                        maxWidth: 700,
                        maxHeight: 700,
                        compressFormat: cr.ImageCompressFormat.jpg,
                        iosUiSettings: iosUiSettings(),
                        androidUiSettings: androidUiSettings(),
                      );
                      Navigator.pop(context);
                      if (cropped != null) {
                        setState(() {
                          imgFilePath = cropped.path;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.photo_camera,
                          color: Colors.grey,
                          size: 28,
                        ),
                        SizedBox(width: 20.w),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            'Camera',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.appbarText.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static AndroidUiSettings androidUiSettings() => const AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
      );

  static IOSUiSettings iosUiSettings() => const IOSUiSettings(
        aspectRatioLockEnabled: false,
      );
  Future<void> showEmptyImageDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: EdgeInsets.symmetric(horizontal: 20.w),
            title: const Text('Empty Image'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: const Text('Please select an image first'),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GFButton(
                    elevation: 3.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: "OK",
                    color: Colors.purple.shade300,
                  ),
                ],
              ),
            ],
          );
        });
  }

  void showToastCopySuccess() {
    GFToast.showToast(
      'Text Copied',
      context,
      toastBorderRadius: 18.r,
      textStyle: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
      toastDuration: 1,
      toastPosition: GFToastPosition.BOTTOM,
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
        "Image to text",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.blue.shade100,
    );
  }
}
