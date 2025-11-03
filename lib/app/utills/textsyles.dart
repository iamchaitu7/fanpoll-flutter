// ignore_for_file: prefer_const_constructors

import 'package:fan_poll/app/utills/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText {
  static TextStyle extraSmall(double size, Color color, {bool isUnderline = false}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w100,
      fontSize: size.sp,
      color: color,
      letterSpacing: 0,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle small(double size, Color color, {bool isUnderline = false}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w200,
      fontSize: size.sp,
      color: color,
      letterSpacing: 0,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle _light(double size, Color color, {bool isUnderline = false}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w300,
      fontSize: size.sp,
      color: color,
      letterSpacing: 0,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle _regular(double size, Color color, {bool isUnderline = false, required double height}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: size.sp,
      color: color,
      letterSpacing: 0,
      decorationColor: AppColor.PrimaryColor,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle _medium(double size, Color color, {bool isUnderline = false}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: size.sp,
      color: color,
      letterSpacing: 0,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle _semiBold(double size, Color color, {bool isUnderline = false}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: size.sp,
      color: color,
      letterSpacing: 0,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  } /*  */

  static TextStyle _bold(double size, Color color, {bool isUnderline = false}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w700,
      fontSize: size.sp,
      color: color,
      letterSpacing: 0,
      decorationColor: const Color.fromARGB(0, 240, 55, 55),
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle bold10(Color color, {bool isUnderline = false}) {
    return _bold(10, color, isUnderline: isUnderline);
  }

  static TextStyle bold11(Color color, {bool isUnderline = false}) {
    return _bold(11, color, isUnderline: isUnderline);
  }

  static TextStyle bold12(Color color, {bool isUnderline = false}) {
    return _bold(12, color, isUnderline: isUnderline);
  }

  static TextStyle bold13(Color color, {bool isUnderline = false}) {
    return _bold(13, color, isUnderline: isUnderline);
  }

  static TextStyle bold14(Color color, {bool isUnderline = false}) {
    return _bold(14, color, isUnderline: isUnderline);
  }

  static TextStyle bold15(Color color, {bool isUnderline = false}) {
    return _bold(15, color, isUnderline: isUnderline);
  }

  static TextStyle bold16(Color color, {bool isUnderline = false}) {
    return _bold(16, color, isUnderline: isUnderline);
  }

  static TextStyle bold17(Color color, {bool isUnderline = false}) {
    return _bold(17, color, isUnderline: isUnderline);
  }

  static TextStyle bold18(Color color, {bool isUnderline = false}) {
    return _bold(18, color, isUnderline: isUnderline);
  }

  static TextStyle bold19(Color color, {bool isUnderline = false}) {
    return _bold(19, color, isUnderline: isUnderline);
  }

  static TextStyle bold20(Color color, {bool isUnderline = false}) {
    return _bold(20, color, isUnderline: isUnderline);
  }

  static TextStyle bold21(Color color, {bool isUnderline = false}) {
    return _bold(21, color, isUnderline: isUnderline);
  }

  static TextStyle bold22(Color color, {bool isUnderline = false}) {
    return _bold(22, color, isUnderline: isUnderline);
  }

  static TextStyle bold23(Color color, {bool isUnderline = false}) {
    return _bold(23, color, isUnderline: isUnderline);
  }

  static TextStyle bold24(Color color, {bool isUnderline = false}) {
    return _bold(24, color, isUnderline: isUnderline);
  }

  static TextStyle bold25(Color color, {bool isUnderline = false}) {
    return _bold(25, color, isUnderline: isUnderline);
  }

  static TextStyle bold26(Color color, {bool isUnderline = false}) {
    return _bold(26, color, isUnderline: isUnderline);
  }

  static TextStyle bold27(Color color, {bool isUnderline = false}) {
    return _bold(27, color, isUnderline: isUnderline);
  }

  static TextStyle bold28(Color color, {bool isUnderline = false}) {
    return _bold(28, color, isUnderline: isUnderline);
  }

  static TextStyle bold29(Color color, {bool isUnderline = false}) {
    return _bold(29, color, isUnderline: isUnderline);
  }

  static TextStyle bold30(Color color, {bool isUnderline = false}) {
    return _bold(30, color, isUnderline: isUnderline);
  }

  static TextStyle bold31(Color color, {bool isUnderline = false}) {
    return _bold(31, color, isUnderline: isUnderline);
  }

  static TextStyle bold32(Color color, {bool isUnderline = false}) {
    return _bold(32, color, isUnderline: isUnderline);
  }

  static TextStyle bold33(Color color, {bool isUnderline = false}) {
    return _bold(33, color, isUnderline: isUnderline);
  }

  static TextStyle bold42(Color color, {bool isUnderline = false}) {
    return _bold(42, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold10(Color color, {bool isUnderline = false}) {
    return _semiBold(10, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold8(Color color, {bool isUnderline = false}) {
    return _semiBold(8, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold7(Color color, {bool isUnderline = false}) {
    return _semiBold(7, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold6(Color color, {bool isUnderline = false}) {
    return _semiBold(7, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold11(Color color, {bool isUnderline = false}) {
    return _semiBold(11, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold12(Color color, {bool isUnderline = false}) {
    return _semiBold(12, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold13(Color color, {bool isUnderline = false}) {
    return _semiBold(13, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold14(Color color, {bool isUnderline = false}) {
    return _semiBold(14, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold15(Color color, {bool isUnderline = false}) {
    return _semiBold(15, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold16(Color color, {bool isUnderline = false}) {
    return _semiBold(16, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold17(Color color, {bool isUnderline = false}) {
    return _semiBold(17, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold18(Color color, {bool isUnderline = false}) {
    return _semiBold(18, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold19(Color color, {bool isUnderline = false}) {
    return _semiBold(19, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold20(Color color, {bool isUnderline = false}) {
    return _semiBold(20, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold21(Color color, {bool isUnderline = false}) {
    return _semiBold(21, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold22(Color color, {bool isUnderline = false}) {
    return _semiBold(22, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold23(Color color, {bool isUnderline = false}) {
    return _semiBold(23, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold24(Color color, {bool isUnderline = false}) {
    return _semiBold(24, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold25(Color color, {bool isUnderline = false}) {
    return _semiBold(25, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold26(Color color, {bool isUnderline = false}) {
    return _semiBold(26, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold27(Color color, {bool isUnderline = false}) {
    return _semiBold(27, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold28(Color color, {bool isUnderline = false}) {
    return _semiBold(28, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold29(Color color, {bool isUnderline = false}) {
    return _semiBold(29, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold30(Color color, {bool isUnderline = false}) {
    return _semiBold(30, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold31(Color color, {bool isUnderline = false}) {
    return _semiBold(31, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold32(Color color, {bool isUnderline = false}) {
    return _semiBold(32, color, isUnderline: isUnderline);
  }

  static TextStyle semiBold40(Color color, {bool isUnderline = false}) {
    return _semiBold(40, color, isUnderline: isUnderline);
  }

  static TextStyle regular9(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(9, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular10(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(10, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular11(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(11, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular12(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(12, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular13(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(13, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular14(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(14, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular15(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(15, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular16(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(16, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular17(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(17, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular18(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(18, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular19(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(19, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular20(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(20, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular21(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(21, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular22(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(22, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular23(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(23, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular24(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(24, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular30(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(30, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle regular32(Color color, {bool isUnderline = false, double height = 1.0}) {
    return _regular(32, color, isUnderline: isUnderline, height: height);
  }

  static TextStyle medium10(Color color, {bool isUnderline = false}) {
    return _medium(10, color, isUnderline: isUnderline);
  }

  static TextStyle medium11(Color color, {bool isUnderline = false}) {
    return _medium(11, color, isUnderline: isUnderline);
  }

  static TextStyle medium12(Color color, {bool isUnderline = false}) {
    return _medium(12, color, isUnderline: isUnderline);
  }

  static TextStyle medium13(Color color, {bool isUnderline = false}) {
    return _medium(13, color, isUnderline: isUnderline);
  }

  static TextStyle medium14(Color color, {bool isUnderline = false}) {
    return _medium(14, color, isUnderline: isUnderline);
  }

  static TextStyle medium15(Color color, {bool isUnderline = false}) {
    return _medium(15, color, isUnderline: isUnderline);
  }

  static TextStyle medium16(Color color, {bool isUnderline = false}) {
    return _medium(16, color, isUnderline: isUnderline);
  }

  static TextStyle medium17(Color color, {bool isUnderline = false}) {
    return _medium(17, color, isUnderline: isUnderline);
  }

  static TextStyle medium18(Color color, {bool isUnderline = false}) {
    return _medium(18, color, isUnderline: isUnderline);
  }

  static TextStyle medium19(Color color, {bool isUnderline = false}) {
    return _medium(19, color, isUnderline: isUnderline);
  }

  static TextStyle medium20(Color color, {bool isUnderline = false}) {
    return _medium(20, color, isUnderline: isUnderline);
  }

  static TextStyle medium21(Color color, {bool isUnderline = false}) {
    return _medium(21, color, isUnderline: isUnderline);
  }

  static TextStyle medium22(Color color, {bool isUnderline = false}) {
    return _medium(22, color, isUnderline: isUnderline);
  }

  static TextStyle medium23(Color color, {bool isUnderline = false}) {
    return _medium(23, color, isUnderline: isUnderline);
  }

  static TextStyle medium24(Color color, {bool isUnderline = false}) {
    return _medium(24, color, isUnderline: isUnderline);
  }

  static TextStyle medium25(Color color, {bool isUnderline = false}) {
    return _medium(25, color, isUnderline: isUnderline);
  }

  static TextStyle medium26(Color color, {bool isUnderline = false}) {
    return _medium(26, color, isUnderline: isUnderline);
  }

  static TextStyle medium27(Color color, {bool isUnderline = false}) {
    return _medium(27, color, isUnderline: isUnderline);
  }

  static TextStyle medium28(Color color, {bool isUnderline = false}) {
    return _medium(28, color, isUnderline: isUnderline);
  }

  static TextStyle medium29(Color color, {bool isUnderline = false}) {
    return _medium(29, color, isUnderline: isUnderline);
  }

  static TextStyle medium30(Color color, {bool isUnderline = false}) {
    return _medium(30, color, isUnderline: isUnderline);
  }

  static TextStyle medium31(Color color, {bool isUnderline = false}) {
    return _medium(31, color, isUnderline: isUnderline);
  }

  static TextStyle medium32(Color color, {bool isUnderline = false}) {
    return _medium(32, color, isUnderline: isUnderline);
  }

  static TextStyle light9(Color color, {bool isUnderline = false}) {
    return _light(9, color, isUnderline: isUnderline);
  }

  static TextStyle light10(Color color, {bool isUnderline = false}) {
    return _light(10, color, isUnderline: isUnderline);
  }

  static TextStyle light11(Color color, {bool isUnderline = false}) {
    return _light(11, color, isUnderline: isUnderline);
  }

  static TextStyle light12(Color color, {bool isUnderline = false}) {
    return _light(12, color, isUnderline: isUnderline);
  }

  static TextStyle light13(Color color, {bool isUnderline = false}) {
    return _light(13, color, isUnderline: isUnderline);
  }

  static TextStyle light14(Color color, {bool isUnderline = false}) {
    return _light(14, color, isUnderline: isUnderline);
  }

  static TextStyle light15(Color color, {bool isUnderline = false}) {
    return _light(15, color, isUnderline: isUnderline);
  }

  static TextStyle light16(Color color, {bool isUnderline = false}) {
    return _light(16, color, isUnderline: isUnderline);
  }

  static TextStyle light17(Color color, {bool isUnderline = false}) {
    return _light(17, color, isUnderline: isUnderline);
  }

  static TextStyle light18(Color color, {bool isUnderline = false}) {
    return _light(18, color, isUnderline: isUnderline);
  }

  static TextStyle light19(Color color, {bool isUnderline = false}) {
    return _light(19, color, isUnderline: isUnderline);
  }

  static TextStyle light20(Color color, {bool isUnderline = false}) {
    return _light(20, color, isUnderline: isUnderline);
  }

  static TextStyle light21(Color color, {bool isUnderline = false}) {
    return _light(21, color, isUnderline: isUnderline);
  }

  static TextStyle light22(Color color, {bool isUnderline = false}) {
    return _light(22, color, isUnderline: isUnderline);
  }

  static TextStyle light23(Color color, {bool isUnderline = false}) {
    return _light(23, color, isUnderline: isUnderline);
  }

  static TextStyle light24(Color color, {bool isUnderline = false}) {
    return _light(24, color, isUnderline: isUnderline);
  }

  static TextStyle light25(Color color, {bool isUnderline = false}) {
    return _light(25, color, isUnderline: isUnderline);
  }

  static TextStyle light26(Color color, {bool isUnderline = false}) {
    return _light(26, color, isUnderline: isUnderline);
  }

  static TextStyle light27(Color color, {bool isUnderline = false}) {
    return _light(27, color, isUnderline: isUnderline);
  }

  static TextStyle light28(Color color, {bool isUnderline = false}) {
    return _light(28, color, isUnderline: isUnderline);
  }

  static TextStyle light29(Color color, {bool isUnderline = false}) {
    return _light(29, color, isUnderline: isUnderline);
  }

  static TextStyle light30(Color color, {bool isUnderline = false}) {
    return _light(30, color, isUnderline: isUnderline);
  }

  static TextStyle light31(Color color, {bool isUnderline = false}) {
    return _light(31, color, isUnderline: isUnderline);
  }

  static TextStyle light32(Color color, {bool isUnderline = false}) {
    return _light(32, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall9(Color color, {bool isUnderline = false}) {
    return extraSmall(9, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall10(Color color, {bool isUnderline = false}) {
    return extraSmall(10, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall11(Color color, {bool isUnderline = false}) {
    return extraSmall(11, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall12(Color color, {bool isUnderline = false}) {
    return extraSmall(12, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall13(Color color, {bool isUnderline = false}) {
    return extraSmall(13, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall14(Color color, {bool isUnderline = false}) {
    return extraSmall(14, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall15(Color color, {bool isUnderline = false}) {
    return extraSmall(15, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall16(Color color, {bool isUnderline = false}) {
    return extraSmall(16, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall17(Color color, {bool isUnderline = false}) {
    return extraSmall(17, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall18(Color color, {bool isUnderline = false}) {
    return extraSmall(18, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall19(Color color, {bool isUnderline = false}) {
    return extraSmall(19, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall20(Color color, {bool isUnderline = false}) {
    return extraSmall(20, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall21(Color color, {bool isUnderline = false}) {
    return extraSmall(21, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall22(Color color, {bool isUnderline = false}) {
    return extraSmall(22, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall23(Color color, {bool isUnderline = false}) {
    return extraSmall(23, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall24(Color color, {bool isUnderline = false}) {
    return extraSmall(24, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall25(Color color, {bool isUnderline = false}) {
    return extraSmall(25, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall26(Color color, {bool isUnderline = false}) {
    return extraSmall(26, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall27(Color color, {bool isUnderline = false}) {
    return extraSmall(27, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall28(Color color, {bool isUnderline = false}) {
    return extraSmall(28, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall29(Color color, {bool isUnderline = false}) {
    return extraSmall(29, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall30(Color color, {bool isUnderline = false}) {
    return extraSmall(30, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall31(Color color, {bool isUnderline = false}) {
    return extraSmall(31, color, isUnderline: isUnderline);
  }

  static TextStyle extraSmall32(Color color, {bool isUnderline = false}) {
    return extraSmall(32, color, isUnderline: isUnderline);
  }

  static TextStyle small9(Color color, {bool isUnderline = false}) {
    return small(9, color, isUnderline: isUnderline);
  }

  static TextStyle small10(Color color, {bool isUnderline = false}) {
    return small(10, color, isUnderline: isUnderline);
  }

  static TextStyle small11(Color color, {bool isUnderline = false}) {
    return small(11, color, isUnderline: isUnderline);
  }

  static TextStyle small12(Color color, {bool isUnderline = false}) {
    return small(12, color, isUnderline: isUnderline);
  }

  static TextStyle small13(Color color, {bool isUnderline = false}) {
    return small(13, color, isUnderline: isUnderline);
  }

  static TextStyle small14(Color color, {bool isUnderline = false}) {
    return small(14, color, isUnderline: isUnderline);
  }

  static TextStyle small15(Color color, {bool isUnderline = false}) {
    return small(15, color, isUnderline: isUnderline);
  }

  static TextStyle small16(Color color, {bool isUnderline = false}) {
    return small(16, color, isUnderline: isUnderline);
  }

  static TextStyle small17(Color color, {bool isUnderline = false}) {
    return small(17, color, isUnderline: isUnderline);
  }

  static TextStyle small18(Color color, {bool isUnderline = false}) {
    return small(18, color, isUnderline: isUnderline);
  }

  static TextStyle small19(Color color, {bool isUnderline = false}) {
    return small(19, color, isUnderline: isUnderline);
  }

  static TextStyle small20(Color color, {bool isUnderline = false}) {
    return small(20, color, isUnderline: isUnderline);
  }

  static TextStyle small21(Color color, {bool isUnderline = false}) {
    return small(21, color, isUnderline: isUnderline);
  }

  static TextStyle small22(Color color, {bool isUnderline = false}) {
    return small(22, color, isUnderline: isUnderline);
  }

  static TextStyle small23(Color color, {bool isUnderline = false}) {
    return small(23, color, isUnderline: isUnderline);
  }

  static TextStyle small24(Color color, {bool isUnderline = false}) {
    return small(24, color, isUnderline: isUnderline);
  }

  static TextStyle small25(Color color, {bool isUnderline = false}) {
    return small(25, color, isUnderline: isUnderline);
  }

  static TextStyle small26(Color color, {bool isUnderline = false}) {
    return small(26, color, isUnderline: isUnderline);
  }

  static TextStyle small27(Color color, {bool isUnderline = false}) {
    return small(27, color, isUnderline: isUnderline);
  }

  static TextStyle small28(Color color, {bool isUnderline = false}) {
    return small(28, color, isUnderline: isUnderline);
  }

  static TextStyle small29(Color color, {bool isUnderline = false}) {
    return small(29, color, isUnderline: isUnderline);
  }

  static TextStyle small30(Color color, {bool isUnderline = false}) {
    return small(30, color, isUnderline: isUnderline);
  }

  static TextStyle small31(Color color, {bool isUnderline = false}) {
    return small(31, color, isUnderline: isUnderline);
  }

  static TextStyle small32(Color color, {bool isUnderline = false}) {
    return small(32, color, isUnderline: isUnderline);
  }
}
