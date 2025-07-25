import 'package:ecomarce_store/consts/app_constant.dart';
import 'package:ecomarce_store/models/product_model.dart';
import 'package:ecomarce_store/provider/recentlyView_provider.dart';
import 'package:ecomarce_store/screen/inner_screen/product_detail.dart';
import 'package:ecomarce_store/widget/products/heart_button.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class LatestArrivalProducts extends StatelessWidget {
  const LatestArrivalProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final viewProvider = Provider.of<RecentlyViewProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async{
   
         viewProvider.addProductToHistory(productId: productModel.productId);

         await Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(),
          settings: RouteSettings(arguments: productModel.productId)
          ));
          
        },
        
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  
                  child: FancyShimmerImage(
                    imageUrl: productModel.productImage,
                    width: size.width * 0.28,
                    height: size.width * 0.28,
                    ),
                ),
              ),
              SizedBox(width: 6,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productModel.productTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    ),
                    //  SizedBox(height: 3,),
                    FittedBox(
                      child: Row(
                        children: [
                         HeartButton(productId: productModel.productId),
                            IconButton(
                            onPressed: (){}, 
                            icon: Icon(Icons.add_shopping_cart_rounded),
                            ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 2,),
                    FittedBox(
                      child: SubtitleText(label: '${productModel.productPrice}\$'),
                    ),
                  ],
                ))
            ],
          ),
          
        ),
      ),
    );
  }
}