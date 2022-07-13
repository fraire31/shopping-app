import 'package:flutter/material.dart';

//NOT BEING USED HERE FOR REFERENCE
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.isFavorite = false,
    required this.imageUrl,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    return notifyListeners();
  }
}
