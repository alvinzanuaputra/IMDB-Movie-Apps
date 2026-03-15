import 'package:flutter/material.dart';

Widget tittletext(String title) {
  return Text(
    title,
    style: const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xFFF7F8FA),
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.3,
      height: 1.1,
    ),
  );
}

Widget boldtext(String title) {
  return Text(
    title,
    style: const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xFFF7F8FA),
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
  );
}

Widget normaltext(String title) {
  return Text(
    title,
    style: const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xFFE5E7ED),
      fontSize: 15,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
  );
}

Widget datetext(String title) {
  return Text(
    title,
    style: const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xFFE5E7ED),
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.3,
    ),
  );
}

Widget ratingtext(String title) {
  return Text(
    title,
    style: const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xFFF7F8FA),
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );
}

Widget ultratittletext(String title) {
  return Text(
    title,
    style: const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xFFF7F8FA),
      fontSize: 28,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.3,
      height: 1.1,
    ),
  );
}

Widget genrestext(String title) {
  return Text(
    title,
    style: const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xFFF7F8FA),
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
  );
}

Widget overviewtext(String title) {
  return Text(
    title,
    style: const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xFFD3D7E0),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
      height: 1.45,
    ),
  );
}

Widget Tabbartext(String title) {
  return Text(
    title,
    style: const TextStyle(
      decoration: TextDecoration.none,
      color: Color(0xFFF7F8FA),
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );
}
