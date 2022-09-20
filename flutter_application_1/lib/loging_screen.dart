import 'package:flutter/material.dart';
import 'auth_service.dart';


//welcome text
class LogingScreen extends StatelessWidget {
  const LogingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text("Hello, \nWelcome, login with,",
      style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 12,)
     ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
				// Gesture detector for facebook Login
                GestureDetector(
                    onTap: () {
						// Call facebook login methon
                        AuthService().signInWithFacebook();
                    },
                    child: Image(width: 50, image: AssetImage('assets/icons/facebook.png')),
                ),
                SizedBox(width: 50),
				// Gesture detector for the Google icon
                GestureDetector(
                    onTap: () {
					// Call the a method to sign in with Google
                    AuthService().signInWithGoogle();
                    },
                    child: Image(width: 55, image: AssetImage('assets/icons/google.png'))
                ),
            ],
        ),
    ],
     ) ,
    );
  }
}

