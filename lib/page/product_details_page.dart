
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../provider/product_provider.dart';
import '../utils/constants.dart';


class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/details_page';

  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final pid = ModalRoute.of(context)!.settings.arguments as String;
    final provider = Provider.of<ProductProvider>(context, listen: false);
    Provider.of<ProductProvider>(context,listen: false).getProductByPriceVariation(pid);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: provider.getProductById(pid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = ProductModel.fromMap(snapshot.data!.data()!);
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 0,
                  horizontal: screenWidth > 1000 ? screenWidth * 0.3
                      : screenWidth > 600 ? screenWidth * 0.1 : 20),
              children: [
                CachedNetworkImage(
                  width: 75,
                  imageUrl: product.thumbnailImageUrl!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      product.name!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: ListTile(
                    title: const Text('Sales Price',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '$currencysymbol ${product.salesPrice}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: ListTile(
                    title: const Text(
                      'Short Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(product.shortDescription ?? 'Not Available'),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: ListTile(
                    title: const Text(
                      'Long Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(product.longDescription ?? 'Not Available'),
                  ),
                ),
                Card(
                  elevation: 5,
                ),
                Card(
                  elevation: 5,
                  child: ListTile(
                    title: const Text(
                      'Discount',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${product.productDiscount}%'),
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to get data'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
