import 'package:ecomarce_store/screen/search_screen.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class CtgRounded extends StatelessWidget {

  final String image, name;

  const CtgRounded({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),
        settings: RouteSettings(arguments: name)
        ));
      },
      child: Column(
        children: [
          Image.asset(
            image,
            height: 50,
            width: 50,
          ),
          SizedBox(height: 5,),
          SubtitleText(
            label: name, 
            fontsize: 14, 
            fontWeight: FontWeight.bold,)
        ],
      ),
    );
  }
}