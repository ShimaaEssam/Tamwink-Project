import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tamwink/customer/product_detail.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tamwink/customer/cartmodel.dart';

class ProductPage extends StatefulWidget {
  final String category;
  final List<Product> categories;
  ProductPage({Key key, @required this.category, this.categories}) : super(key: key);


  @override
  _MyProductPageState createState() =>

      _MyProductPageState();
}

class _MyProductPageState extends State<ProductPage>{

  Uint8List imageBytes;
  String errorMsg;
  String _imageUrl;

  @override
  Widget build(BuildContext context) {
    print("From product Page ${widget.category}");
    if(widget.categories.length==null ||widget.categories.length==0){
      return Scaffold(
          backgroundColor: Color(0xFFFCFAF8),
    body:Center(child: Container(child: CircularProgressIndicator())));
    }
    else{

    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Container(
            padding: EdgeInsets.only(right: 15.0),
            width: MediaQuery.of(context).size.width - 30.0,
            height: MediaQuery.of(context).size.height - 50.0,
            child: GridView.count(
              crossAxisCount: 1,
              primary: false,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 0.8,
              children: <Widget>[
                GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: widget.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
                  itemBuilder: (context, index){
                    return ScopedModelDescendant<CartModel>(
                        builder: (context, child, model) {
                          return GestureDetector(
                            onTap: (){
                              print("clicked");
                            },
                            child: Card( child: Column( children: <Widget>[
                               SingleChildScrollView(
                                  child:Container(
                                      decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 3.0,
                                      blurRadius: 5.0)
                                ],
                                color: Colors.white,
                              ),
                            ),),
                              Text(widget.categories[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF575E67),
                                    fontFamily: 'Varela',
                                    fontSize: 14.0
                                ),

                              ),
                              Text(widget.categories[index].price.toString()+" جنية",

                              style: TextStyle(
                                  color: Colors.orange[900],
                                  fontFamily: 'Varela',
                                  fontSize: 14.0
                              ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                              FlatButton.icon(
                                onPressed: (){
                                  model.addProduct(widget.categories[index]);
                                },
                                color: Colors.white,
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange[900]),
                                  borderRadius: BorderRadius.circular(20),

                                ),
                                label: Text('إضافة',
                                textAlign: TextAlign.start,
                                ),
                                icon: Icon(Icons.shopping_cart,color: Colors.orange[900]),
                              ),
                            ])),
                          );
                        });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 15.0)
        ],
      ),
    );}
  }

  Widget _buildCard(String name, String price, String imgPath, bool added,
      bool isFavorite, context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetail(
                  assetPath: imgPath, productprice: price, productname: name)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3.0,
                  blurRadius: 5.0)
            ],
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[

              Hero(
                  tag: imgPath,
                  child: Container(
                      height: 75.0,
                      width: 75.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(imgPath),
                              fit: BoxFit.contain)))
              ),
              SizedBox(
                height: 7.0,
              ),
            ],
          ),
        ),
      ),
    );
//  }
  }

  @override
  void initState() {
    super.initState();
    print(widget.category);

    for(int i=0; i<widget.categories.length;i++){
      print(widget.categories[i]);
      print(widget.category);

    }
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.categories.clear();
  }
}