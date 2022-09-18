
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'product_controller.dart';
import 'package:provider/provider.dart';

import '../product.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});
 
  static const routeName='edit-screen';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {



    final imageUrlEditingController=TextEditingController();


    final formkey=GlobalKey<FormState>();

    String? nameprudct;
    String? urlImg;
    double? price;


    var isLoading=false;
    //:::::::::::::::::Update IMage Url:::::::::::::::
  // upadteImageUrl() {
  // if(!ImageUrlFocusNode.hasFocus)
  // {
  //   if(
  //     (imageUrlEditingController.text.startsWith('http')&& imageUrlEditingController.text.startsWith('https')) 
  //     || 
  //     (imageUrlEditingController.text.endsWith('.png') || imageUrlEditingController.text.endsWith('.jpg') || imageUrlEditingController.text.endsWith('.jpeg'))
  //     )
  //     {
  //       setState(() {});
  //     }
  //     return;
     
  // }

  // }

  // Future<void> saveForm()async{
    
  //   Provider.of<ContollerProduct>(context).updateProduct(productId.toString(),loadedproduct);
  //   setState(() {
  //     isLoading=true;
  //   });
  //   Navigator.of(context).pop();
  // }
  

  //    @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if(isInit )
  //     {
  //        var productId=ModalRoute.of(context)!.settings.arguments;
  //        if(productId!=null)
  //        {
  //         editProduct=Provider.of<ContollerProduct>(context).findById(productId.toString());
  //         initailValue={
  //                 'productName': editProduct.productName.toString(),
  //                 'price':editProduct.price!, 
  //                 'imgUrl':'',
  //            };
  //            imageUrlEditingController.text=editProduct.imageUrl!;
  //        }
  //        isInit=false;
  //     }
    
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   ImageUrlFocusNode.addListener(()=>upadteImageUrl());
  // }
  // @override
  // void dispose() {
  //   super.dispose();
  //   imageUrlEditingController.dispose();
  //   ImageUrlFocusNode.removeListener(() => upadteImageUrl());
  //   priceFocusNode.dispose();
  //   imageUrlEditingController.dispose();
  //   descreptionFocusNode.dispose();
  // }

 @override
  Widget build(BuildContext context) {
    var productId=ModalRoute.of(context)!.settings.arguments.toString();
    // var loadedproduct=Provider.of<ContollerProduct>(context).findById(productId.toString());
    var value=Provider.of<ContollerProduct>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditProductScreen'),
        actions: [
          IconButton(
            onPressed: (){
            final isValid=formkey.currentState!.validate();
            if(!isValid){return;}
            formkey.currentState!.save();
            value.updateProduct(
              productId.toString(),
              Product(
                id: productId,
                productName: nameprudct,
                price: price,
                imageUrl: urlImg,
                )
                );
              Navigator.of(context).pop();
          },
          icon:const Icon(Icons.save_as))
        ],
        ),
        body: isLoading?const Center(child: CircularProgressIndicator(color:Colors.purple)):Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('productName'),
                    ),
                  textInputAction: TextInputAction.next,
                  validator: (val){
                    if(val!.isEmpty){return 'Please Sould contain value';}return null;
                  },
                  onSaved: (val){
                    setState(() {
                     nameprudct=val;
                    });
                      },
                ),
                //price TextFormField
                 TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Price'),
                    ),
                  textInputAction: TextInputAction.next,
                  keyboardType:TextInputType.number ,
                  validator: (val){
                    if(val!.isEmpty){
                      return 'Please Sould contain a valid price';
                    }
                    if(double.tryParse(val) == null){
                             return 'Please enter a valid number';
                    }
                    if(double.parse(val) <= 0){
                             return 'Please enter a number grether than 0';
                    }
                    return null;
                  },
                  onSaved: (val){
                  setState(() {
                    price = double.parse(val!);
                  });
                      },
                ),
                Row(
                  crossAxisAlignment:CrossAxisAlignment.end,
                  children: [
                    Container(
                     width: 100,
                     height:100,
                     margin:const EdgeInsets.only(top: 8,right:10),
                     decoration: BoxDecoration(
                      border: Border.all(width: 1,color:Colors.grey[800]!),
                     ),
                     child: 
                     imageUrlEditingController.text.isEmpty?const Text("Enter a Url")
                     :
                     FittedBox(
                      child: Image.network(imageUrlEditingController.text)
                     ),
                      ),
                      Expanded(
                        child:TextFormField(
                            controller: imageUrlEditingController,
                            decoration: const InputDecoration(label: Text('url image'),),
                            keyboardType: TextInputType.url,
                             validator: (val){
                               if(val!.isEmpty){
                                      return 'Please Sould contain a valid Url Image';
                                }
                               if(!val.startsWith("http") && !val.startsWith("https")){
                                      return 'Please enter a valid url.';
                                }
                               if(!val.endsWith("png") && !val.endsWith("jpg") && val.endsWith("jpeg")){
                                      return 'Please enter a valid url.';
                                 }
                            return null;
                          },
                          onSaved: (val){
                            setState(() {
                              urlImg=val;
                            });
                            },
                        ) ,
                        )
                  ],
                )  
              ],
            ),
            ),
          ),
    );
  }
  
  }