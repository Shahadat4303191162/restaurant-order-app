import 'dart:async';

import 'package:flutter/material.dart';
import 'package:order_app_for_resturent/models/product_model.dart';
import 'package:order_app_for_resturent/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../models/cart_moder.dart';
import '../page/product_details_page.dart';
import '../provider/cart_provider.dart';
import '../utils/constants.dart';


class ProductItem extends StatefulWidget {
  final ProductModel productModel;
  const ProductItem({super.key,required this.productModel});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName,
          arguments: widget.productModel.id),
      child: Padding(
        padding: const EdgeInsets.all(appPadding),
        child: Container(
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: FadeInImage.assetNetwork(
                      fadeInDuration: const Duration(seconds: 2),
                      fadeInCurve: Curves.bounceInOut,
                      placeholder: 'images/loading.gif',
                      image: widget.productModel.thumbnailImageUrl!,
                      width: double.maxFinite,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.productModel.name!,
                      style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Text('${widget.productModel.shortDescription != null && widget.productModel.shortDescription!.length >= 50
                  //     ? widget.productModel.shortDescription?.substring(0, 50)
                  //     : widget.productModel.shortDescription}',
                  //   style: const TextStyle(fontSize: 16),),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                    child: Text('${widget.productModel.shortDescription}',
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$currencysymbol ${widget.productModel.salesPrice}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.green),
                        ),

                        Consumer<CartProvider>(
                          builder: (context, provider, child) {
                            final isInCart = provider.isInCart(widget.productModel.id!);
                            return ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                  if (isInCart) {
                                    provider.removeFromCart(widget.productModel.id!);
                                  } else {
                                    final cartModel = CartModel(
                                      productId: widget.productModel.id!,
                                      productName: widget.productModel.name,
                                      imageUrl: widget.productModel.thumbnailImageUrl,
                                      salePrice: widget.productModel.salesPrice,
                                      stock: widget.productModel.stock,
                                      category: widget.productModel.category,
                                    );
                                    provider.addToCart(cartModel);
                                  }

                              },
                              icon: Icon(isInCart
                                  ? Icons.remove_shopping_cart
                                  : Icons.add_shopping_cart,
                                color: secondaryColor,

                              ),
                              label: Text(isInCart ? 'Remove' : 'ADD',style: TextStyle(color: secondaryColor),),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              if(widget.productModel.stock ==0 ) Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    color: Colors.black54,
                    child: const Text('OUT OF STOCK',style: TextStyle(color: Colors.white,fontSize: 18),),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
