import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const List<ColorPickModel> COLORS_LIST = [
  ColorPickModel(Colors.black, ColorWidget(color: Colors.black)),
  ColorPickModel(Colors.red, ColorWidget(color: Colors.red)),
  ColorPickModel(Colors.green, ColorWidget(color: Colors.green)),
  ColorPickModel(Colors.yellow, ColorWidget(color: Colors.yellow)),
  ColorPickModel(Colors.orange, ColorWidget(color: Colors.orange)),
  ColorPickModel(Colors.blue, ColorWidget(color: Colors.blue)),
  ColorPickModel(Colors.white, ColorWidget(color: Colors.white)),
  ColorPickModel(Colors.brown, ColorWidget(color: Colors.brown)),
  ColorPickModel(Colors.pink, ColorWidget(color: Colors.pink)),
  ColorPickModel(Colors.purple, ColorWidget(color: Colors.purple)),
];

class ColorPickModel {
  final Color color;
  final ColorWidget widget;

  const ColorPickModel(this.color, this.widget);
}

class ColorWidget extends StatelessWidget {
  final Color color;
  const ColorWidget({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        height: 30.h,
        width: 30.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: color,
          border: Border.all(
            width: 3,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
