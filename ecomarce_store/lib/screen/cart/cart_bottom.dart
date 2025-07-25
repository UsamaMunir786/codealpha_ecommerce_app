import 'package:ecomarce_store/provider/cart_provider.dart';
import 'package:ecomarce_store/provider/product_provider.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartBottom extends StatelessWidget {
  const CartBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.grey
          ),
        )
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 13,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: TitleText(
                        label: 'Total: (${cartProvider.getCartItems.length} /${cartProvider.getCartItems.length})',
                        ),),
      
                        SubtitleText(
                          label: '${cartProvider.getTotal(productProvider: productProvider)}\$', 
                          color: Colors.blueAccent, 
                          fontsize: 20,
                          fontWeight: FontWeight.bold,),
                      
                  ],
                ),
                
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: (){}, 
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('CheckOut', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                )),
            ],
          ),
        ),
      ),
    );
  }
}