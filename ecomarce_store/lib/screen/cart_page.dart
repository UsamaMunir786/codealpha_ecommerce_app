import 'package:ecomarce_store/provider/cart_provider.dart';
import 'package:ecomarce_store/screen/cart/cart_bottom.dart';
import 'package:ecomarce_store/screen/cart/cart_widget.dart';
import 'package:ecomarce_store/services/my_app_method.dart';
import 'package:ecomarce_store/widget/app_name_text.dart';
import 'package:ecomarce_store/widget/empty_widget.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return cartProvider.getCartItems.isEmpty ? Scaffold(
      body: EmptyWidget(
        imageUrl: 'assets/images/bag/shopping_basket.png',
        title: 'your cart is empty!', 
        subtitle: 'Looks like your cart is empty. \nAdd something and make me happy.', 
        buttontext: 'Shop Know'
        )
    ) : Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){
              cartProvider.clearCart();
            }, 
            icon: Icon(IconlyLight.delete,
            color: Colors.red,
            )),
        ],
        title: TitleText(label: "Cart (${cartProvider.getCartItems.length})"),
        leading: Image.asset('assets/images/bag/shopping_cart.png'),
      ),

      body: ListView.builder(
        itemCount: cartProvider.getCartItems.length,
        itemBuilder: (context, index){
          return ChangeNotifierProvider.value(
            value: cartProvider.getCartItems.values.toList()[index],
            child: CartWidget());
        }
        ),
        bottomSheet: CartBottom(),
    );
  }
}