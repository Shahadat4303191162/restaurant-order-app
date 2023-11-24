const String categoryId = 'id';
const String categoryName = 'name';
const String categoryImageUrl = 'imageUrl';
const String categoryProductCount = 'productCount';
const String categoryAvailable = 'available';


class CategoryModel{
  String? id,name,imageUrl;
  num productCount;
  bool available;

  CategoryModel({
    this.id,
    this.name,
    this.imageUrl,
    this.productCount = 0,
    this.available = true });


  Map<String,dynamic>toMap(){
    return<String,dynamic>{
      categoryId : id,
      categoryName: name,
      categoryImageUrl : imageUrl,
      categoryProductCount : productCount,
      categoryAvailable : available,
    };
  }

  factory CategoryModel.fromMap(Map<String,dynamic>map){
    return CategoryModel(
      id: map[categoryId],
      name: map[categoryName],
      imageUrl: map[categoryImageUrl],
      available: map[categoryAvailable],
      productCount: map[categoryProductCount]
    );
  }
}