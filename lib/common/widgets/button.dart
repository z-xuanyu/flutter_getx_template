import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../values/colors.dart';

/// 扁平圆角按钮
Widget btnFlatButtonWidget({
  required VoidCallback onPressed,
  double width = 140,
  double height = 44,
  Color gbColor = AppColors.primaryElement,
  String title = "button",
  Color fontColor = AppColors.primaryElementText,
  double fontSize = 18,
  String fontName = "Montserrat",
  FontWeight fontWeight = FontWeight.w400,
}) {
  return SizedBox(
    width: width.w,
    height: height.h,
    child: TextButton(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16.sp)),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused) &&
              !states.contains(WidgetState.pressed)) {
            return Colors.blue;
          } else if (states.contains(WidgetState.pressed)) {
            return Colors.deepPurple;
          }
          return fontColor;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.blue[200];
          }
          return gbColor;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(6.w)),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: fontColor,
          fontFamily: fontName,
          fontWeight: fontWeight,
          fontSize: fontSize.sp,
          height: 1,
        ),
      ),
    ),
  );
}

/// 第三方按钮
// Widget btnFlatButtonBorderOnlyWidget({
//   required VoidCallback onPressed,
//   double width = 88,
//   double height = 44,
//   required String iconFileName,
// }) {
//   return Container(
//     width: width.w,
//     height: height.h,
//     child: TextButton(
//       child: Image.asset("assets/images/icons-$iconFileName.png"),
//       onPressed: onPressed,
//     ),
//   );
// }
