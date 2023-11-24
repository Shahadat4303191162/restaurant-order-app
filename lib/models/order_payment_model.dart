
import 'package:order_app_for_resturent/models/data_model.dart';

const String paymentIDKey = 'paymentId';
const String userIDKey = 'userId';
const String orderPaymentDateKey = 'orderPaymentDate';
const String orderPaymentMethodKey = 'paymentMethod';
const String orderDiscountKey = 'discount';
const String orderVatKey = 'vat';
const String orderGrandTotalKey = 'grandTotal';

class OrderPaymentModel{
  String? paymentId,userId;
  String paymentMethod;
  num discount,vat,grandTotal;
  DateModel paymentDate;

  OrderPaymentModel(
      {
        this.paymentId,
        this.userId,
        required this.paymentMethod,
        required this.discount,
        required this.vat,
        required this.grandTotal,
        required this.paymentDate
      });

  Map<String, dynamic> toMap(){
    return <String, dynamic> {
      paymentIDKey : paymentId,
      userIDKey : userId,
      orderPaymentDateKey : paymentDate.toMap(),
      orderPaymentMethodKey : paymentMethod,
      orderDiscountKey : discount,
      orderVatKey : vat,
      orderGrandTotalKey : grandTotal,
    };
  }

  factory OrderPaymentModel.fromMap(Map<String, dynamic>map){
    return OrderPaymentModel(
        paymentId: map[paymentIDKey],
        userId: map[userIDKey],
        paymentMethod: map[orderPaymentMethodKey],
        discount: map[orderDiscountKey],
        vat: map[orderVatKey],
        grandTotal: map[orderGrandTotalKey],
        paymentDate: DateModel.fromMap(map[orderPaymentDateKey])
    );
  }
}