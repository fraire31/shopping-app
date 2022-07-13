import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../screens/orders_screen.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String pageId = 'cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    child: Text(
                      'Order now',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.cartItems.values.toList(),
                        cart.totalAmount,
                      );
                      Navigator.of(context).pushNamed(OrdersScreen.pageId);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Order has been successfully processed.'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'okay',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                      cart.clear();
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => CartItem(
                id: cart.cartItems.values.toList()[index].id,
                productId: cart.cartItems.keys.toList()[index],
                price: cart.cartItems.values.toList()[index].price,
                quantity: cart.cartItems.values.toList()[index].quantity,
                title: cart.cartItems.values.toList()[index].title,
              ),
              itemCount: cart.cartItems.length,
            ),
          )
        ],
      ),
    );
  }
}
