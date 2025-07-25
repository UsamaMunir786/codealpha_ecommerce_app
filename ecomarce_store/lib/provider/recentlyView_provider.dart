import 'package:ecomarce_store/models/viewProduct_model.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RecentlyViewProvider with ChangeNotifier{
  final Map<String, ViewproductModel> _viewItems = {};

  Map<String, ViewproductModel> get getViewProductItems{
    return _viewItems;
  }

  // bool isProductInWishlist({required String productId}){
  //   return _viewItems.containsKey(productId);
  // }

  void addProductToHistory({required String productId}){
    if(_viewItems.containsKey(productId)){
      _viewItems.remove(productId);
    }else {
      _viewItems.putIfAbsent(productId, () => ViewproductModel(
        id: Uuid().v4(), 
        productId: productId,
        ));
    }
    notifyListeners();
  }

  // void clearWishlist(){
  //   _viewItems.clear();
  //   notifyListeners();
  // }
}