import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecomarce_store/provider/wishlist_provider.dart';
import 'package:ecomarce_store/widget/empty_widget.dart';
import 'package:ecomarce_store/widget/products/product_widget.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return wishlistProvider.getWishlistItems.isEmpty ? Scaffold(
         body: EmptyWidget(
          imageUrl: 'assets/images/bag/shopping_basket.png', 
          title: 'Your wishlist is empty', 
          subtitle: 'Look like you didn\'t to anything yet to your card', 
          buttontext: 'Showp Now'),
      
    ) : Scaffold(
      appBar: AppBar(
        title: TitleText(label: 'Wishlist ${wishlistProvider.getWishlistItems.length}'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);

            },
            child: Icon(Icons.arrow_back_ios_new_rounded)),
        ),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
        

            Expanded(
              child: DynamicHeightGridView(
                builder: (context, index){

                  return ProductWidget(
                    productId: wishlistProvider.getWishlistItems.values.toList()[index].productId,
                  );
                  
                }, 
                itemCount: wishlistProvider.getWishlistItems.length, 
                crossAxisCount: 2),
            )
          ],
        ),
      )
    );
  }
}