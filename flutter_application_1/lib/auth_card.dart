
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/http_exception.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'auth.dart';


class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}
enum AuthMode{login,signUp}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _formKey=GlobalKey();
  
  String pickedImage='';


  AuthMode authMode=AuthMode.login;

  Map<String,String> authData={
    'email':'',
    'password':'',
  };
  bool isLoading=false;

  final passwordConroller=TextEditingController();

  AnimationController? controller;
  Animation<Offset>? sliderAnimation;
  Animation<double>? opacityAnimation;

  @override
  void initState() {
    controller=AnimationController(vsync:this,duration: const Duration(milliseconds: 300));
    sliderAnimation=Tween<Offset>(begin: const Offset(0,-0.15),end: const Offset(0,0)).animate(CurvedAnimation(parent: controller!,curve: Curves.fastOutSlowIn));
    opacityAnimation=Tween<double>(begin: 1.0,end: 0.0).animate(CurvedAnimation(parent: controller!,curve: Curves.easeIn));
    super.initState();
  }
  
  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  Future<void> submit()async{
 if(!_formKey.currentState!.validate()){
   return;
 }
 if(pickedImage=='')
 {
    Fluttertoast.showToast(
        msg: 'Please Image filled is Required',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
 }
 FocusScope.of(context).unfocus();
 _formKey.currentState!.save();
 setState(() {
   isLoading=true;
 });
 try{
  if(authMode==AuthMode.login){
    await Provider.of<Auth>(context,listen: false).singIn(authData['email']!, authData['password']!);
  }else{
    await Provider.of<Auth>(context,listen: false).singUp(authData['email']!, authData['password']!);
  }

 }on HttpException catch(error){
    var errorMessage='Authentication Failed';
   if(error.toString().contains('EMAIL_EXISTS')){
      errorMessage= 'this email address is Already in use.';
   }
   else if(error.toString().contains('INVALID_EMAIL')){
      errorMessage= 'this is not  a valid email address.';
   }
   else if(error.toString().contains('WEAK_PASSWORD')){
      errorMessage= 'this password is too weak.';
   }
   else if(error.toString().contains('EMAIL_NOT_FOUND')){
      errorMessage= 'we could not found user match this email.';
   }
   else if(error.toString().contains('INVALID_PASSWORD')){
      errorMessage= 'Invalid Password.';
   }
   Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
 }catch(error)
 {
   Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
 }
 setState(() {
   isLoading=false;
 });
  }

  // :::::::::switch Authentication Method::::::::::
  void swicthAuthMode(){
    if(authMode==AuthMode.login)
    {
      setState(() {
        authMode=AuthMode.signUp;
      });
    }else{
      setState(() {
        authMode=AuthMode.login;
      });
      controller!.reverse();
    }
  }
  // :::::::::::::show  Dialog ::::::::::::
  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx,)=> AlertDialog(
         title: const Text('An Error Occurred!'),
         content: Text(errorMessage,),
         actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              },
            child: const Text('Okay',style: TextStyle(color: Colors.blueGrey),)
            ),
         ],
      ),
      );
  }
  //::::::::::::::: upload Image:::::::::::::
  
 selectImage(ImageSource source) async {
        try {
          ImagePicker imagePicker = ImagePicker();
          
          XFile? pickedFile = await imagePicker.pickImage(source: source,   imageQuality: 80);

          File? imageFile = File(pickedFile!.path);

          if(imageFile==null) return 'there is no image';

          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    
          final storageRef = FirebaseStorage.instance.ref().child("Picture/").child("pic4");
    
          await storageRef.putFile(imageFile);

          var url=await storageRef.getDownloadURL();

          setState(() {
            pickedImage = url;
          });
          
        } on FirebaseException catch (e) {
          print(e.message);
        }
        
      }
  @override
  Widget build(BuildContext context) {
    final deviceSize=MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          // show the Circle Just In Sin Up Mode
    if(authMode==AuthMode.signUp) CircleAvatar(
                radius: 40,
                backgroundImage:NetworkImage(pickedImage),
                ),
          // show the Circle Just In Sin Up Mode
    if(authMode==AuthMode.signUp) Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               chooseMethod('from Camera',()=>selectImage(ImageSource.camera)),
               chooseMethod('from Gallery',()=>selectImage(ImageSource.gallery)),
            ],
          ),
     
          Card(
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve:Curves.easeIn,
                  height: authMode==AuthMode.signUp?320:260,
                  constraints: BoxConstraints(minHeight: authMode==AuthMode.signUp?320:260),
                  width: deviceSize.width *0.75,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key:_formKey ,
                    child:SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'E-mail'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val){
                              if(val!.isEmpty || !val.contains('@')){
                                return 'Invalid Email';
                              }return null;
                            },
                            onSaved:(val){
                              authData['email']=val!;
                            } 
                          ),
                        
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Password'),
                            controller: passwordConroller,
                            obscureText: true,
                            validator: (val){
                              if(val!.isEmpty || val.length<=5){
                                return 'Password is Too Short';
                              }return null;
                            },
                            onSaved:(val){
                              authData['password']=val!;
                            } 
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            constraints: BoxConstraints(
                              minHeight: authMode==AuthMode.signUp?60:0,
                              maxHeight: authMode==AuthMode.signUp?120:0
                              ),
                              child:SlideTransition(
                                position: sliderAnimation!,
                                child:FadeTransition(
                                  opacity: opacityAnimation!,
                                  child: TextFormField(
                                    enabled: authMode==AuthMode.signUp,
                                      decoration: const InputDecoration(labelText: 'Confirm Password'),
                                      obscureText: true,
                                      validator: authMode==AuthMode.signUp? (val){
                                      if(val!.isEmpty || passwordConroller.text!=val){
                                         return 'password do not matches';
                                      }return null;
                                      }:null
                                  ),
                                ), 
                                ),
                            ),
                          const SizedBox(height: 20),
                          if(isLoading) const CircularProgressIndicator(),
                          ElevatedButton(
                            onPressed: submit,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30,vertical: 8)),
                              // textStyle: 
                            ),
                            child:Text(authMode==AuthMode.login?'LOGIN':'SIGN UP'),
                            ),
                            TextButton(
                              style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.black) ,
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30,vertical: 8)),
                              // textStyle: 
                            ),
                              onPressed: swicthAuthMode,
                              child:Text(authMode==AuthMode.signUp?'LOGIN INSTEAD':'SIGN UP' ' INSTEAD'),
                              ),
                        ],
                      ),
                    ) ,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
  GestureDetector chooseMethod(text,Future<dynamic> Function() onTap) {
    return GestureDetector(
              onTap:onTap,
              child: Text(text,style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
              );
     }
  
}