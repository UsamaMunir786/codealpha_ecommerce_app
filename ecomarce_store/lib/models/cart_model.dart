import 'package:flutter/material.dart';

class CartModel with ChangeNotifier{
  final String cartId;
  final String productId;
  final int quntity;

  CartModel({required this.cartId, required this.productId, required this.quntity});


}
