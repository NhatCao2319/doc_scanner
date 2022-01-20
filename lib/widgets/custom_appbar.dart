import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final List<IconButton> actions;

  const CustomAppbar({
    Key? key,
    required this.title,
    required this.actions,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.5,
      backgroundColor: color,
      actions: actions,
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.appbarText,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
