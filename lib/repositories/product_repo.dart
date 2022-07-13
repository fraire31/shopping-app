import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> findProductByDocumentId(String id) async {
    return await _firestore
        .collection('products')
        .where('id', isEqualTo: id)
        .get();
  }

  Future<DocumentReference<Map<String, dynamic>>> addProduct(
      String id,
      String title,
      String description,
      String imageUrl,
      double price,
      bool isFavorite) async {
    return await _firestore.collection('products').add({
      'id': id,
      'price': price,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    });
  }

  Future updateProduct(
    String docId,
    String title,
    String description,
    String imageUrl,
    double price,
  ) async {
    return await _firestore
        .collection('products')
        .doc(docId.toString())
        .update({
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    });
  }

  Future updateProductId(
      DocumentReference<Map<String, dynamic>> product) async {
    return await product.update({'id': product.id});
  }

  Future<void> deleteProduct(String docId) async {
    return await _firestore
        .collection('products')
        .doc(docId.toString())
        .delete();
  }
}
