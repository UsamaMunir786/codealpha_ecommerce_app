import 'package:admin_pannel/consts/theme_data.dart';
import 'package:admin_pannel/firebase_options.dart';
import 'package:admin_pannel/provider/product_provider.dart';
import 'package:admin_pannel/provider/theme_provider.dart';
import 'package:admin_pannel/screens/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(

     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider())
      ],
      child: MyApp(),
      ),
      
    );
   
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Styles.themeData(
       isDarkTheme: themeProvider.getIsDarkTheme,
       context: context,
       
      ),
      home: const Dashboard(),
    );
  }
}
