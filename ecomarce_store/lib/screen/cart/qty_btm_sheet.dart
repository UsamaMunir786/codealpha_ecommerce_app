import 'package:ecomarce_store/models/cart_model.dart';
import 'package:ecomarce_store/provider/cart_provider.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuentityBottomSheet extends StatelessWidget {
  final CartModel cartModel;
  const QuentityBottomSheet({super.key, required this.cartModel});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Column(
      
      children: [
        SizedBox(height: 6,),
        Container(
          width: 30,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 6,),
        Expanded(
          child: ListView.builder(
          
            itemCount: 20,
            itemBuilder: (context, index){
            return GestureDetector(
              onTap: () {
                cartProvider.updateQuantity(
                  productId: cartModel.productId, 
                  quntity: index + 1);

                  Navigator.pop(context);
              },
              child: Center(child: SubtitleText(label: '${ index + 1}')));
          }),
        ),
      ],
    );
  }
}