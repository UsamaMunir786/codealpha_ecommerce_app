import 'package:ecomarce_store/models/category_model.dart';


class AppConstant {
  static String productImageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5scLLpAaoLaNQozYKHA31grph8s7blbqZPg&s';

  static List<String> bannersImages = [
    'assets/images/banners/banner1.png',
    'assets/images/banners/banner2.png'
  ];

  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: 'Phones', 
      image: 'assets/images/categories/mobiles.png', 
      name: 'Phones',
      ),
     CategoryModel(
      id: 'Watches', 
      image: 'assets/images/categories/watch.png', 
      name: 'Watches',
      ),
       CategoryModel(
      id: 'Shoes', 
      image: 'assets/images/categories/shoes.png', 
      name: 'Shoes',
      ),
       CategoryModel(
      id: 'Books', 
      image: 'assets/images/categories/book_img.png', 
      name: 'Books',
      ),
       CategoryModel(
      id: 'Cosmetics', 
      image: 'assets/images/categories/cosmetics.png', 
      name: 'Cosmetics',
      ),
       CategoryModel(
      id: 'Electronics', 
      image: 'assets/images/categories/electronics.png', 
      name: 'Electronics',
      ),
       CategoryModel(
      id: 'Pc', 
      image: 'assets/images/categories/pc.png', 
      name: 'Pc',
      ),
  ];

}