import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:order_app_for_resturent/models/data_model.dart';
import 'package:order_app_for_resturent/models/order_payment_model.dart';
import 'package:order_app_for_resturent/models/order_request_model.dart';
import 'package:order_app_for_resturent/page/online_order_successful_page.dart';
import 'package:order_app_for_resturent/page/product_page.dart';
import 'package:order_app_for_resturent/provider/order_provider.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../utils/constants.dart';
import 'cash_order_successful_page.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = 'checkoutPage';
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  late CartProvider cartProvider;
  late OrderProvider orderProvider;
  String paymentMethodGroupValue = PaymentMethod.cash;
  late num totalBil;
  bool showLoading = false;

  @override
  void initState() {
    cartProvider = Provider.of(context,listen: false);
    orderProvider = Provider.of(context,listen: false);
    orderProvider.getOrderConstants();
    setState(() {
      orderProvider.getCartSubTotal();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(orderProvider.orderConstantsModel.vat);
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
        children: [
          buildHeaderSection('Product Info'),
          buildProductInfoSection(),
          buildHeaderSection('Order Summery'),
          buildOrderSummerySection(),
          buildHeaderSection('Payment Method'),
          buildOrderPaymentMethodSection(),
          SizedBox(height: 50,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: dark,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 5)),
              onPressed: _savePayProcess,
              child: const Text(
                'Pay',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: secondaryColor),
              ))
        ],
      ),
    );
  }

  buildHeaderSection(String title) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  buildProductInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<OrderProvider>(
          builder:(context, orderProvider, child) {
            return Column(
              children: orderProvider.cartList.map((cartModel) => ListTile(
                title: Text(cartModel.productName!),
                trailing: Text('${cartModel.quantity}x$currencysymbol ${cartModel.salePrice}'),
              ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  buildOrderSummerySection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: FutureBuilder<num>(
              future: Future.delayed(Duration(milliseconds: 500),() => orderProvider.getCartSubTotal()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ); // Show a loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  num subtotal = snapshot.data!;
                  totalBil = orderProvider.getGrandTotal(subtotal);
                  return Container(
                    height: 230,
                    child: ListView(
                      children: [
                        ListTile(
                          title: const Text('Sub-Total'),
                          trailing: Text('$currencysymbol${snapshot.data}'), // Display the fetched subtotal
                        ),
                        ListTile(
                          title: Text('Discount (${orderProvider.orderConstantsModel.discount}%)'),
                          trailing: Text('-$currencysymbol${orderProvider.getDiscountAmount(snapshot.data!)}'),
                        ),
                        ListTile(
                          title: Text('Vat (${orderProvider.orderConstantsModel.vat}%)'),
                          trailing: Text('$currencysymbol${orderProvider.getVatAmount(snapshot.data!)}'),
                        ),
                        const Divider(height: 1.5,color: Colors.black,),
                        const SizedBox(
                          height: 4,
                        ),
                        ListTile(
                          title: Text('Grand Total'),
                          trailing: Text('$currencysymbol${orderProvider.getGrandTotal(snapshot.data!)}',
                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
      ),
    );
  }

  buildOrderPaymentMethodSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<String>(
                value: PaymentMethod.cash,
                groupValue: paymentMethodGroupValue,
                onChanged: (value) {
                  setState(() {
                    paymentMethodGroupValue = value!;
                  });
                }
            ),
            const Text(PaymentMethod.cash),
            const SizedBox(width: 150,),
            Radio(
                value: PaymentMethod.online,
                groupValue: paymentMethodGroupValue,
                onChanged: (value) {
                  setState(() {
                    paymentMethodGroupValue = value!;
                  });
                }
            ),
            const Text(PaymentMethod.online),
          ],
        ),
      ),
    );
  }

  void _savePayProcess() {
    EasyLoading.show(status: 'Please Wait',dismissOnTap: false);
    final orderPaymentModel = OrderPaymentModel(
        paymentMethod: paymentMethodGroupValue,
        discount: orderProvider.orderConstantsModel.discount,
        vat: orderProvider.orderConstantsModel.vat,
        grandTotal: totalBil,
        paymentDate: DateModel(
          timestamp: Timestamp.fromDate(DateTime.now()),
          day: DateTime.now().day,
          month: DateTime.now().month,
          year: DateTime.now().year,
        )
    );
    orderProvider.addNewOrderPaymentProcess(orderPaymentModel)
        .then((_) => {
          if(paymentMethodGroupValue == PaymentMethod.online){
            Navigator.pushNamedAndRemoveUntil(context, OnlineOrderSuccessfulPage.routeName,arguments:totalBil,
            ModalRoute.withName(ProductPage.routeName)),
            showUpdateOrder = false,
            showbill = false,
            EasyLoading.dismiss()

          }else{
            Navigator.pushNamed(context, CashOrderSuccessfulPage.routeName,arguments:totalBil),
          }
          
        });
  }
}




