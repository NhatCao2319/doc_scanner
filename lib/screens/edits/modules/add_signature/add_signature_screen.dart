import 'dart:io';
import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/const/photo_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_cropper/image_cropper.dart' as cr;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class AddSignatureScreen extends StatefulWidget {
  final String imageFilePath;
  const AddSignatureScreen({Key? key, required this.imageFilePath})
      : super(key: key);

  @override
  _AddSignatureScreenState createState() => _AddSignatureScreenState();
}

class _AddSignatureScreenState extends State<AddSignatureScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  final ImagePicker _picker = ImagePicker();
  double rotateNum = 0;
  int currentFilter = 0;
  double currentOpacityValue = 0.5;
  late String imgFilePath;
  String? imgWithSigPath = '';

  @override
  void initState() {
    super.initState();
    imgFilePath = widget.imageFilePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Flexible(
                flex: 8,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height * 0.65,
                              child: Image.file(
                                File(imgFilePath),
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
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
                            width: MediaQuery.of(context).size.height * 0.9,
                            child: Center(
                              child: Opacity(
                                opacity: currentOpacityValue,
                                child: RotationTransition(
                                  turns:
                                      AlwaysStoppedAnimation(rotateNum / 360),
                                  child: imgWithSigPath!.isEmpty
                                      ? SizedBox(
                                          width: 300.h,
                                          height: 200.h,
                                        )
                                      : GestureDetector(
                                          onLongPress: () {
                                            setState(() {
                                              imgWithSigPath = '';
                                            });
                                          },
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.matrix(
                                                FILTERS[currentFilter]
                                                    .filterMatrix),
                                            child: Image.file(
                                              File(imgWithSigPath!),
                                              fit: BoxFit.contain,
                                              width: 100.w,
                                              height: 100.w,
                                            ),
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
                        height: 45.h,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 40.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentFilter = index;
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
                            );
                          },
                          itemCount: FILTERS.length,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.rotate_right_sharp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 22.h,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
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
                              Row(
                                children: [
                                  const Icon(
                                    Icons.opacity_outlined,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 22.h,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Slider.adaptive(
                                        thumbColor: Colors.pink,
                                        activeColor: Colors.pink.shade200,
                                        inactiveColor: Colors.grey.shade300,
                                        value: currentOpacityValue,
                                        min: 0,
                                        max: 1,
                                        onChanged: (newValue) {
                                          setState(() {
                                            currentOpacityValue = newValue;
                                          });
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 32.h,
                            child: GFButton(
                              onPressed: () async {
                                await showOptionPickImage(context);
                              },
                              elevation: 5.0,
                              text: "Add Signature",
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              color: Colors.pink.shade200,
                              borderShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
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
                      final photoo =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (photoo != null) {
                        cropped = await cr.ImageCropper.cropImage(
                          sourcePath: photoo.path,
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
                          imgWithSigPath = cropped!.path;
                        });
                      } else {
                        return;
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
                      File? cropped;
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);
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
                          imgWithSigPath = cropped!.path;
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
        "Add Signature",
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
              final result = screenshotController.captureAndSave(
                  '${appStorage.path}/images/',
                  fileName: fileName);
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

  static AndroidUiSettings androidUiSettings() => const AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
      );

  static IOSUiSettings iosUiSettings() => const IOSUiSettings(
        aspectRatioLockEnabled: false,
      );
}
