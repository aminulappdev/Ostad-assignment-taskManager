
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; 
import '../Utils/image_path.dart';

// ignore: must_be_immutable
class ScreenBackground extends StatelessWidget {
  ScreenBackground({super.key, required this.child});
  Widget child;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SvgPicture.asset(
          AssetPath.backgroundPath, 

          fit: BoxFit.cover,
          height: height,
          width: width,
        ),
        SafeArea(child: child)
      ],
    );
  }
}
