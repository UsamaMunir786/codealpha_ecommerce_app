import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String productId;
  final String productTitle;
  final String productPrice;
  final String productCategory;
  final String productDescription;
  final String productImage;
  final String productQuantity;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data) {
  return ProductModel(
    productId: data['productId'] ?? '',
    productTitle: data['productTitle'] ?? '',
    productPrice: data['productPrice'] ?? '',
    productCategory: data['productCategory'] ?? '',
    productDescription: data['productDescription'] ?? '',
    productImage: data['productImage'] ?? '',
    productQuantity: data['productQuantity'] ?? '',
  );
}

}
