// ignore_for_file: camel_case_types

import 'package:flutter/widgets.dart';

class cSize {
  static double cHeight(BuildContext context, int originalTextSize) {
    double referenceWidth = 812.0;
    double deviceWidth = MediaQuery.of(context).size.height;
    double ratio = deviceWidth / referenceWidth;
    return originalTextSize * ratio;
  }

  static double cWidth(BuildContext context, int originalTextSize) {
    double referenceWidth = 375.0;
    double deviceWidth = MediaQuery.of(context).size.width;
    double ratio = deviceWidth / referenceWidth;
    return originalTextSize * ratio;
  }
}
