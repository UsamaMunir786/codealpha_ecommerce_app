// import 'package:ecomarce_store/models/category_model.dart';
import 'package:admin_pannel/models/category_model.dart';
import 'package:flutter/material.dart';


class AppConstant {
  static String productImageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5scLLpAaoLaNQozYKHA31grph8s7blbqZPg&s';

  // static List<String> bannersImages = [
  //   'assets/images/banners/banner1.png',
  //   'assets/images/banners/banner2.png'
  // ];

  static List<String> categoriesList = [

    'Phones',
    'Cloths',
    'Beauty',
    'Shose',
    'Funiture',
    'Watches'
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList{
    List<DropdownMenuItem<String>> menuItems = 
    List<DropdownMenuItem<String>>.generate(
      categoriesList.length,
      (index) => DropdownMenuItem(
        value: categoriesList[index],
        child: Text(categoriesList[index])
        ),
    );
    return menuItems;
  }

}