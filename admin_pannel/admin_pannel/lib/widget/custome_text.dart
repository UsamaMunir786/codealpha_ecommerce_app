import 'package:admin_pannel/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class CustomeText extends StatelessWidget {
  final String imageUrl, text;
  final Function function;

  const CustomeText({
    super.key, 
    required this.imageUrl, 
    required this.text, 
    required this.function});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Image.asset(
        imageUrl,
        height: 30,
      ),
      title: SubtitleText(label: text),
      trailing: Icon(Icons.arrow_right),
    );
  }
}