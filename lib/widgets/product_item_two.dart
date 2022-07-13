import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

final CollectionReference products =
    FirebaseFirestore.instance.collection('products');

class ProductItemTwo extends StatelessWidget {
  final String title;
  final String productId;
  final String description;
  final String imageUrl;
  final bool isFavorite;
  final double price;
  final String docId;
  final List? isFavoriteIdList;

  const ProductItemTwo({
    Key? key,
    required this.title,
    required this.productId,
    required this.description,
    required this.imageUrl,
    required this.isFavorite,
    this.isFavoriteIdList,
    required this.price,
    required this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.pageId,
              arguments: productId,
            );
          },
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            errorWidget: (context, url, error) {
              return Container(
                  color: Colors.grey.shade400, child: const Icon(Icons.error));
            },
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              //if favorite is true we are removing it.
              final updatedList =
                  auth.updateFavoriteList(isFavoriteIdList, isFavorite);

              await products
                  .doc(docId)
                  .update({'isFavorite': updatedList}).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    isFavorite
                        ? 'Removed from Favorites'
                        : 'Added to favorites',
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'okay',
                      textColor: Colors.red,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      }),
                ));
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('unable to add to favorites'),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                      label: 'okay',
                      textColor: Colors.red,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      }),
                ));
              });
            },
          ),
          backgroundColor: Colors.black87,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addItem(productId, price, title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Item has been added to cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'undo',
                    onPressed: () {
                      cart.removeSingleItem(productId);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
