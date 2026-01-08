import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:tickit/core/utils/app_colors.dart';
import 'package:tickit/core/utils/app_icons.dart';

import '../../../../core/services/google_auth.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({
    super.key,
    required this.height,
    required this.width,
    required this.fontSize,
    required this.buttonSize,
  });

  final double height;
  final double width;
  final double fontSize;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Let's get started! Join now and take control of your tasks.",
            textAlign: TextAlign.center,
            style: GoogleFonts.caveat(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
                GoogleService.nativeSignInWithGoogle(context);
              } else {
                GoogleService.webSignInWithGoogle(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pink.withAlpha(75),
              foregroundColor: pink,
              shadowColor: Colors.transparent,
              minimumSize: Size(buttonSize, buttonSize),
              maximumSize: Size(300, 300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Svgs(
              image: "assets/icons/google.svg",
              color: pink,
              size: 35,
            ),
          ),
          // RichText(
          //   textAlign: TextAlign.center,
          //   text: TextSpan(
          //     style: GoogleFonts.quicksand(
          //       fontSize: 12,
          //       color: black,
          //       fontWeight: FontWeight.w600,
          //     ),
          //     children: [
          //       const TextSpan(
          //           text: "By creating an account you agree to TickIt \n"),
          //       textButton(context, "Terms of Services", "/termsOfServices"),
          //       const TextSpan(text: " and "),
          //       textButton(context, "Privacy Policy.", "/privacyPolicy"),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
