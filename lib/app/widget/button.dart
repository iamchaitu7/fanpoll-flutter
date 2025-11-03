// ignore_for_file: unnecessary_import

import 'dart:ui';

import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final double? width;
  final double? height;
  final Color? fillColor;
  final Color? bordercolor;
  final Color? textcolor;
  final double? boredrwidth;
  final double? boredrraduis;
  final TextStyle? style;
  final Future<void> Function()? onTap; // Use Future to await action
  final bool isLoading;
  final bool isGoogle;
  final String? image;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.boredrwidth,
    this.height,
    this.style,
    this.boredrraduis,
    this.bordercolor,
    this.textcolor,
    this.fillColor,
    this.isLoading = false,
    this.isGoogle = false,
    this.image,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() {
      _scale = 0.98;
    });
  }

  void _onTapUp(_) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: Duration(milliseconds: 100),
      child: Container(
        height: widget.height ?? 44.h,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.boredrraduis ?? 50.sp),
          border: Border.all(
            color: widget.bordercolor ?? AppColor.PrimaryColor,
            width: widget.boredrwidth ?? 2.w,
          ),
          color: widget.fillColor ?? AppColor.PrimaryColor,
        ),
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: widget.isLoading
                ? null
                : () async {
                    _onTapDown(null);
                    await Future.delayed(Duration(milliseconds: 100));
                    _onTapUp(null);
                    if (widget.onTap != null) {
                      await widget.onTap!();
                    }
                  },
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(widget.textcolor ?? AppColor.BackgroundColor),
                        strokeWidth: 2,
                      ),
                    )
                  : widget.isGoogle
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Image.asset(widget.image ?? AssetPath.Google),
                            ),
                            Text(
                              widget.text,
                              style: widget.style ?? CustomText.medium15(widget.textcolor ?? AppColor.BackgroundColor),
                            ),
                          ],
                        )
                      : Text(
                          widget.text,
                          style: widget.style ?? CustomText.medium15(widget.textcolor ?? AppColor.BackgroundColor),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
