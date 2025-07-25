import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecomarce_store/provider/recentlyView_provider.dart';
import 'package:ecomarce_store/widget/empty_widget.dart';
import 'package:ecomarce_store/widget/products/product_widget.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';


class ViewRecently extends StatelessWidget {
  // const ViewRecently({super.key});
  final bool isEmpty = false;

  TextEditingController searchController = new TextEditingController();

  ViewRecently({super.key});

  @override
  Widget build(BuildContext context) {
    final viewProdProvider = Provider.of<RecentlyViewProvider>(context);
    return viewProdProvider.getViewProductItems.isEmpty ? Scaffold(
         body: EmptyWidget(
          imageUrl: 'assets/images/bag/shopping_basket.png', 
          title: 'Your viewed recently is empty', 
          subtitle: 'Look like you didn\'t to anything yet to your card', 
          buttontext: 'Showp Now'),
      
    ) : Scaffold(
      appBar: AppBar(
        title: TitleText(label: 'View Product ${viewProdProvider.getViewProductItems.length}'),
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
                    productId: viewProdProvider.getViewProductItems.values.toList()[index].productId,
                  );
                  
                }, 
                itemCount: viewProdProvider.getViewProductItems.length, 
                crossAxisCount: 2),
            )
          ],
        ),
      )
    );
  }
}