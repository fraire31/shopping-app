import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repositories/product_repo.dart';

class EditProductScreen extends StatefulWidget {
  static const String pageId = 'edit-product-screen';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  ProductRepo productRepo = ProductRepo();

  //must be disposed
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();
  String? productId;

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      productId = ModalRoute.of(context)!.settings.arguments as String;

      if (productId != null) {
        productRepo
            .findProductByDocumentId(productId!)
            .then((QuerySnapshot snapshot) {
          final docs = snapshot.docs;
          for (var doc in docs) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

            _titleController.text = data['title'];
            _priceController.text = data['price'].toString();
            _descriptionController.text = data['description'];
            _imageUrlController.text = data['imageUrl'];
            setState(() {});
          }
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((_imageUrlController.text.startsWith('http') &&
              _imageUrlController.text.startsWith('https')) ||
          (_imageUrlController.text.endsWith('.png') &&
              _imageUrlController.text.endsWith('.jpg') &&
              _imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (productId != null && productId!.isNotEmpty) {
      await productRepo
          .updateProduct(
        productId!,
        _titleController.text,
        _descriptionController.text,
        _imageUrlController.text,
        double.parse(_priceController.text),
      )
          .then((value) {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Product has been successfully updated'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
              label: 'okay',
              textColor: Colors.green,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
        ));
      }).catchError((error) {
        final e = error as FirebaseException;
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
              label: 'okay',
              textColor: Colors.red,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
        ));
      });
    } else {
      try {
        final newProduct = await productRepo.addProduct(
          DateTime.now().toString(),
          _titleController.text,
          _descriptionController.text,
          _imageUrlController.text,
          double.parse(_priceController.text),
          false,
        );

        await productRepo.updateProductId(newProduct);
      } catch (error) {
        final e = error as FirebaseException;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'okay',
              textColor: Colors.red,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
        title: Text(productId != null && productId!.isNotEmpty
            ? 'Edit Product'
            : 'Add new Product'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        //return a string = there is a error, if returns null = no error
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          //.tryParse(value) will not return an error if the value is not a double
                          //it will return null instead
                          return 'Please enter a valid number.';
                        }

                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than 0.';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }

                        if (value.length <= 10) {
                          return 'Please enter a longer description.';
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: CachedNetworkImage(
                            imageUrl: _imageUrlController.text,
                            errorWidget: (context, url, error) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Enter a URL'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onChanged: (value) {
                              setState(() {
                                _imageUrlController.text = value;
                              });
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL.';
                              }

                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }

                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid URL.';
                              }

                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
