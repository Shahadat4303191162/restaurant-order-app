const String tableId = 'id';
const String tablename = 'name';
const String tablenumber = 'number';
const String tableAvailable = 'available';


class TableModel{
  String? id,tableName;
  num tableNumber;
  bool available;

  TableModel({
    this.id,
    this.tableName,
    required this.tableNumber,
    this.available = true });


  Map<String,dynamic>toMap(){
    return<String,dynamic>{
      tableId : id,
      tablename: tableName,
      tablenumber : tableNumber,
      tableAvailable : available,
    };
  }

  factory TableModel.fromMap(Map<String,dynamic>map){
    return TableModel(
        id: map[tableId],
        tableName: map[tablename],
        available: map[tableAvailable],
        tableNumber: map[tablenumber]
    );
  }
}