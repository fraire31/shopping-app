import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/home_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<Auth>(context, listen: false).isAdmin();

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.pushNamed(context, ProductsOverviewScreen.pageId);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushNamed(context, OrdersScreen.pageId);
            },
          ),
          const Divider(),
          if (isAdmin) ...[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.pushNamed(context, UserProductsScreen.pageId);
              },
            ),
            const Divider()
          ],
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              Provider.of<Auth>(context, listen: false).logout().then(
                    (value) => Navigator.pushReplacementNamed(
                      context,
                      HomeScreen.pageId,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
