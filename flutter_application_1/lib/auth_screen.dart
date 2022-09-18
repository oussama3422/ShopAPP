import 'dart:math';
import 'package:flutter/material.dart';
import 'auth_card.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var device=MediaQuery.of(context).size;
    return Scaffold(
     body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            gradient: LinearGradient(
              colors: [
             const Color.fromARGB(255, 20, 171, 246).withOpacity(0.5),
             const Color.fromARGB(255, 12, 238, 250).withOpacity(0.9),
            ]
            )
          ),
        ),
        SingleChildScrollView(
          child: Container(
            width: device.width,
            margin: const EdgeInsets.only(top: 30),
            child: Container(
              height: device.height,
              width: device.width,
              padding: const EdgeInsets.all(7),
              margin:  const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                       margin: const EdgeInsets.only(bottom: 20),   
                       padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                       transform: Matrix4.rotationZ(-8*pi/180),
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlueAccent,
                        boxShadow: const[
                                BoxShadow(blurRadius: 20,color: Colors.grey,offset: Offset(0, 0)),
                        ]
                       ),
                       child: const Text(
                        "Shop Movic",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 50,
                          fontFamily: 'FiraCode',
                        ),
                        ),
                      ),
                    ),
                   const Flexible(flex:6 ,child:  AuthCard()),
                ],
              ),
              ),
          ),
        ),
      ]
      ),
    );
  }
}
