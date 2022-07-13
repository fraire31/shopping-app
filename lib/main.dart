import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './firebase_options.dart';
import './helpers/custom_route.dart';
import './screens/edit_product_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../screens/home_screen.dart';
import '../screens/orders_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => Products(),
        // value: Products(),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Shop',
            theme: ThemeData(
                fontFamily: 'Lato',
                textTheme: const TextTheme(
                  bodyText1: TextStyle(
                    fontFamily: 'Anton',
                  ),
                ),
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                ),
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  // TargetPlatform.android:,
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                })),
            initialRoute: HomeScreen.pageId,
            routes: {
              ProductsOverviewScreen.pageId: (context) =>
                  const ProductsOverviewScreen(),
              HomeScreen.pageId: (context) => const HomeScreen(),
              ProductDetailScreen.pageId: (context) =>
                  const ProductDetailScreen(),
              CartScreen.pageId: (context) => const CartScreen(),
              OrdersScreen.pageId: (context) => const OrdersScreen(),
              UserProductsScreen.pageId: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.pageId: (context) => const EditProductScreen()
            },
          ),
        ),
      ),
    );
  }
}
