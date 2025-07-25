import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  final String label;
  final double fontsize;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration textdecoration;
  final TextAlign? textAlign;

  const SubtitleText({
    super.key,
    required this.label,
    this.fontsize = 14,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.textdecoration = TextDecoration.none, this.color,  this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontsize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        color: color,
        decoration: textdecoration
        
      ),
      
    );
  }
}
