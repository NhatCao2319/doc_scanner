import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppWidget extends StatelessWidget {
  final Icon icon;
  final String title;
  const AppWidget({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.h),
      child: Container(
        width: 70.w,
        height: 70.w,
        decoration: BoxDecoration(
          border: Border.all(width: 0.4, color: Colors.blue),
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              spreadRadius: 0.2,
              blurRadius: 0.5,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: SizedBox(
                  height: 25.h,
                  child: Text(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.appbarText,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
