import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/product/edit";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isInit = true;
  Product _editedProduct;
  String _appBarTitle = "";

  void _updateImageUrl() {
    print("Updaring imageURL controller with ${_imageUrlController.text}");
    setState(() {});
  }

  void _saveForm() {
    final bool isValid = _formKey.currentState.validate();
    setState(() {
      _formKey.currentState.save();
    });
    // check to see if this is a new product (has no .id) or
    // an existing product:
    if (_editedProduct.id == null) {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    } else {
      // update an existing product:
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      var args = ModalRoute.of(context).settings.arguments ?? null;
      if (args != null) {
        _editedProduct = args as Product;
        _imageUrlController.text = _editedProduct.imageUrl;
        _appBarTitle = 'Edit Your Freaking ${_editedProduct.title}';
      } else {
        _editedProduct = Product.empty();
        _appBarTitle = "Add Your New Freaking Product!";
      }
    }
    isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_appBarTitle,
              style: const TextStyle(fontFamily: 'PermanentMarker')),
          actions: [
            IconButton(icon: const Icon(Icons.save), onPressed: _saveForm)
          ]),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: _formKey,
            child: ListView(children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                initialValue: _editedProduct.title,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.length < 3) {
                    return "Title must have at least 3 letters";
                  }
                  return null;
                },
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocusNode),
                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(title: value);
                  print(
                      "_editedProduct updated from title field, current _editedProduct:");
                  _editedProduct.printIt();
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Price', prefix: Text('\$')),
                initialValue: _editedProduct.price.toStringAsFixed(2),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a price';
                  if (double.tryParse(value) == null) {
                    return '"${value}" is not a valid entry. Please enter a valid price.';
                  }
                  if (double.parse(value) <= 0.00) {
                    return 'Price must be greater than \$0.00';
                  }

                  return null;
                },
                onSaved: (value) {
                  _editedProduct =
                      _editedProduct.copyWith(price: double.parse(value));
                  print(
                      "_editedProduct updated from price field, current _editedProduct:");
                  _editedProduct.printIt();
                },
              ),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  initialValue: _editedProduct.description,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value.isEmpty || value.length < 10) {
                      return "Please enter a description. Description must be at least 10 characters.";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_imageUrlFocusNode),
                  onSaved: (value) {
                    _editedProduct =
                        _editedProduct.copyWith(description: value);
                    print(
                        "_editedProduct updated from description field, current _editedProduct:");
                    _editedProduct.printIt();
                  }),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: _imageUrlController.text.isEmpty
                      ? const Center(
                          child: Text(
                          "No Image URL Supplied",
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ))
                      : FittedBox(
                          child: Image.network(_imageUrlController.text,
                              fit: BoxFit.cover)),
                ),
                Expanded(
                    child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        // initialValue: _editedProduct.imageUrl,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "No url supplied. Please provide a URL for an image of this product.";
                          }
                          if (!value.startsWith('http')) {
                            return '\"${value}\" is not a valid URL. Please provide a valid URL starting with http or https.';
                          }
                          if (!value.endsWith('.png') ||
                              !value.endsWith('.jpg') ||
                              !value.endsWith('.jpeg')) {
                            return '\"${value}\" is not a valid UR for an imageL. Please provide a valid URL for image ending with .png, .jpg or .jpeg';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          _editedProduct =
                              _editedProduct.copyWith(imageUrl: value);
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct =
                              _editedProduct.copyWith(imageUrl: value);
                          print(
                              "_editedProduct updated from imageUrl field, current _editedProduct:");
                          _editedProduct.printIt();
                        })),
              ])
            ])),
      ),
    );
  }
}
