// import 'dart:ui_web';
import 'dart:ui'; // ✅ works on all platforms (web, android, ios)

import 'package:ecomarce_store/provider/theme_provider.dart';
import 'package:ecomarce_store/screen/auth/login.dart';
import 'package:ecomarce_store/screen/inner_screen/view_recently.dart';
import 'package:ecomarce_store/screen/inner_screen/wishlist_screen.dart';
import 'package:ecomarce_store/services/my_app_method.dart';
import 'package:ecomarce_store/widget/app_name_text.dart';
import 'package:ecomarce_store/widget/custome_text.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: AppNameText(),
        leading: Image.asset('assets/images/bag/shopping_cart.png'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TitleText(
                label: 'Please login to have ultimate access'
                ),
            ),
            ),
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.yellowAccent,
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: NetworkImage('https://plus.unsplash.com/premium_photo-1711051475117-f3a4d3ff6778?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bGFwdG9wfGVufDB8fDB8fHww'),
                        fit: BoxFit.cover,
                        ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      TitleText(
                        label: 'usama munir'
                        ),
                      SubtitleText(
                        label: 'usama@gmail.com'
                        ),
                    ],
                  ),
                ],
              ),
              
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(label: 'General'),
                  CustomeText(
                    imageUrl: 'assets/images/bag/order_svg.png', 
                    text: 'All Order', 
                    function: (){}
                    ),
                    CustomeText(
                    imageUrl: 'assets/images/bag/wishlist_svg.png', 
                    text: 'Wishlist', 
                    function: (){
                      Navigator.push(context, MaterialPageRoute(builder: (contex)=>WishlistScreen()));
                    }
                    ),
                    CustomeText(
                    imageUrl: 'assets/images/profile/recent.png', 
                    text: 'Viewed recently', 
                    function: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewRecently()));
                    }
                    ),
                    CustomeText(
                    imageUrl: 'assets/images/profile/address.png', 
                    text: 'Address', 
                    function: (){}
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TitleText(label: 'Setting'),
                    SwitchListTile(
                    title: Text(themeProvider.getIsDarkTheme ? 'Dark Mode' : 'Light Mode'),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                    themeProvider.setDarkTheme(themevalue: value);
                    }),
                   
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )
                        ),
                        onPressed: () async{
                          if(user == null){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                          }else{
                            await MyAppMethod.showErrorORWarningDialog(
                              context: context, 
                              subtitle: 'Are you sure', 
                              isError: false,
                              fct: () async{
                                await FirebaseAuth.instance.signOut();
                                // if(!mounted) return;
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                              }
                              );
                          }
                        },
                        icon: Icon(user == null ? Icons.login : Icons.logout, color: Colors.white,),
                        label: Text(user == null ? 'login' : 'logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                    )
                ],
              ),
            )
        ],
      )
    );
  }
}