import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/product_item_two.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid({Key? key, required this.showFavorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: showFavorites
          ? _firestore
              .collection('products')
              .where('isFavorite', arrayContains: _auth.currentUser!.uid)
              .snapshots()
          : _firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        List<ProductItemTwo> productItems = [];

        Widget _results = const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: snapshot.hasError
                  ? const Text(
                      'Oops! Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Column(
                      children: const [
                        Text('Fetching data'),
                        CircularProgressIndicator()
                      ],
                    ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return _results;
        }

        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          final docs = snapshot.data!.docs;

          for (var doc in docs) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

            final productId = data['id'];
            final title = data['title'];
            final description = data['description'];
            final price = data['price'];
            final imageUrl = data['imageUrl'];
            final List? isFavoriteIdList =
                data['isFavorite'] == false ? null : data['isFavorite'];

            final docId = doc.reference.id;

            final isFavorite = Provider.of<Auth>(context, listen: false)
                .isFavorite(isFavoriteIdList);

            final item = ProductItemTwo(
              title: title,
              productId: productId,
              description: description,
              imageUrl: imageUrl,
              isFavorite: isFavorite,
              isFavoriteIdList: isFavoriteIdList,
              price: price,
              docId: docId,
            );

            productItems.add(item);
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: productItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2, //height
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) =>
                //its passing through data of Product
                productItems[index],
          );
        }
        return _results;
      },
    );
  }
}
