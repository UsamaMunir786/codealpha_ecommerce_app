import 'package:ecomarce_store/models/cart_model.dart';
import 'package:ecomarce_store/provider/cart_provider.dart';
import 'package:ecomarce_store/provider/product_provider.dart';
import 'package:ecomarce_store/screen/cart/qty_btm_sheet.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModelProvider = Provider.of<CartModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findByProdId(cartModelProvider.productId);
    Size size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context);
    return getCurrentProduct == null ? SizedBox.shrink() : FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl: getCurrentProduct.productImage,
                  height: size.height * 0.2,
                  width: size.height * 0.2,
                  
                  ),
              ),
              SizedBox(width: 10,),
              IntrinsicWidth(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width*0.7,
                          child: TitleText(
                          label: getCurrentProduct.productTitle,
                          maxAlign: 2,
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: (){
                                cartProvider.removeOneItem(productId: getCurrentProduct.productId);
                              }, 
                              icon: Icon(Icons.delete,
                              color: Colors.red,
                              ),
                              ),

                              IconButton(
                              onPressed: (){}, 
                              icon: Icon(IconlyLight.heart,
                              color: Colors.red,
                              ),
                              ),

                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubtitleText(label: "${getCurrentProduct.productPrice}\$", color: Colors.blue, fontsize: 20,),
                        OutlinedButton.icon(
                          onPressed: () async{
                           await showModalBottomSheet(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            context: context, 
                            builder: (context){
                              return QuentityBottomSheet(
                                cartModel: cartModelProvider,
                              );
                            });
                          }, 
                          icon: Icon(IconlyLight.arrow_down_2),
                          label: Text('${cartModelProvider.quntity}')),
                      ],
                    )
                  ],
                ),
              ),
              
            ],
          ),
          
        ),
        
      ),
    );
  }
}