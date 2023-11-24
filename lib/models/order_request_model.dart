import 'data_model.dart';

const String orderIDKey = 'orderId';
const String userIDKey = 'userId';
const String orderDateKey = 'orderDate';
const String tableNu = 'tableNumber';
const String requestId = 'orderRId';

class OrderRequestModel{
  String? orderId, userId;
  num tableNum;
  DateModel orderDate;

  OrderRequestModel(
      {this.orderId,
        this.userId,
        required this.tableNum,
        required this.orderDate});

  Map<String, dynamic> toMap(){
    return <String, dynamic> {
      orderIDKey : orderId,
      userIDKey : userId,
      tableNu : tableNum,
      orderDateKey: orderDate.toMap(),

    };
  }

  factory OrderRequestModel.fromMap(Map<String, dynamic> map){
    return OrderRequestModel(
      orderId: map[orderIDKey],
      userId: map[userIDKey],
      tableNum: map[tableNu],
      orderDate: DateModel.fromMap(map[orderDateKey]),
    );

  }
}

