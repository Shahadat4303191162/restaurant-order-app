
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_app_for_resturent/models/cart_moder.dart';
import 'package:order_app_for_resturent/models/order_payment_model.dart';
import 'package:order_app_for_resturent/models/order_request_model.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class DbHelper{
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionSettings = 'Settings';
  static const String collectionTable = 'table';
  static const String collectionCart = 'Cart';
  static const String collectionUsers = 'Users';
  static const String collectionOrder = 'Order';
  static const String collectionOrderRequest = 'OrderRequest';
  static const String collectionOrderDetails = 'OrderDetails';
  static const String documentOrderConstant = 'orderConstant';
  static const String collectionDiversSelection = 'Size Variation';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;


  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllCategories()=>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllProducts()=>
      _db.collection(collectionProduct)
          .where(productAvailable, isEqualTo: true
      )
          .snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllProductsByCategory(String category)=>
    _db.collection(collectionProduct).where(productCategory,isEqualTo: category).snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllFeaturedProducts()=>
      _db.collection(collectionProduct).where(productFeatured, isEqualTo:true).snapshots();

  static Stream<DocumentSnapshot<Map<String,dynamic>>> getOrderConstants()=>
      _db.collection(collectionSettings)
          .doc(documentOrderConstant)
          .snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllTableValue()=>
      _db.collection(collectionTable).snapshots();

  static Future<DocumentSnapshot<Map<String,dynamic>>> getOrderConstants2()=>
      _db.collection(collectionSettings).doc(documentOrderConstant).get();

  static Stream<DocumentSnapshot<Map<String,dynamic>>> getProductById(String id)=>
      _db.collection(collectionProduct).doc(id).snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getProductByPriceVariation(String id)=>
      _db.collection(collectionProduct).doc(id).collection(collectionDiversSelection).snapshots();

  static Future<void> addToCart (CartModel cartModel,String uid) =>
      _db.collection(collectionUsers).doc(uid)
          .collection(collectionCart)
          .doc(cartModel.productId)
          .set(cartModel.toMap());

  static Future<void> removeFromCart (String pid,String uid) =>
      _db.collection(collectionUsers).doc(uid)
          .collection(collectionCart)
          .doc(pid)
          .delete();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getCartByUser(String uid) =>
      _db.collection(collectionUsers)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>>getOrderRequestDetails (
      String uid) =>
      _db.collection(collectionUsers)
          .doc(uid)
          .collection(collectionOrderRequest)
          .snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getOrderRequestByCart(
      String uid,
      String ordId) =>
      _db.collection(collectionUsers)
          .doc(uid)
          .collection(collectionOrderRequest)
          .doc(ordId)
          .collection(collectionOrderDetails)
          .snapshots();

  static Future<void>addNewOrderPaymentProcess(
      OrderPaymentModel orderPaymentModel,
      List<CartModel> cartList,
      String ordRequestId
      ){
    final wb = _db.batch();
    final orderPaymentDoc = _db.collection(collectionOrder).doc();
    orderPaymentModel.paymentId = orderPaymentDoc.id;
    wb.set(orderPaymentDoc, orderPaymentModel.toMap());
    final orderRequestDoc = orderPaymentDoc.collection(collectionOrderRequest)
        .doc(ordRequestId);
    for(var cartM in cartList){
      final cartDoc = orderRequestDoc.collection(collectionOrderDetails)
          .doc(cartM.productId);
      wb.set(cartDoc, cartM.toMap());
    }
    return wb.commit();
  }

  static Future<void> addNewOrderRequest(
      OrderRequestModel orderRequestModel,
      List<CartModel> cartList,
      String uid){
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionUsers)
        .doc(uid)
        .collection(collectionOrderRequest)
        .doc();
    orderRequestModel.orderId = orderDoc.id;
    wb.set(orderDoc, orderRequestModel.toMap());
    for(var cartM in cartList){
      final cartDoc = orderDoc.collection(collectionOrderDetails)
          .doc(cartM.productId);
      wb.set(cartDoc, cartM.toMap());
    }
    return wb.commit();
  }

  static Future<void> updateProductStock (List<CartModel> cartList){
    final wb = _db.batch();
    for(var carM in cartList) {
      final productDoc = _db.collection(collectionProduct).doc(carM.productId);
      wb.update(productDoc, {productStock: (carM.stock - carM.quantity)});
    }
    return wb.commit();
  }


  static Future<void> updateCategoryProductCount (List<CategoryModel> catList,List<CartModel> cartList){
    final wb = _db.batch();
    for(var cartM in cartList){
      final catModel = catList.firstWhere((element) => element.name == cartM.category);
      final catDoc = _db.collection(collectionCategory).doc(catModel.id);
      wb.update(catDoc, {categoryProductCount: (catModel.productCount - cartM.quantity)});
    }
    return wb.commit();
  }

  static Future<void> clearAllCartItems(String uid, List<CartModel> cartList){
    final wb = _db.batch();
    final userDoc = _db.collection(collectionUsers).doc(uid);
    for(var cartM in cartList){
      final cartDoc = userDoc.collection(collectionCart).doc(cartM.productId);
      wb.delete(cartDoc);
    }
    return wb.commit();
  }

  static Future<QuerySnapshot<Map<String,dynamic>>> getLastOrderId(String uid) =>
    _db.collection(collectionUsers).doc(uid).collection(collectionOrderRequest)
      .orderBy('orderDate.timestamp', descending: true)
      .limit(1).get();

  static Future<void> updateCartQuantity (String pid,String uid,num quantity) =>
      _db.collection(collectionUsers).doc(uid)
          .collection(collectionCart)
          .doc(pid)
          .update({cartProductQuantity : quantity});

  static Future<void> updateOrderRequest(
      OrderRequestModel orderRequestModel,
      List<CartModel> cartList,
      String uid ,
      String ordId){
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionUsers)
        .doc(uid)
        .collection(collectionOrderRequest)
        .doc(ordId);
    orderRequestModel.orderId = orderDoc.id;
    wb.set(orderDoc, orderRequestModel.toMap());
    for(var cartM in cartList){
      final cartDoc = orderDoc.collection(collectionOrderDetails).doc(cartM.productId);
      wb.set(cartDoc, cartM.toMap());
    }
    return wb.commit();
  }
}