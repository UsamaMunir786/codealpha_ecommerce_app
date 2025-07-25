import 'package:admin_pannel/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: TitleText(label: 'usama chaudhry'), 
      baseColor: Colors.purple, 
      highlightColor: Colors.red
      );
  }
}