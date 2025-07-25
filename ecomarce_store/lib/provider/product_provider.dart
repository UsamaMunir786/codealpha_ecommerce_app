import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomarce_store/models/product_model.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  ProductModel? findByProdId(String productId) {
    if (_products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    return _products.firstWhere((element) => element.productId == productId);
  }

  List<ProductModel> findByCategory({required String ctgName}) {
    List<ProductModel> ctgList =
        _products
            .where(
              (element) => element.productCategory.toLowerCase().contains(
                ctgName.toLowerCase(),
              ),
            )
            .toList();

    return ctgList;
  }

  List<ProductModel> searchQuery({
    required String searchText,
    required List<ProductModel> passedList,
  }) {
    List<ProductModel> searchList =
        passedList
            .where(
              (element) => element.productTitle.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
            )
            .toList();
    return searchList;
  }

  List<ProductModel> get getProducts => _products;

  bool _isFetched = false;
  Future<void> fetchProductsFromFirebase() async {
    if (_isFetched) return;
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('products').get();

      final loadedProducts =
          snapshot.docs.map((doc) {
            return ProductModel.fromMap(
              doc.data(),
            ); // Make sure `fromMap` is defined in ProductModel
          }).toList();

      // _products.clear();          // Clear old dummy data/
      // _products.addAll(loadedProducts);
      _products.insertAll(0, loadedProducts);
      _isFetched = true;
      notifyListeners();
    } catch (error) {
      print("Error fetching products: $error");
    }
  }

  final List<ProductModel> _products = [
    // Phones
    ProductModel(
      //1
      productId: 'Acheter un iPhone 14',
      productTitle: "iPhone 14",
      productPrice: "1199.99",
      productCategory: "Phones",
      productDescription:
          "Les détails concernant la livraison dans votre région s’afficheront sur la page de validation de la commande.",
      productImage: "https://i.ibb.co/G7nXCW4/3-i-Phone-14.jpg",
      productQuantity: "144",
    ),
    ProductModel(
      //2
      productId: 'iphone13-mini-256gb-midnight',
      productTitle:
          "iPhone 13 Mini, 256GB, Midnight - Unlocked (Renewed Premium)",
      productPrice: "659.99",
      productCategory: "Phones",
      productDescription:
          "5.4 Super Retina XDR display. 5G Superfast downloads, high quality streaming. Cinematic mode in 1080p at 30 fps. Dolby Vision HDR video recording up to 4K at 60 fps. 2X Optical zoom range. A15 Bionic chip. New 6-core CPU with 2 performance and 4 efficiency cores. New 4-core GPU. New 16-core Neural Engine. Up to 17 hours video playback. Face ID. Ceramic Shield front. Aerospace-grade aluminum. Water resistant to a depth of 6 meters for up to 30 minutes. Compatible with MagSafe accessories and wireless chargers.",
      productImage:
          "https://i.ibb.co/nbwTvXQ/2-iphone13-mini-256gb-midnight.webp",
      productQuantity: "15",
    ),
    ProductModel(
      //3
      productId: 'Acheter un iPhone 14',
      productTitle: "iPhone 14",
      productPrice: "1199.99",
      productCategory: "Phones",
      productDescription:
          "Les détails concernant la livraison dans votre région s’afficheront sur la page de validation de la commande.",
      productImage: "https://i.ibb.co/G7nXCW4/3-i-Phone-14.jpg",
      productQuantity: "144",
    ),
    ProductModel(
      //4
      productId: const Uuid().v4(),
      productTitle:
          "Samsung Galaxy S22 Ultra 5G - 256GB - Phantom Black (Unlocked)",
      productPrice: "1199.99",
      productCategory: "Phones",
      productDescription:
          "About this item\n6.8 inch Dynamic AMOLED 2X display with a 3200 x 1440 resolution\n256GB internal storage, 12GB RAM\n108MP triple camera system with 100x Space Zoom and laser autofocus\n40MP front-facing camera with dual pixel AF\n5000mAh battery with fast wireless charging and wireless power share\n5G capable for lightning fast download and streaming",
      productImage:
          "https://i.ibb.co/z5zMDCx/4-Samsung-Galaxy-S22-Ultra-5-G-256-GB-Phantom-Black-Unlocked.webp",
      productQuantity: "2363",
    ),
    ProductModel(
      //5
      productId: const Uuid().v4(),
      productTitle:
          "Samsung Galaxy S21 Ultra 5G | Factory Unlocked Android Cell Phone | US Version 5G Smartphone",
      productPrice: "1199.99",
      productCategory: "Phones",
      productDescription:
          "About this item\nPro Grade Camera: Zoom in close with 100X Space Zoom, and take photos and videos like a pro with our easy-to-use, multi-lens camera.\n100x Zoom: Get amazing clarity with a dual lens combo of 3x and 10x optical zoom, or go even further with our revolutionary 100x Space Zoom.\nHighest Smartphone Resolution: Crystal clear 108MP allows you to pinch, crop and zoom in on your photos to see tiny, unexpected details, while lightning-fast Laser Focus keeps your focal point clear\nAll Day Intelligent Battery: Intuitively manages your cellphone’s usage, so you can go all day without charging (based on average battery life under typical usage conditions).\nPower of 5G: Get next-level power for everything you love to do with Samsung Galaxy 5G; More sharing, more gaming, more experiences and never miss a beat",
      productImage:
          "https://i.ibb.co/ww5WjkV/5-Samsung-Galaxy-S21-Ultra-5-G.png",
      productQuantity: "3625",
    ),
    ProductModel(
      //6
      productId: const Uuid().v4(),
      productTitle:
          "OnePlus 9 Pro 5G LE2120 256GB 12GB RAM Factory Unlocked (GSM Only | No CDMA - not Compatible with Verizon/Sprint) International Version - Morning Mist",
      productPrice: "1099.99",
      productCategory: "Phones",
      productDescription:
          "About this item\n6.7 inch LTPO Fluid2 AMOLED, 1B colors, 120Hz, HDR10+, 1300 nits (peak)\n256GB internal storage, 12GB RAM\nQuad rear camera: 48MP, 50MP, 8MP, 2MP\n16MP front-facing camera\n4500mAh battery with Warp Charge 65T (10V/6.5A) and 50W Wireless Charging\n5G capable for lightning fast download and streaming",
      productImage:
          "https://i.ibb.co/0yhgKVv/6-One-Plus-9-Pro-5-G-LE2120-256-GB-12-GB-RAM.png",
      productQuantity: "3636",
    ),

    ProductModel(
      //7
      productId: const Uuid().v4(),
      productTitle: "Samsung Galaxy Z Flip3 5G",
      productPrice: "999.99",
      productCategory: "Phones",
      productDescription:
          "About this item\nGet the latest Galaxy experience on your phone.\nFOLDING DISPLAY - Transform the way you capture, share and experience content.\nCAPTURE EVERYTHING - With the wide-angle camera and the front camera, take stunning photos and videos from every angle.\nWATER RESISTANT - Use your Galaxy Z Flip3 5G even when it rains.\nONE UI 3.1 - Enjoy the Galaxy Z Flip3 5G’s sleek, premium design and all the features you love from the latest One UI 3.1. ",
      productImage: "https://i.ibb.co/NstFstg/7-Samsung-Galaxy-Z-Flip3-5-G.png",
      productQuantity: "525",
    ),
    ProductModel(
      //8
      productId: const Uuid().v4(),
      productTitle: "Apple introduces iPhone 14 and iPhone 14 Plus",
      productPrice: "1199.99",
      productCategory: "Phones",
      productDescription:
          "A new, larger 6.7-inch size joins the popular 6.1-inch design, featuring a new dual-camera system, Crash Detection, a smartphone industry-first safety service with Emergency SOS via satellite, and the best battery life on iPhone",
      productImage: "https://i.ibb.co/8P1HBm4/8-iphone14plushereo.jpg",
      productQuantity: "2526",
    ),

    ProductModel(
      //30
      productId: const Uuid().v4(),
      productTitle: "Herschel Supply Co. Settlement Backpack",
      productPrice: "64.99",
      productCategory: "Accessories",
      productDescription:
          "About this item\nSignature striped fabric liner\n15 inch laptop sleeve\nFront storage pocket with key clip\nInternal media pocket with headphone port\nClassic woven label\nDimensions: 17.75 inches (H) x 12.25 inches (W) x 5.75 inches (D)",
      productImage:
          "https://i.ibb.co/1GV6Nrv/30-Herschel-Supply-Co-Settlement-Backpack.png",
      productQuantity: "3637",
    ),
    ProductModel(
      //31
      productId: const Uuid().v4(),
      productTitle: "Fitbit Charge 5 Advanced Fitness Tracker",
      productPrice: "179.95",
      productCategory: "Accessories",
      productDescription:
          "About this item\nAdvanced sensors track daily activity, sleep, and stress levels\nUp to 7-day battery life\nEasily track heart rate and exercise metrics\nReceive notifications and control music from your wrist\nWater-resistant up to 50m\nConnect to your phone's GPS to track outdoor activities",
      productImage:
          "https://i.ibb.co/Wz2yzQ7/31-Fitbit-Charge-5-Advanced-Fitness-Tracker.png",
      productQuantity: "347343",
    ),
    ProductModel(
      //32
      productId: const Uuid().v4(),
      productTitle: "Fjallraven Kanken Classic Backpack",
      productPrice: "79.95",
      productCategory: "Accessories",
      productDescription:
          "About this item\nVinylon F fabric is durable and water-resistant\nClassic design with a spacious main compartment and front zippered pocket\nPadded shoulder straps for comfortable carrying\nDual top handles for easy transport\nReflective logo for visibility in low light\nDimensions: 15 inches (H) x 10.6 inches (W) x 5.1 inches (D)",
      productImage:
          "https://i.ibb.co/sjH157B/32-Fjallraven-Kanken-Classic-Backpack.jpg",
      productQuantity: "7585",
    ),
    ProductModel(
      //33
      productId: const Uuid().v4(),
      productTitle: "Nike Air Force 1 '07",
      productPrice: "90.99",
      productCategory: "Shoes",
      productDescription:
          "About this item\nFull-grain leather in the upper adds a premium look and feel.\nThe low-cut silhouette adds a simple, streamlined look.\nPadding at the collar feels soft and comfortable.\nNon-marking rubber in the sole adds traction and durability.",
      productImage: "https://i.ibb.co/G5kWzbM/33-Nike-Air-Force-1.webp",
      productQuantity: "47548",
    ),
    ProductModel(
      //34
      productId: const Uuid().v4(),
      productTitle: "Adidas Ultraboost 21",
      productPrice: "180.99",
      productCategory: "Shoes",
      productDescription:
          "About this item\nadidas Primeknit+ textile upper\nLace closure\nBoost midsole\nContinental™ Rubber outsole\nadidas Torsion System",
      productImage: "https://i.ibb.co/X7tVsZ1/34-Adidas-Ultraboost-21.webp",
      productQuantity: "7485",
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
  ];
}
