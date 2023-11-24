

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class CustomizeProduct extends StatelessWidget {
  static const String routeName='/customizeProduct';
  const CustomizeProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => provider.categoryList.isEmpty
        ? const Center(
          child: Text('No Item found',style: TextStyle(fontSize: 18),),
        )
            :ListView.builder(
          itemCount: provider.categoryList.length,
          itemBuilder: (context, index) {
            final category = provider.categoryList[index];
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 0,
                    horizontal: screenWidth > 1000 ? screenWidth * 0.3
                        : screenWidth > 600 ? screenWidth * 0.1 : 20),
              child: ExpansionTile(
                title: Text(category.name!),
                children: [
                  
                ],
              ),
            );
          },
        )

      ),
    );
  }
}
