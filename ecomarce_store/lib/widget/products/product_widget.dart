import 'package:ecomarce_store/consts/app_constant.dart';
import 'package:ecomarce_store/models/cart_model.dart';
import 'package:ecomarce_store/models/product_model.dart';
import 'package:ecomarce_store/provider/cart_provider.dart';
import 'package:ecomarce_store/provider/product_provider.dart';
import 'package:ecomarce_store/screen/inner_screen/product_detail.dart';
import 'package:ecomarce_store/widget/products/heart_button.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  final String productId;

  const ProductWidget({super.key, required this.productId});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findByProdId(widget.productId);
    final cardProvider = Provider.of<CartProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            (MaterialPageRoute(
              builder: (context) => ProductDetail(),
              settings: RouteSettings(arguments: getCurrentProduct.productId),
            )),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: FancyShimmerImage(
                imageUrl: getCurrentProduct!.productImage,
                height: size.height * 0.30,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TitleText(label: getCurrentProduct.productTitle),
                  ),
                  Flexible(flex: 2, 
                  child: HeartButton(
                    productId: getCurrentProduct.productId,
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SubtitleText(
                      label: getCurrentProduct.productPrice,
                      fontsize: 14,
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blueAccent,
                    child: IconButton(
                      splashColor: Colors.red,
                      splashRadius: 27,
                      onPressed: () {
                        if (cardProvider.isProductInCart(
                          productId: getCurrentProduct.productId,
                        )) {
                          return;
                        }
                        cardProvider.addProductToCart(
                          productId: getCurrentProduct.productId,
                        );
                        // setState(() {
                          
                        // });
                      },
                      icon: Icon(
                        cardProvider.isProductInCart(
                              productId: getCurrentProduct.productId,
                            )
                            ? Icons.check
                            : Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
