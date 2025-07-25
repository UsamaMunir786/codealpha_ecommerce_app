import 'package:ecomarce_store/provider/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class HeartButton extends StatefulWidget {
  final String productId;
  final double size;
  final Color colors;

  const HeartButton({super.key, this.size = 22,  this.colors = Colors.transparent, required this.productId});

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.colors,
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          shape: CircleBorder()
        ),
        onPressed: (){
          wishlistProvider.addOrRemoveFromWishlist(productId: widget.productId);
        },
         icon: Icon(
         wishlistProvider.isProductInWishlist(productId: widget.productId) 
         ? IconlyBold.heart 
         : IconlyLight.heart,
         size: widget.size,
         color: wishlistProvider.isProductInWishlist(productId: widget.productId)
          ? Colors.red
          : Colors.grey,
          )),
    );
  }
}