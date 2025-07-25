import 'package:ecomarce_store/consts/theme_data.dart';
import 'package:ecomarce_store/firebase_options.dart';
import 'package:ecomarce_store/provider/cart_provider.dart';
import 'package:ecomarce_store/provider/product_provider.dart';
import 'package:ecomarce_store/provider/recentlyView_provider.dart';
import 'package:ecomarce_store/provider/theme_provider.dart';
import 'package:ecomarce_store/provider/wishlist_provider.dart';
import 'package:ecomarce_store/root_screen.dart';
import 'package:ecomarce_store/screen/auth/login.dart';
import 'package:ecomarce_store/screen/auth/signup.dart';
import 'package:ecomarce_store/screen/home_page.dart';
import 'package:ecomarce_store/screen/inner_screen/product_detail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => ProductProvider()),
      ChangeNotifierProvider(create: (context) => CartProvider()),
      ChangeNotifierProvider(create: (context) => WishlistProvider()),
      ChangeNotifierProvider(create: (context) => RecentlyViewProvider()),
    ]
    ,
    child: Consumer<ThemeProvider>(builder: (context, themeProvider, child){
      return MaterialApp(
     
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme, context: context),
      home: RootScreen(),
    );
    }),
    );
  }
}

