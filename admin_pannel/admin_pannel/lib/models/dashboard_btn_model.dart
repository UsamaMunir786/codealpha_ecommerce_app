// import 'package:admin_pannel/screens/edit_upload_product_form.dart';
// import 'package:admin_pannel/screens/inner_screens/orders/orders_screen.dart';
// import 'package:admin_pannel/screens/search_screen.dart';
import 'package:admin_pannel/screens/innear_screen/orders_screen.dart';
import 'package:admin_pannel/screens/search_screen.dart';
import 'package:admin_pannel/screens/upload_product.dart';
import 'package:admin_pannel/services/assets_manger.dart';
import 'package:flutter/material.dart';
import 'dart:ui';



class DashboardButtonsModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardButtonsModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardButtonsModel> dashboardBtnList(BuildContext context) => [
        DashboardButtonsModel(
          text: "Add a new product",
          imagePath: AssetsManager.cloud,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UploadProduct()));
          },
        ),
        DashboardButtonsModel(
          text: "inspect all products",
          imagePath: AssetsManager.shoppingCart,
          onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
          },
        ),
        DashboardButtonsModel(
          text: "View Orders",
          imagePath: AssetsManager.order,
          onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersScreenFree()));
          },
        ),
      ];
}