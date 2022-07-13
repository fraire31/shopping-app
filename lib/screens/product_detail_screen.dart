import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repositories/product_repo.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String pageId = 'product-detail-screen';

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductRepo productRepo = ProductRepo();

  bool _isInit = true;
  bool _isLoading = true;
  Map? loadedProduct;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;

      productRepo
          .findProductByDocumentId(productId)
          .then((QuerySnapshot snapshot) {
        final docs = snapshot.docs;
        for (var doc in docs) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

          setState(() {
            loadedProduct = {
              'title': data['title'],
              'price': data['price'],
              'description': data['description'],
              'imageUrl': data['imageUrl'],
            };
            _isLoading = false;
          });
        }
      });

      _isInit = false;

      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoading ? '--' : loadedProduct!['title']),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  TweenAnimationBuilder(
                    curve: Curves.easeInExpo,
                    tween: Tween(begin: 50.0, end: 300.0),
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    builder:
                        (BuildContext context, double height, Widget? child) {
                      return SizedBox(
                          height: height,
                          width: double.infinity,
                          child: child!);
                    },
                    child: CachedNetworkImage(
                      imageUrl: loadedProduct!['imageUrl'],
                      errorWidget: (context, url, error) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.error),
                              Text('Error when loading image')
                            ],
                          ),
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
                  const SizedBox(height: 10),
                  Text(
                    '\$ ${loadedProduct!['price']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      loadedProduct!['description'],
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
