import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'category_admin.dart';
import 'product.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  ProductService productService = ProductService();
  //BrandService _brandService = BrandService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<File> _imageFile;

  TextEditingController productController  = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quatityController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  final priceController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<String> categories = <String>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];

  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  List<String> selectedSizes = <String>[];
  File _image1;
  File _image2;
  File _image3;
  bool isLoading= false;
  String selected;

  File _image;


  void initState() {
    super.initState();
    Firestore.instance
        .collection("categories")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.data);
        categories.add((result.data)['categoryName']);
        print((result.data)['categoryName']);
        print(categories.length.toString());
      });
      setState(() {});
    });

  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (categories.length == null || categories.length == 0) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: white,
          leading: Icon(Icons.close, color: black,),
          title: Text("add product", style: TextStyle(color: black),),
        ),
        body:Center(child: Container(child: CircularProgressIndicator())));
    }
    else{
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(Icons.close, color: black,),
        title: Text("add product", style: TextStyle(color: black),),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading? CircularProgressIndicator() : Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: OutlineButton(
                          borderSide: BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                          onPressed: (){
                            _selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 1);
                            setState(() {
                              _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
                            });

                          },
                          child: _displayChild1()
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('enter a product name with 10 characters at maximum',textAlign: TextAlign.center ,style: TextStyle(color: red, fontSize: 12),),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                      hintText: 'Product name'
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'You must enter the product name';
                    }else if(value.length > 10){
                      return 'Product name cant have more than 10 letters';
                    }
                  },
                ),
              ),

//              select category
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Category: ', style: TextStyle(color: red),),
                  ),
                  new DropdownButton<String>(
                    value:selected ,
                    items: categories.map(( selected) {
                      return new DropdownMenuItem<String>(
                        value: selected,
                        child: new Text(selected),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        selected = newValue;
                      });
                    },
                  )

    ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: quatityController,
                  // initialValue: '1',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    //  labelText:'Quantity' ,
                    hintText: 'Quantity',
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'You must enter quantity';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: priceController,
                  //  initialValue: '0.00',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // labelText: 'price',
                    hintText: 'Price',
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'You must enter price';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: reviewController,
                  //  initialValue: '0.00',
                  decoration: InputDecoration(
                    // labelText: 'price',
                    hintText: "Review",
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'You must enter review';
                    }
                  },
                ),
              ),
              FlatButton(
                color: red,
                textColor: white,
                child: Text('add product'),
                onPressed: (){
                 validateAndUpload();
                 // Navigator.pop(context);

                },
              )
            ],
          ),
        ),
      ),
    );}
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async{
    File tempImg = await pickImage;
    setState(() => _image1 = tempImg);
    if (pickImage == null) return;

    _imageFile=pickImage ;


  }

  Widget _displayChild1() {
    if(_image1 == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 46, 14, 46),
        child: new Icon(Icons.add, color: grey,),
      );
    }else{
      return Image.file(_image1, fit: BoxFit.fill, width: double.infinity,);
    }
  }

  Widget _displayChild2() {
    if(_image2 == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 46, 14, 46),
        child: new Icon(Icons.add, color: grey,),
      );
    }else{
      return Image.file(_image2, fit: BoxFit.fill, width: double.infinity,);
    }
  }

  Widget _displayChild3() {
    if(_image3 == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 46, 14, 46),
        child: new Icon(Icons.add, color: grey,),
      );
    }else{
      return Image.file(_image3, fit: BoxFit.fill, width: double.infinity,);
    }
  }

  void validateAndUpload() async{
    if(_formKey.currentState.validate()){
      if (productNameController.text != null &&selected!= null &&quatityController.text!= null &&quatityController.text!= null) {
        Firestore.instance.collection("products").add(
            {
              "productName" : productNameController.text,
              "category":selected,
              "quantity":quatityController.text,
              "price":priceController.text,
              "review":reviewController.text,
            }).then((value) async {
          print(value.documentID);
          String fileName = 'ProductsImages/${productNameController.text}.jpg';
          print(_image);
          final uploadTask =
              await FirebaseStorage.instance.ref().child(fileName).putFile(await _imageFile);
          final downloadLink = (await uploadTask.onComplete);
          Navigator.pop(context);
        });
      }
    }
  }
}
