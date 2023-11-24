

const String productId = 'id';
const String productName = 'name';
const String productCategory = 'category';
const String productShortDescription = 'shortDescription';
const String productLongDescription = 'longDescription';
const String productThumbnailImage = 'thumbnailImageUrl';
const String productStock = 'stock';
const String productSalesPrice = 'salesPrice';
const String productRatingCount = 'ratingCount';
const String productPriceDiscount = 'productDiscount';
const String productRating = 'rating';
const String productFeatured = 'featured';
const String productAvailable = 'available';

class ProductModel{
  String? id,name,category,shortDescription,thumbnailImageUrl,longDescription;
  num stock,ratingCount,productDiscount,salesPrice;
  double rating;
  bool featured,available;

  ProductModel(
      {this.id,
      this.name,
      this.category,
      this.shortDescription,
      this.thumbnailImageUrl,
      this.longDescription,
      required this.salesPrice,
      this.stock = 0,
      this.ratingCount =0,
      this.productDiscount = 0,
      this.rating = 0.0,
      this.featured = true,
      this.available = true,});

  Map<String,dynamic>toMap(){
    return <String,dynamic>{
      productId : id,
      productName : name,
      productCategory : category,
      productShortDescription : shortDescription,
      productThumbnailImage : thumbnailImageUrl,
      productLongDescription : longDescription,
      productStock : stock,
      productSalesPrice : salesPrice,
      productRatingCount : ratingCount,
      productPriceDiscount : productDiscount,
      productRating : rating,
      productFeatured : featured,
      productAvailable : available,

    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map){
    return ProductModel(
        id: map[productId],
        name: map[productName],
        category: map[productCategory],
        shortDescription: map[productShortDescription],
        thumbnailImageUrl: map[productThumbnailImage],
        longDescription: map[productLongDescription],
        stock: map[productStock],
        salesPrice: map [productSalesPrice],
        ratingCount: map[productRatingCount] ?? 0,
        productDiscount: map[productPriceDiscount],
        //rating: map[productRating] ?? 0.0,
        featured: map[productFeatured],
        available: map[productAvailable],

    );
  }
}