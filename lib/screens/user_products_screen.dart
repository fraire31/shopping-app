import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './edit_product_screen.dart';
import '../widgets/user_product_item.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UserProductsScreen extends StatelessWidget {
  static const String pageId = 'user-products-screen';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.pageId);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('products').snapshots(),
          builder: (context, snapshot) {
            List<UserProductItem> productItems = [];

            if (!snapshot.hasData) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            final docs = snapshot.data!.docs;

            for (var doc in docs) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

              final productId = data['id'];
              final title = data['title'];
              final imageUrl = data['imageUrl'];

              final item = UserProductItem(
                  id: productId, title: title, imageUrl: imageUrl);

              productItems.add(item);
            }

            return Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: [
                  ...productItems,
                ],
              ),
            );
          },
        ),
      ),

      // body: Padding(
      //   padding: EdgeInsets.all(8),
      //   child: ListView.builder(
      //     itemBuilder: (_, index) => Column(
      //       children: [
      //         UserProductItem(
      //           productsData.items[index].id,
      //           productsData.items[index].title,
      //           productsData.items[index].imageUrl,
      //         ),
      //         const Divider(),
      //       ],
      //     ),
      //     itemCount: productsData.items.length,
      //   ),
      // ),
      //
    );
  }
}
