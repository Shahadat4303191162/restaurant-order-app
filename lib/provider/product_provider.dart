
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../db/dbhelper.dart';
import '../models/category_model.dart';
import '../models/divers_selection_model.dart';
import '../models/product_model.dart';
import '../models/table_number_model.dart';

class ProductProvider extends ChangeNotifier{

  List<ProductModel> productList = []; //collection
  List<ProductModel> featuredProductList = []; //collection
  List<CategoryModel> categoryList = [];
  List<DiverseSelectionModel> priceVariationList = [];
  List<String> categoryNameList = [];
  List<TableModel> tableList = [];


  //category section start
  getAllCategories(){
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length, (index) =>
      CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryNameList = List.generate(categoryList.length, (index) => categoryList[index].name!);
      categoryNameList.insert(0, 'All');
      notifyListeners();
    });
  }

  //category section end

  CategoryModel getCategoryByName (String name){
    final model = categoryList.firstWhere((element) => element.name == name);
    return model;
  }

  getAllTableValue(){
    DbHelper.getAllTableValue().listen((snapshot) {
      tableList = List.generate(snapshot.docs.length, (index) =>
          TableModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  bool tableNumberExists(num existed){
    bool tag = false;
    for (var table in tableList){
      if(table.tableNumber == existed){
        tag = true;
        break;
      }
    }
    return tag;
  }


  getAllProducts(){
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllFeaturedProducts(){
    DbHelper.getAllFeaturedProducts().listen((snapshot) {
      featuredProductList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(String category){
    DbHelper.getAllProductsByCategory(category).listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getProductByPriceVariation(String id){
    DbHelper.getProductByPriceVariation(id).listen((snapshot) {
      priceVariationList = List.generate(snapshot.docs.length, (index) =>
          DiverseSelectionModel.fromMap(snapshot.docs[index].data())
      );
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot<Map<String,dynamic>>> getProductById(String id) =>
  DbHelper.getProductById(id);


 }
