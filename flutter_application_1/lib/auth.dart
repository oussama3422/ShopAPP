import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{

String? token;
DateTime? expirydate;

String? userId;
Timer? authTimer;

bool get isAuth{
  return token!=null;
}



String get gettoken{
  if(expirydate!=null && expirydate!.isAfter(DateTime.now()) && token!=null){
    return token! ;
  }
  return '';
}


Future<void> authenticate(String email,String password,String urlSegement)async{

  final url="https://identitytoolkit.googleapis.com/v1/accounts:$urlSegement?key=AIzaSyD2ZMKDABPEh0irCo8zMxE_v0xQV2chfCc";
  
  try{
  final res=await http.post(Uri.parse(url),body: json.encode({
    'email':email,
    'password':password,
    'returnSecureToken':true,
    }));
  var resData=json.decode(res.body);
  if(resData['error']!=null)
    {
        print('${resData['error']['message']}');
    }
  token=resData['idToken'];
  userId=resData['localId'];
  expirydate=DateTime.now().add(Duration(seconds: int.parse(resData['expiresIn'])));
   autoLogout();
 
  final pref=await SharedPreferences.getInstance();
  var prefsData=json.encode({
   'token':token,
   'userId':userId,
   'expirydate':expirydate,
  });
  
  pref.setString("keyautoLogin",prefsData);

  notifyListeners();

}catch(error)
{
  print(error);
}
}
Future<void> singUp(String email,String password)async{
  return  authenticate(email, password, "signUp");

}
Future<void> singIn(String email,String password)async{
  return  authenticate(email, password, "signInWithPassword");
}
//  Logout Method
void logout(){

  token=null;

  expirydate=null;

  userId=null;

  // we check if the timer is not null to cancel it and delete it from memory

   if(authTimer!=null)
  {
    authTimer!.cancel();
    authTimer=null;
  }

  notifyListeners();

}

// auto Logout Method
void autoLogout(){
  if(authTimer!=null)
  {
    authTimer!.cancel();
  }
 // we calcul differnce between Time From Now until end of The Timer.
  final expiryDate=expirydate!.difference(DateTime.now()).inSeconds;
  
  Timer(Duration(seconds: expiryDate),logout);

  notifyListeners();
}

Future<bool> tryautoLogin()async{
  final pref=await SharedPreferences.getInstance();
 
  if(!pref.containsKey('keyautoLogin')){
    return false;
  }
  var extractedData=json.encode(pref.getString('keyautoLogin')) as Map<String,String>;
  // also want to Parse dateTime
  var extractExpiryDate=DateTime.parse(extractedData['expirydate']!);
  if(extractExpiryDate.isBefore(DateTime.now()))
  {
    return false;
  }
  var resData=json.encode({
   'token':extractedData['token'],
   'userId':extractedData['userId'],
   'expirydate':extractExpiryDate,
  });
  pref.setString("keyautoLogin",resData);
  notifyListeners();
  autoLogout();
  return true;
}


}