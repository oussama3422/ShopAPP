import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles.dart';
import 'auth_screen.dart';
import 'dark_theme_provider.dart';
import 'home_page.dart';
import 'product_controller.dart';
import 'splash_screen.dart';
import 'package:provider/provider.dart';
import 'add_product.dart';
import 'auth.dart';
import 'detail_screen.dart';
import 'edit_screen.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
     MyApp(),
  );
}



class MyApp extends StatefulWidget {

   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

@override
void initState() {
  super.initState();
  getCurrentAppTheme();
}

void getCurrentAppTheme() async {
  themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
}

  @override
  Widget build(BuildContext context) {
    return  
     MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeProvider>(
          create: (_)=>themeChangeProvider,
        ),
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth() ,
          ),
       ChangeNotifierProxyProvider<Auth,ContollerProduct>(
        create: (ctx) =>ContollerProduct() ,
        update: (ctx,auth,previousList) => previousList!..getData(auth.gettoken, previousList.productsList) ,
        ),
      ],
    child:Consumer2<Auth,DarkThemeProvider>(
      builder:(ctx,auth,darkTheme,_)=>MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:Styles.themeData(themeChangeProvider.darkTheme, context),
      home:auth.isAuth?  MyHomePage(): FutureBuilder(
        future: auth.tryautoLogin(),
        builder:(BuildContext ctx,snapshot)=>
           snapshot.connectionState == ConnectionState.waiting?
            SplashScreen() 
            :
            const AuthScreen(),
        ),
      routes: {
        AddProduct.routeName:(context) => AddProduct(),
        DetailScreen.routeName:(context)=>const DetailScreen(),
        EditScreen.routeName:(context)=>const EditScreen(),
      },
     ),
    ),
    );
  }
}
