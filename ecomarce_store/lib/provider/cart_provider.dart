import 'package:ecomarce_store/models/cart_model.dart';
import 'package:ecomarce_store/models/product_model.dart';
import 'package:ecomarce_store/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier{

  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems{
    return _cartItems;
  }

  bool isProductInCart({required String productId}){

    return _cartItems.containsKey(productId);

  }

  void addProductToCart({required String productId}){
    _cartItems.putIfAbsent(productId, () => CartModel(
      cartId: Uuid().v4(),
      productId: productId, 
      quntity: 1,
      ));
      notifyListeners();
  }

  void updateQuantity({required String productId, required int quntity}){
    _cartItems.update(
      productId, 
      (item)=> CartModel(
        cartId: item.cartId, 
        productId: productId, 
        quntity: quntity,
        ));
        notifyListeners();

  }

  double getTotal({required ProductProvider productProvider}){
    double total =0.0;
    _cartItems.forEach((key, value) {
      final ProductModel? getCurrProduct = 
      productProvider.findByProdId(value.productId);
      if(getCurrProduct != null){
        total += total = double.parse(getCurrProduct.productPrice) * value.quntity;;
      }
    },);
    return total;
  }

  int getQty(){
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.quntity;
    },);
    return total;
  }

  void removeOneItem({required String productId}){
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart(){
    _cartItems.clear();
    notifyListeners();
  }
}