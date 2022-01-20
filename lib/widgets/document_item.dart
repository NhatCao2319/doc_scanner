import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/widgets/custom_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DocumentItem extends StatelessWidget {
  final String docId;
  final String title;
  final String subtitle;
  final String imagePath;
  const DocumentItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.docId,
  }) : super(key: key);

  String getDateTime(String createAt) {
    final date = DateTime.parse(createAt);
    final formatDate = DateFormat("dd-MM-yyyy hh:mm:ss").format(date);
    return formatDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSlidable(
      docId: docId,
      widget: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 16.w),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.grey.shade300),
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r)),
          height: 80.h,
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          child: Row(
            children: [
              SizedBox(
                height: 75.w,
                width: 75.w,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      print("rename");
                      Provider.of<DocumentProvider>(context, listen: false)
                          .renameDoc(
                        int.parse(docId),
                        DateTime.now().toString(),
                      );
                    },
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.appbarText,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    getDateTime(subtitle),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
