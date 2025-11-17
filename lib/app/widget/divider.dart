// ignore_for_file: prefer_const_constructors, unused_import, implementation_imports

import 'package:fan_poll/app/utills/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';


class DividerRow extends StatelessWidget {
  final String text;
  const DividerRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Color(0xffDDDDDD))),
       
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Text(text,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Color(0x4D22212F)
),),
        ),
        Expanded(child: Divider(color: Color(0xffDDDDDD),)),
       
      ],
    );
  }
}