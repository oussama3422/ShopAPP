
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'add_product.dart';
import 'dark_theme_provider.dart';
import 'detail_screen.dart';
import 'edit_screen.dart';
import 'product_controller.dart';


class MyHomePage extends StatefulWidget {

  MyHomePage({super.key});



  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  bool isLoading=true;
  

  @override
  void initState() {
    super.initState();
     Provider.of<ContollerProduct>(context,listen: false).fetchData().then((value) =>isLoading=false);
      // setState(() {
      //   isLoading=false;
      // });
  }

  @override
  Widget build(BuildContext context) {
   final themeChange = Provider.of<DarkThemeProvider>(context);

    var prod=Provider.of<ContollerProduct>(context,listen: true).products;
    var logout=Provider.of<Auth>(context,listen: false);
    // var productId=ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Screen'),
        centerTitle: true,
        leading:FlutterSwitch(
          activeColor: Colors.grey,
          inactiveColor: Colors.blue,
          inactiveIcon:const Icon(Icons.sunny,color:Colors.yellow),
          activeIcon: const Icon(Icons.dark_mode,color: Colors.purple,),
          height: 30,
          valueFontSize: 10,
          value: themeChange.darkTheme,
            onToggle: (newVal) {
              themeChange.darkTheme=newVal;
              }
          ),
        actions: [
          IconButton(
            onPressed: ()=>logout.logout(),
            icon:const Icon(Icons.logout,color: Colors.red,))
          ],
          ),
      body: isLoading?
       const Center(child: CircularProgressIndicator(color: Colors.purple,),)
       :
       prod.isEmpty?const Center(child: Text('There No product yet',style: TextStyle(fontSize: 18,color: Colors.purple,fontWeight: FontWeight.bold),),)
      :
      
      RefreshIndicator(
         onRefresh: () async{
                 await Provider.of<ContollerProduct>(context,listen: false).fetchData();
                },
        child: ListView.builder(
            itemCount: prod.length,
            itemBuilder: (context, index) =>InkWell(
              child:Card(
                  margin: const EdgeInsets.all(20),
                  elevation: 4,
                  child: 
                    // subtitle: Text('${prod[index].productName}',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[600]),textAlign: TextAlign.center,),
                     Column(
                      children:[
                     Image.network(prod[index].imageUrl.toString(),height: 200,width: 460,),
                      const SizedBox(height: 20),
                      Text('${prod[index].productName}',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[600]),textAlign: TextAlign.center,),
                      const SizedBox(height: 20),
                      Text('${prod[index].price} \$',style:TextStyle(fontSize: 40,fontWeight: FontWeight.w900,color: Colors.grey[900]),textAlign: TextAlign.center,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                                Provider.of<ContollerProduct>(context,listen:false).deleteProduct(prod[index].id!);
                                Fluttertoast.showToast(
                                    msg: "Deleted Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: const Color.fromARGB(255, 54, 244, 60),
                                    textColor: Colors.white,
                                    fontSize: 16.0
                              );
                            //  print("The product has been deleted ");
                            },
                            icon: const Icon(Icons.delete,size: 40,color: Colors.red,)
                            ),
                            IconButton(
                              onPressed: ()=>{
                                // Provider.of<ContollerProduct>(context,listen:false).updateProduct(prod[index].id!, Product(id: '12-10-2022',productName: 'fleep',price: 33,imageUrl: 'https://www.mouse.com')),
                                 Navigator.of(context).pushNamed(EditScreen.routeName,arguments: prod[index].id),
                              },
                              icon: const Icon(Icons.update,size: 40,color: Color.fromARGB(255, 65, 249, 132),)
                               )
                        ],
                      ),
                      ]
                     
                  ),
                ),
              
              onTap: (){
                Navigator.of(context).pushNamed(DetailScreen.routeName);
              },
            ) ,
            ),
      ),
      
      floatingActionButton: ElevatedButton(
        onPressed: ()=>Navigator.of(context).pushNamed(AddProduct.routeName),
        child: const Text("Add Product"),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
