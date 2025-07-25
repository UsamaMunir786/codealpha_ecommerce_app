import 'package:admin_pannel/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class DashboarBtnWidget extends StatelessWidget {
  final String title, imagePath;
  final Function onPressed;

  const DashboarBtnWidget({
    super.key,
    required this.title, 
    required this.imagePath, 
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Card(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Image.asset(
              imagePath,
              height: 65,
              width: 65,
              ),
              SizedBox(height: 7,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SubtitleText(label: title, fontsize: 18, textAlign: TextAlign.center,),
              )
          ],
        ),
      ),
    );
  }
}