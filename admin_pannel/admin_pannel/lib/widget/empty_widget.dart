import 'package:admin_pannel/widget/subtitle_text.dart';
import 'package:admin_pannel/widget/title_text.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {

  final String imageUrl, title, subtitle;
  

  const EmptyWidget({
    super.key, 
    required this.imageUrl, 
    required this.title, 
    required this.subtitle, 
    });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            imageUrl,
          height: size.height * 0.40,
          width: double.infinity,
          
          ),


          TitleText(label: 'Whoops!', color: Colors.red,),
          SizedBox(height: 10,),
          SubtitleText(label: title,
          // color: Colors.white,
          fontWeight: FontWeight.bold,
          fontsize: 25,
          ),
          SizedBox(
            height: 12,
          ),
          SubtitleText(label: subtitle,
          
          fontsize: 20,
          ),
         

          SizedBox(
            height: 30,
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     padding: EdgeInsets.all(15),
          //     backgroundColor: Colors.blueAccent
          //   ),
          //   onPressed: (){}, 
          //   child: Text(buttontext, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 23),))
          
        ],
      )
    );
  }
}