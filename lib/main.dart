import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/Provider/favorite_provider.dart';
import 'package:recipe/Provider/quantity.dart';
import 'package:recipe/Views/app_main_screen.dart';
import 'package:recipe/Views/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //for favorite provider
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        //for quantity provider
        ChangeNotifierProvider(create: (_) => QuantityProivder()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignUpScreen(),
      ),
    );
  }
}
