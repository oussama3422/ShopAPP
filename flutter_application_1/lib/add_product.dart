
import 'package:flutter/material.dart';
import 'product_controller.dart';
import 'product.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
   AddProduct({super.key});

   static const routeName='add-product';
   
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? product;

  double? price;

  String? imgUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:AppBar(title: const Text('Add Product'),centerTitle: true,),
    body:Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(label: Text('Product'),hintText: 'Enter Prouct Name'),
          onChanged: (newVal){
            setState(() {
              product = newVal;
            });
              // print(product);
            },
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text('Price'),hintText: 'Enter Price'),
            onChanged: (newVal){
              setState(() {
              price = double.parse(newVal);
              });
              // print(price);
            },
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text('UrlImage'),hintText: 'Enter Url Image'),
            onChanged: (newVal){
              setState(() {
              imgUrl = newVal;
              });
              // print(imgUrl);
            },
          ),
          ElevatedButton(
              onPressed: (){
                if(imgUrl!.isEmpty && price==null && imgUrl!.isEmpty)
                {

                  // return;
                  // const SnackBar(content: Text('Some of the field is Empty'));
                 const AlertDialog(title: Text('Error Accurred'),content:Text('some field is Empty') );
                  return;
                }
                try{
                  Provider.of<ContollerProduct>(context,listen: false).addProduct(
                  Product(id:DateTime.now().toString(), productName: product!, price: price!, imageUrl: imgUrl!)
                  );
                }catch(error)
                {
                  SnackBar(content: Text('Error Occured $error'));
                }
                Navigator.of(context).pop();
              },
              child: const Text("Add Product"),
              )
        ],
      ),
     ),
    );
  }
}