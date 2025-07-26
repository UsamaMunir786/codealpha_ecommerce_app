import 'package:card_swiper/card_swiper.dart';
import 'package:ecomarce_store/consts/app_constant.dart';
import 'package:ecomarce_store/provider/product_provider.dart';
import 'package:ecomarce_store/provider/theme_provider.dart';
import 'package:ecomarce_store/widget/app_name_text.dart';
import 'package:ecomarce_store/widget/products/ctg_rounded.dart';
import 'package:ecomarce_store/widget/products/latest_arrival_product.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:ecomarce_store/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


@override
void initState() {
  super.initState();
  Future.microtask(() {
    Provider.of<ProductProvider>(context, listen: false).fetchProductsFromFirebase();
  });
}


  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
   Size size = MediaQuery.of(context).size;
   final latestProduct = productProvider.getProducts;
    return Scaffold(
       appBar: AppBar(
        title: AppNameText(),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/bag/shopping_cart.png'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(
                height: size.height * 0.34,
                
                child: Swiper(
                  itemBuilder: (context, index) {
                    return Image.asset(AppConstant.bannersImages[index]);
                  },
                  itemCount:  AppConstant.bannersImages.length,
                  autoplay: true,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white,
                      activeColor: Colors.green
                    )
                  ),
                  ),
                  
              ),
              SizedBox(
                height: 15,
              ),
              TitleText(label: 'Latest Arrival',
              fontsize: 22,
              ),
          
              SizedBox(

                height: size.height * 0.2,
                child: ListView.builder(
                  
                  scrollDirection: Axis.horizontal,
                  itemCount: latestProduct.length,
                  itemBuilder: (context, index){
                  return ChangeNotifierProvider.value(
                    value: productProvider.getProducts[index],
                    child: LatestArrivalProducts(),
                    );
                }),
              ),
          
              SizedBox(height: 10,),
              TitleText(label: 'Categories', fontsize: 22, fontWeight: FontWeight.bold,),
          
              SizedBox(height: 10,),
          
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: 
                  List.generate(AppConstant.categoriesList.length, (index){
                    return CtgRounded(
                      image: AppConstant.categoriesList[index].image,
                      name: AppConstant.categoriesList[index].name,
                    );
                  })
                ,
                
                )
              
            ],
          ),
        ),
      ),
    );
  }
}
