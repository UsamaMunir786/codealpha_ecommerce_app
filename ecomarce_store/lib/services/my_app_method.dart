import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyAppMethod {
  
  static Future<void> showErrorORWarningDialog({
    required BuildContext context,
    required String subtitle,
    required Function fct,
    bool isError = true,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset(
                //   AssetsManager.warning,
                //   height: 60,
                //   width: 60,
                // ),
                const SizedBox(
                  height: 16.0,
                ),
                SubtitleText(
                  label: subtitle,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isError,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const SubtitleText(
                            label: "Cancel", color: Colors.green),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        fct();
                        Navigator.pop(context);
                      },
                      child: const SubtitleText(
                          label: "OK", color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
  

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function camraFun,
    required Function gelleryFun,
    required Function removeFun,
  }) async {
     await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Center(
          child: TitleText(label: 'choose a option'),
          
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              TextButton.icon(
                onPressed: (){
                  camraFun();
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.camera),
                label: Text('camera'),
                ),

                 TextButton.icon(
                onPressed: (){
                  gelleryFun();
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.image),
                label: Text('Image'),
                ),

                 TextButton.icon(
                onPressed: (){
                  removeFun();
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.remove),
                label: Text('remove'),
                ),
            ],
          ),
        ),
      );
     });
  }
}