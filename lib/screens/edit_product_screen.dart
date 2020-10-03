import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusnode = FocusNode();
  final _discriptionfocusnode = FocusNode();
  final _imageurlfocusnode = FocusNode();

  final _imageurlcontroller = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editProduct = Product(
    id: null,
    title: "",
    price: null,
    description: "",
    imageurl: "",
  );

  var _initvalue = {
    "title": "",
    "description": "",
    "price": "",
    "imageurl": "",
  };

  var _isinit = true;
  var _isLoding = false;

  @override
  void initState() {
    _imageurlfocusnode.addListener(_updateimageurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productid = ModalRoute.of(context).settings.arguments as String;

      if (productid != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findbyid(productid);
        _initvalue = {
          "title": _editProduct.title,
          "description": _editProduct.description,
          "price": _editProduct.price.toString(),
          // "imageurl": _editProduct.imageurl,
          "imageurl": "",
        };
        _imageurlcontroller.text = _editProduct.imageurl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageurlfocusnode.removeListener(_updateimageurl);
    _pricefocusnode.dispose();
    _discriptionfocusnode.dispose();
    _imageurlcontroller.dispose();
    _imageurlfocusnode.dispose();
    super.dispose();
  }

  void _updateimageurl() {
    if (!_imageurlfocusnode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveform() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoding = true;
    });

    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateproduct(_editProduct.id, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addproducts(_editProduct);
      } catch (error) {
        //  .catchError((error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occured! "),
            content: Text("Something went wrong."),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        );
      }
      // } finally {
      //   setState(() {
      //     _isLoding = false;
      //   });
      //   Navigator.of(context).pop();
      // }

      //  .then((value) {

    }
    setState(() {
      _isLoding = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Text"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveform,
          ),
        ],
      ),
      body: _isLoding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initvalue["title"],
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_pricefocusnode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Title:";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editProduct = Product(
                            id: _editProduct.id,
                            title: newValue,
                            price: _editProduct.price,
                            description: _editProduct.description,
                            imageurl: _editProduct.imageurl,
                            isfavorite: _editProduct.isfavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initvalue["price"],
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricefocusnode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_discriptionfocusnode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Price:";
                          }
                          if (double.tryParse(value) == null) {
                            return "Enter valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter greater Price";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            price: double.parse(newValue),
                            description: _editProduct.description,
                            imageurl: _editProduct.imageurl,
                            isfavorite: _editProduct.isfavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initvalue["description"],
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _discriptionfocusnode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Description:";
                          }
                          if (value.length < 10) {
                            return "Enter long Description";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            price: _editProduct.price,
                            description: newValue,
                            imageurl: _editProduct.imageurl,
                            isfavorite: _editProduct.isfavorite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 15,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageurlcontroller.text.isEmpty
                                ? Text("Enter url")
                                : FittedBox(
                                    child:
                                        Image.network(_imageurlcontroller.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _initvalue["imageurl"],
                              decoration:
                                  InputDecoration(labelText: "Image Url"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageurlcontroller,
                              focusNode: _imageurlfocusnode,
                              onFieldSubmitted: (value) {
                                _saveform();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter Image Url:";
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "Please enter valid url";
                                }
                                if (!value.endsWith(".png") &&
                                    !value.endsWith(".jpg") &&
                                    value.endsWith(".jpeg")) {
                                  return "Please enter valid url";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _editProduct = Product(
                                  id: _editProduct.id,
                                  title: _editProduct.title,
                                  price: _editProduct.price,
                                  description: _editProduct.description,
                                  imageurl: newValue,
                                  isfavorite: _editProduct.isfavorite,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
