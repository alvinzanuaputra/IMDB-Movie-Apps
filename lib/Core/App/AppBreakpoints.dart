import 'package:flutter/widgets.dart';

class AppBreakpoints {
  static const double tablet = 700;
  static const double desktop = 1100;

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isTablet(BuildContext context) => width(context) >= tablet;

  static bool isDesktop(BuildContext context) => width(context) >= desktop;
}
