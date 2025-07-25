import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecomarce_store/models/product_model.dart';
import 'package:ecomarce_store/provider/product_provider.dart';
import 'package:ecomarce_store/widget/products/product_widget.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<ProductModel> productListSearch = [];

  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    String? passedCategory = ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModel> productList = passedCategory == null ? productProvider.getProducts :
    productProvider.findByCategory(ctgName: passedCategory);

    return Scaffold(
      appBar: AppBar(
        title: TitleText(label: passedCategory ?? 'Search'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/bag/shopping_cart.png'),
        ),
      ),
      
      body: productList.isEmpty ? Center(child: TitleText(label: 'Np product found'),) : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextFormField(
              controller: searchController,
              style: TextStyle(fontSize: 22),
              decoration: InputDecoration(
                
                prefixIcon: Icon(IconlyLight.search, color: Colors.white,),
                suffix: IconButton(
                  onPressed: (){
                    setState(() {
                      searchController.clear();
                    });
                  }, 
                  icon: Icon(IconlyLight.close_square, color: Colors.red,)),
                  contentPadding: EdgeInsets.only(bottom: 12)
              ),
              onFieldSubmitted: (value) {
                setState(() {
                  productListSearch = productProvider.searchQuery(
                    searchText: searchController.text, 
                    passedList: productList);
                });
              },

              onChanged: (value){
                 setState(() {
                  productListSearch = productProvider.searchQuery(
                    searchText: searchController.text, 
                    passedList: productList);
                });
              },
              
            ),

            Expanded(
              child: DynamicHeightGridView(
                builder: (context, index){

                  return ProductWidget(
                    productId: searchController.text.isNotEmpty ? 
                    productListSearch[index].productId :
                    productList[index].productId
                    ,);
                  
                }, 
                itemCount: searchController.text.isNotEmpty 
                ? productListSearch.length
                : productList.length, 
                crossAxisCount: 2),
            )
          ],
        ),
      )
    );
  }
}