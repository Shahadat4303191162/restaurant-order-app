
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:order_app_for_resturent/provider/cart_provider.dart';
import 'package:order_app_for_resturent/provider/order_provider.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../utils/constants.dart';
import '../widgets/product_item.dart';
import 'order_palace_view.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = '/overView';

  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}


class _ProductPageState extends State<ProductPage> {

  int? chipValue = 0;
  String selectedCatName = '';

  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context,listen: false).getAllProducts();
    Provider.of<ProductProvider>(context,listen: false).getAllCategories();
    Provider.of<CartProvider>(context,listen: false).getCartByUser();
    Provider.of<ProductProvider>(context,listen: false).getAllFeaturedProducts();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    return Scaffold(
      backgroundColor: skyBlue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            Icon(Icons.emoji_food_beverage_outlined,
              color: dark,
              size: 50,
            ),
            SizedBox(width: 10,),
            Text('Khanas',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: dark),)
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(30)
                ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appPadding,vertical: 6),
                child: Text('Call for Waiter',
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
              ),
            ),
          )
        ],
      ),
      body:
      Row(
        children: [
          Expanded(
            flex: 5,
            child:
            Consumer<ProductProvider>(
              builder: (context, provider, _) => ListView(
                children: [
                  Container(
                    height: 350,
                    child: CarouselSlider(
                        items: provider.featuredProductList
                            .map((e) => Container(
                          decoration: const BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FadeInImage.assetNetwork(
                                  fadeInDuration:
                                  const Duration(seconds: 2),
                                  fadeInCurve: Curves.bounceInOut,
                                  placeholder: 'images/placeholder.jpg',
                                  image: e.thumbnailImageUrl!,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ))
                            .toList(),
                        options: CarouselOptions(
                          height: 300.0,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          //onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                        ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.categoryNameList.length,
                        itemBuilder: (context, index) {
                          final catName = provider.categoryNameList[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ChoiceChip(
                              labelStyle: TextStyle(
                                  color: chipValue == index
                                      ? Colors.white
                                      : Colors.black),
                              selectedColor: green,
                              label: Text(catName),
                              selected: chipValue == index,
                              onSelected: ((value) {
                                setState(() {
                                  chipValue = value ? index : null;
                                  selectedCatName =
                                  provider.categoryNameList[index];
                                });
                                if (chipValue != null && chipValue != 0) {
                                  provider.getAllProductsByCategory(catName);
                                } else if (chipValue == 0) {
                                  provider.getAllProducts();
                                }
                              }),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: dark,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: appPadding,vertical: 3),
                            child: selectedCatName.isEmpty?
                            Text('All',
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor),):
                            Text('$selectedCatName',
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: provider.productList.isEmpty
                        ? const Center(
                      child: Text(
                        'NO Item found',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                        : Expanded(
                      child: SingleChildScrollView(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: 0.77),
                          itemBuilder: (context, index) {
                            final product = provider.productList[index];
                            return ProductItem(
                              productModel: product,
                            );
                          },
                          itemCount: provider.productList.length,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
          Expanded(flex: 2, child: OrderPalaceView())
        ],
      ),
    );
  }
}




