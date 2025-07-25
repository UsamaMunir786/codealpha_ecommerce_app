import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomarce_store/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _products = [
    // Your dummy products here (copy paste from your existing dummy list)
    ProductModel(
      productId: 'iphone14-128gb-black',
      productTitle: "Apple iPhone 14 Pro (128GB) - Black",
      productPrice: "1399.99",
      productCategory: "Phones",
      productDescription:
          "6.1-inch Super Retina XDR display with ProMotion and always-on display...",
      productImage: "https://i.ibb.co/BtMBSgK/1-iphone14-128gb-black.webp",
      productQuantity: "10",
    ),
    ProductModel(
      //35
      productId: const Uuid().v4(),
      productTitle: "Converse Chuck Taylor All Star Low Top",
      productPrice: "50.9",
      productCategory: "Shoes",
      productDescription:
          "About this item\nLow-top sneaker with canvas upper\nIconic silhouette\nOrthoLite insole for comfort\nDiamond outsole tread\nUnisex Sizing",
      productImage:
          "https://i.ibb.co/TBQv7G6/22-Converse-Chuck-Taylor-All-Star-High-Top.png",
      productQuantity: "47433",
    ),
    ProductModel(
      //36
      productId: const Uuid().v4(),
      productTitle: "Vans Old Skool Classic Skate Shoes",
      productPrice: "65.99",
      productCategory: "Shoes",
      productDescription:
          "About this item\nSuede and Canvas Upper\nRe-enforced toecaps\nPadded collars\nSignature rubber waffle outsole",
      productImage: "https://i.ibb.co/NNDk3pt/24-Vans-Old-Skool.png",
      productQuantity: "383",
    ),
    // Add more dummy products ...
  ];

  List<ProductModel> get getProducts => _products;

  Future<void> fetchProductsFromFirebase() async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('products').get();

    if (snapshot.docs.isNotEmpty) {
      final loadedProducts = snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data());
      }).toList();

      // Merge logic
      _products.removeWhere((existing) =>
        loadedProducts.any((firebaseProd) => firebaseProd.productId == existing.productId));
      _products.addAll(loadedProducts);

      notifyListeners();
    } else {
      print("Firebase products empty, keeping dummy data.");
    }
  } catch (error) {
    print("Error fetching products: $error");
    // Keep dummy data intact on error
  }
}


  ProductModel? findByProdId(String productId) {
    return _products.firstWhere(
      (element) => element.productId == productId,
      orElse: () => throw Exception('not found'),
    );
  }

  List<ProductModel> findByCategory({required String ctgName}) {
    return _products
        .where((element) =>
            element.productCategory.toLowerCase().contains(ctgName.toLowerCase()))
        .toList();
  }

  List<ProductModel> searchQuery({
    required String searchText,
    required List<ProductModel> passedList,
  }) {
    return passedList
        .where((element) =>
            element.productTitle.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }
}
