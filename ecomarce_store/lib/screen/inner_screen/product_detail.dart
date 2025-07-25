import 'package:ecomarce_store/consts/app_constant.dart';
import 'package:ecomarce_store/models/product_model.dart';
import 'package:ecomarce_store/provider/cart_provider.dart';
import 'package:ecomarce_store/provider/product_provider.dart';
import 'package:ecomarce_store/widget/app_name_text.dart';
import 'package:ecomarce_store/widget/products/heart_button.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findByProdId(productId);
    return Scaffold(
      appBar: AppBar(
        title: AppNameText(),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            FancyShimmerImage(
              imageUrl: getCurrentProduct!.productImage,
              height: size.height * 0.40,
              width: double.infinity,
              boxFit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      getCurrentProduct.productTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SubtitleText(
                    label: getCurrentProduct.productPrice,
                    color: Colors.blueAccent,
                    fontsize: 20,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeartButton(
                    productId: getCurrentProduct.productId,
                    colors: Colors.blue.shade300),
                  SizedBox(
                    height: kBottomNavigationBarHeight - 10,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        if (cartProvider.isProductInCart(
                          productId: getCurrentProduct.productId,
                        )) {
                          return;
                        }
                        cartProvider.addProductToCart(
                          productId: getCurrentProduct.productId,
                        );
                      },
                      icon: Icon(
                        cartProvider.isProductInCart(
                              productId: getCurrentProduct.productId,
                            )
                            ? Icons.check
                            : Icons.add_shopping_cart_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        cartProvider.isProductInCart(
                              productId: getCurrentProduct.productId,
                            )
                            ? 'In Cart'
                            : 'Add to Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleText(label: 'About this item'),
                  SubtitleText(label: getCurrentProduct.productCategory),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SubtitleText(label: getCurrentProduct.productDescription),
            ),
          ],
        ),
      ),
    );
  }
}
