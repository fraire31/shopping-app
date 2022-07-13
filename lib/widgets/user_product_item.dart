import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repositories/product_repo.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductRepo productRepo = ProductRepo();

    return Card(
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            errorWidget: (context, url, error) {
              return const Icon(
                Icons.error,
                color: Colors.black45,
              );
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
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.pageId, arguments: id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        content: const Text(
                            'Are you sure you want to delete product?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await productRepo.deleteProduct(id).catchError(
                                (error) {
                                  final e = error as FirebaseException;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.message.toString()),
                                      duration: const Duration(seconds: 3),
                                      action: SnackBarAction(
                                          label: 'okay',
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                          }),
                                    ),
                                  );
                                },
                              );
                              Navigator.of(context).pop();
                              //showDialog returns a future, and is resolved
                              //by returning this .pop()
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
