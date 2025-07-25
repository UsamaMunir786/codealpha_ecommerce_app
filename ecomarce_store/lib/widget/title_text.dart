import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String label;
  final double fontsize;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration textdecoration;
  final int? maxAlign;

  const TitleText({
    super.key,
    required this.label,
    this.fontsize = 20,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.textdecoration = TextDecoration.none, 
    this.color, 
    this.maxAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxAlign,
      style: TextStyle(
        fontSize: fontsize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        color: color,
        decoration: textdecoration,
        overflow: TextOverflow.ellipsis
      ),
      
    );
  }
}
