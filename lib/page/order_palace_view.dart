import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:order_app_for_resturent/page/checkout_page.dart';
import 'package:provider/provider.dart';

import '../auth/auth_services.dart';
import '../models/data_model.dart';
import '../models/order_request_model.dart';
import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';
import '../provider/product_provider.dart';
import '../utils/constants.dart';

class OrderPalaceView extends StatefulWidget{
  @override
  State<OrderPalaceView> createState() => _OrderPalaceViewState();
}

class _OrderPalaceViewState extends State<OrderPalaceView> {


  num? selectedTableNumber;
  late OrderProvider orderProvider;
  late CartProvider cartProvider;

  bool dialogShown = false;
  final tableNumberController = TextEditingController();
  @override
  void didChangeDependencies() {
    Provider.of<OrderProvider>(context,listen: false).getOrderRequestId();
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    tableNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    orderProvider = Provider.of<OrderProvider>(context);
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )
      ),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Card(
            color: dark,
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Add To Cart',
                style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          ),
          SizedBox(height: 30,),
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, provider, child) => ListView.builder(
                shrinkWrap: true,
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartItem = provider.cartList[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(cartItem.imageUrl!),
                      ),
                      title: Text(
                        cartItem.productName!,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '$currencysymbol ${provider.unitPriceWithQunatity(cartItem)}',
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              provider.decreaseQuantity(cartItem);
                            },
                            icon: Icon(
                              Icons.remove_circle_outline,
                              size: 20,
                            ),
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              provider.increaseQuantity(cartItem);
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10,),
          !showUpdateOrder?
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: dark,
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
            ),
            onPressed: cartProvider.totalItemsInCart == 0 ? null : (){
              if (selectedTableNumber ==null && !dialogShown) {
                dialogShown = true;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Enter your Table Number'),
                        content: TextField(
                          keyboardType: TextInputType.number,
                          controller: tableNumberController,
                          decoration: const InputDecoration(
                              hintText: 'enter table number'
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              if (tableNumberController.text
                                  .isEmpty) {
                                return;
                              } else {
                                selectedTableNumber =num.parse(tableNumberController.text);
                                Navigator.of(context).pop(); // Close the AlertDialog
                                tableNumberController.clear();


                                Timer(const Duration(minutes: 10), () {
                                  dialogShown = false;
                                  selectedTableNumber = null;
                                });
                              }
                            },
                            child: Text('Ok'),
                          )
                        ],
                      );
                    }
                );
              }else{
                EasyLoading.show(status: 'Please Wait',dismissOnTap: false);
                final orderRequestModel = OrderRequestModel(
                    userId: AuthService.user!.uid,
                    tableNum: selectedTableNumber!,
                    orderDate: DateModel(
                      timestamp: Timestamp.fromDate(DateTime.now()),
                      day: DateTime.now().day,
                      month: DateTime.now().month,
                      year: DateTime.now().year,
                    )
                );
                orderProvider.addRequestOrder(orderRequestModel, cartProvider.cartList)
                    .then((_) => {
                  orderProvider.updateProductStock(cartProvider.cartList)
                      .then((_) => {
                    orderProvider.updateCategoryProductCount(context.read<ProductProvider>().categoryList, cartProvider.cartList)
                        .then((_) => {
                      orderProvider.clearAllCartItems(cartProvider.cartList)
                          .then((_) => {
                              EasyLoading.dismiss()
                        //     .then((value) {
                        //
                        // })
                      })
                    })
                  })
                });

                Timer(const Duration(seconds: 5),(){
                  setState(() {
                    showUpdateOrder = true;
                  });
                });
                Timer(const Duration(seconds: 10),(){
                  setState(() {
                    showbill = true;
                  });
                });
              }
            },
            child: const Text('Order Place',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: secondaryColor),
            ),
          ):
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: dark,
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              onPressed: cartProvider.totalItemsInCart == 0 ? null : ()async{
                if (selectedTableNumber ==null && !dialogShown) {
                  dialogShown = true;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Enter your Table Number'),
                          content: TextField(
                            keyboardType: TextInputType.number,
                            controller: tableNumberController,
                            decoration: const InputDecoration(
                                hintText: 'enter table number'
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                if (tableNumberController.text
                                    .isEmpty) {
                                  return;
                                } else {
                                  selectedTableNumber =num.parse(tableNumberController.text);
                                  Navigator.of(context).pop(); // Close the AlertDialog
                                  tableNumberController.clear();


                                  Timer(const Duration(minutes: 10), () {
                                    dialogShown = false;
                                    selectedTableNumber = null;
                                  });
                                }
                              },
                              child: Text('Ok'),
                            )
                          ],
                        );
                      }
                  );
                }else{
                  final lastOrderId = orderProvider.orderRequestId;
                  if(lastOrderId != null){
                    await updateNewOrder(lastOrderId,selectedTableNumber!,orderProvider,cartProvider,context);
                  }
                }
              },
              child: const Text('Update Order',
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: secondaryColor)
              )),
          showbill
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CheckoutPage.routeName,);

                  },
                  child: const Text(
                    'Show bill & Payment',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                )
              : Row(),
        ],
      ),
    );
  }
}

Future<void> updateNewOrder(
    String lastOrderId,
    num selectedTableNumber,
    orderProvider,
    cartProvider,
    BuildContext context,) async{
  EasyLoading.show(status: 'please Wait',dismissOnTap: false);
  final orderRequestModel = OrderRequestModel(
      userId: AuthService.user!.uid,
      tableNum: selectedTableNumber,
      orderDate: DateModel(
        timestamp: Timestamp.fromDate(DateTime.now()),
        day: DateTime.now().day,
        month: DateTime.now().month,
        year: DateTime.now().year,
      )
  );
  orderProvider.updateOrderRequest(orderRequestModel, cartProvider.cartList,lastOrderId)
      .then((_) => {
    orderProvider.updateProductStock(cartProvider.cartList)
        .then((_) => {
      orderProvider.updateCategoryProductCount(context.read<ProductProvider>().categoryList, cartProvider.cartList)
          .then((_) => {
        orderProvider.clearAllCartItems(cartProvider.cartList)
          .then((_) => {
            EasyLoading.dismiss()
            //     .then((value) {
            //
            // })
        })
      })
    })
  });
}