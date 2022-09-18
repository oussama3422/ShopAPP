
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'product.dart';
import 'package:http/http.dart' as http;



class ContollerProduct with ChangeNotifier{

 
  String? authToken;
  List<Product> productsList=[];

  getData(String authToKn,List<Product> prodList){
   authToken=authToKn;
   prodList=productsList;
   notifyListeners();
   
  }
  
  List<Product> products=[];

  findById(String? id){
   return products.indexWhere((prod) => prod.id==id);
  }



  Future<void> fetchData()async{
  try{
   var url='https://fir-app-aee08-default-rtdb.firebaseio.com/product.json?auth=$authToken';

   final res  = await http.get(Uri.parse(url));

   var extractData=json.decode(res.body);

   var itemIsExists;
   
   extractData.forEach((prodId,prodItem)=>{
    itemIsExists = products.firstWhere((item) => item.id==prodId),
    if(itemIsExists==null){
    products.add(
    Product(
      id:prodId ,
      productName:prodItem['productName'] ,
      price:prodItem['price'] ,
      imageUrl: prodItem['imgUrl'],
      ),
      ),
    }
   });
 }catch(error)
 {
   print("error :::> $error");
 }
    notifyListeners();
  }
Future<void> addProduct(Product addProduct)async{
 try{
  var url='https://fir-app-aee08-default-rtdb.firebaseio.com/product.json?auth=$authToken';
  http.Response res=await http.post(
    Uri.parse(url),
    body:json.encode({
    'id':addProduct.id,
    'productName':addProduct.productName,
    'price':addProduct.price,
    'imgUrl':addProduct.imageUrl,
   }));
   products.add(
    Product(
      id:json.decode(res.body)['name'],
      productName: addProduct.productName,
      price: addProduct.price,
      imageUrl: addProduct.imageUrl,
      )
      );
  notifyListeners();
 }catch(error){
  rethrow;
 }
  }
  // delete Product
  Future<void> deleteProduct(String id)async{
   
  try{
  
  var index=products.indexWhere((element) => element.id==id);
  
  var url='https://fir-app-aee08-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken';
  
  final res = await http.delete(Uri.parse(url));
    
  products.removeAt(index);
  
  // final prodItem=products[index];

  notifyListeners();
  
  // if(res.statusCode>400)
  // {
  //   products.insert(index, prodItem);
  //   notifyListeners();
  // }

 }catch(err){
   rethrow;
 }
  
}



  // update product New Method
  Future<void> updateProduct(String id,Product newProduct)async{

    final indexproduct=products.indexWhere((product) =>product.id==id);

    var url='https://fir-app-aee08-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken';

    await http.patch(Uri.parse(url),body:json.encode({
    'id':newProduct.id,
    'productName':newProduct.productName,
    'price':newProduct.price,
    'imgUrl':newProduct.imageUrl,
    }));
    products[indexproduct]=newProduct;
    // print(res.statusCode);
  notifyListeners();
}



}