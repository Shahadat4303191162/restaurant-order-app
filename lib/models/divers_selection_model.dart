const String diverseSelectionId = 'id';
const String diverseSelectionProductId = 'productId';
const String diverseSelectionSize = 'size';
const String diverseSelectionSalePrice = 'salePrice';
const String diverseSelectionPurchasePrice = 'purPrice';

class DiverseSelectionModel {
  String? id, productId, size;
  num salePrice, purPrice;

  DiverseSelectionModel(
      {this.id,
      this.productId,
      this.size,
      required this.salePrice,
      required this.purPrice});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      diverseSelectionId: id,
      diverseSelectionProductId: productId,
      diverseSelectionSize: size,
      diverseSelectionSalePrice: salePrice,
      diverseSelectionPurchasePrice: purPrice,
    };
  }

  factory DiverseSelectionModel.fromMap(Map<String, dynamic> map) {
    return DiverseSelectionModel(
        id: map[diverseSelectionId],
        productId: map[diverseSelectionProductId],
        size: map[diverseSelectionSize],
        salePrice: map[diverseSelectionSalePrice],
        purPrice: map[diverseSelectionPurchasePrice]);
  }
}
