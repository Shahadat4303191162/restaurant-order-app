

import 'package:flutter/material.dart';
import 'package:order_app_for_resturent/auth/auth_services.dart';
import 'package:order_app_for_resturent/models/order_payment_model.dart';
import 'package:order_app_for_resturent/models/order_request_model.dart';

import '../db/dbhelper.dart';
import '../models/cart_moder.dart';
import '../models/category_model.dart';
import '../models/order_constants_model.dart';

class OrderProvider extends ChangeNotifier{
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<CartModel> cartList = [];
  List<OrderRequestModel> orderRequestDetailsList = [];
  String? orderRequestId;


  getOrderConstants(){
    DbHelper.getOrderConstants().listen((event) {
      if(event.exists){
        orderConstantsModel = OrderConstantsModel.fromMap(event.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> getOrderConstants2() async{
    final snapshot = await DbHelper.getOrderConstants2();
    orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
    notifyListeners();
  }

  Future<void> getOrderRequestId() async {
    final snap = await DbHelper.getLastOrderId(AuthService.user!.uid);

    if (snap.docs.isNotEmpty) {
      orderRequestId = snap.docs.first.id;
    } else {
      orderRequestId = null;
    }
    notifyListeners();
  }

  getOrderRequestDetails(){
    DbHelper.getOrderRequestDetails(AuthService.user!.uid).listen((snapshot) {
      orderRequestDetailsList = [OrderRequestModel.fromMap(snapshot.docs[0].data())];
      notifyListeners();
    });
  }

  Future<void> getOrderRequestByUser() async {
    // First, fetch the orderRequestId
    await getOrderRequestId();

    if (orderRequestId != null) {
      final ordId = orderRequestId!;
      print(ordId);
      DbHelper.getOrderRequestByCart(AuthService.user!.uid, ordId).listen((snapshot) {
        cartList = List.generate(snapshot.docs.length, (index) =>
            CartModel.fromMap(snapshot.docs[index].data()));
        notifyListeners();
      });
    } else {
      print('Order Request ID is not available');
      // Handle the case where orderRequestId is null
      // You may want to show an error or handle this situation accordingly
    }
  }



  Future<void> addRequestOrder(OrderRequestModel orderRequestModel,List<CartModel> cartList) =>
      DbHelper.addNewOrderRequest(orderRequestModel, cartList,AuthService.user!.uid);

  Future<void> addNewOrderPaymentProcess(OrderPaymentModel orderPaymentModel) =>
      DbHelper.addNewOrderPaymentProcess(orderPaymentModel,cartList, orderRequestId!);

  Future<void> updateProductStock(List<CartModel> cartList) =>
      DbHelper.updateProductStock(cartList);

  Future<void> updateCategoryProductCount
      (List<CategoryModel> catList,List<CartModel> cartList) =>
      DbHelper.updateCategoryProductCount(catList, cartList);

  Future<void> clearAllCartItems(List<CartModel> cartList) =>
      DbHelper.clearAllCartItems(AuthService.user!.uid, cartList);

  Future<void> updateOrderRequest(OrderRequestModel orderRequestModel,List<CartModel> cartList ,String ordId) =>
      DbHelper.updateOrderRequest(orderRequestModel, cartList, AuthService.user!.uid, ordId);

  Future<num> getCartSubTotal() async{
    await getOrderRequestByUser();
    num total = 0;
    for (var cartM in cartList){
      total +=cartM.salePrice * cartM.quantity;
    }
    return total;
  }

  num getDiscountAmount(num subTotal){
    return (subTotal * orderConstantsModel.discount) / 100;
   }

  num getVatAmount(num subTotal){
    final priceAfterDiscount = subTotal - getDiscountAmount(subTotal).round();
    return (priceAfterDiscount * orderConstantsModel.vat) / 100;
  }

  num getGrandTotal(num subtotal){
    final priceAfterDiscount = subtotal - getDiscountAmount(subtotal);
    final vatAmount = getVatAmount(subtotal).round();
    return vatAmount + priceAfterDiscount.round();
  }

}