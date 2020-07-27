import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tamwink/admin/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tamwink/customer/cartmodel.dart';

class ProductSearch extends SearchDelegate<ProductService> {
  final List<Product> list;

  ProductSearch({this.list});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return  Expanded(
      child: Container(
        child: GridView.count(
          crossAxisCount: 1,
          primary: false,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 15.0,
          childAspectRatio: 0.8,
          children: <Widget>[
            GridView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
              itemBuilder: (context, index){
                return ScopedModelDescendant<CartModel>(
                    builder: (context, child, model) {
                      return GestureDetector(
                        onTap: () async {
                          print(searchFieldLabel);
//                        Image m;
//                        String url;
//                        await FirebaseStorage.instance.ref().child(
//                            'ProductsImages/${list[index].title}.jpg').getDownloadURL().then((
//                            downloadUrl) {
//                          print(m);
//                          url=downloadUrl.toString();
//                          print(m);
//                          print(downloadUrl.toString());
//                        });
//
//                        print("clicked");
//                        print(list[index].title);
//                        print("idd ${list[index].id}");
//                        if(url !=null) {
//                          Navigator.push(
//                              context, MaterialPageRoute(builder: (_) =>
//                              NoteDetailsPage(
//                                screen:"Admin",
//                                url:url,
//                                id: list[index].id,
//                                productName: list[index].title,
//                                quantity: list[index].qty
//                                    .toString(),
//                                price: list[index].price
//                                    .toString(),
//                                category: list[index].category,
//                                review:list[index].review,
//                              )));
//                        }
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
                          Text(list[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF575E67),
                                fontFamily: 'Varela',
                                fontSize: 14.0
                            ),

                          ),
                          Text(list[index].price.toString()+" جنية",

                            style: TextStyle(
                                color: Colors.orange[900],
                                fontFamily: 'Varela',
                                fontSize: 14.0
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                        ])),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(

    );
   // );

  }

  final String searchFieldLabel = 'ابحث هنا';
  Firestore _firestore = Firestore.instance;
  String ref = 'products';

  Future<List<DocumentSnapshot>> getSuggestions(String suggestions) =>
      _firestore
          .collection(ref)
          .where('productName', isEqualTo: suggestions)
          .getDocuments()
          .then((snap) {
        return snap.documents;
      });
}
