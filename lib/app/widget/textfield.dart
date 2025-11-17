// ignore_for_file: prefer_const_constructors, unused_import, implementation_imports, must_be_immutable, unused_local_variable
import 'package:fan_poll/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextFiledWidget extends StatelessWidget {
  final String hinttext;
  final bool obscuretext;
  final int? maxlength;
  final String? counterText;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final String? Function(String?)? onchanged;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  IconData? icon;
  final String? initialValue;
  final Widget? suficesicon;
  TextFiledWidget({
    super.key,
    this.textInputType,
    required this.hinttext,
    this.icon,
    this.obscuretext = false,
    this.validator,
    this.onchanged,
    required this.controller,
    this.suficesicon,
    this.maxlength,
    this.initialValue,
    this.inputFormatters,
    this.focusNode, this.onFieldSubmitted,  this.counterText,
  });

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());
    return TextFormField(

      focusNode: focusNode,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      //   onFieldSubmitted: ,
      // onEditingComplete: ()=>FocusScope.of(context).nextFocus(),
      //textInputAction: TextInputAction.newline,
      inputFormatters: inputFormatters,
      maxLength: maxlength,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onchanged,
      validator: validator,
      cursorColor: AppColor.PrimaryColor,
      obscureText: obscuretext ? obscuretext : false,
      obscuringCharacter: "•",
      keyboardType: textInputType,
      decoration: InputDecoration(
           contentPadding: EdgeInsets.only(left: 25),
        counterText: counterText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColor.PrimaryColor, width: 0.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColor.PrimaryColor, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColor.PrimaryColor, width: 0.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColor.PrimaryColor, width: 0.5)),
          filled: true,
          fillColor: Colors.white,
          hintText: hinttext,
          hintStyle: TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w300,
              color: Colors.black38),
          suffixIcon: suficesicon,
     ),
    );
  }
}
