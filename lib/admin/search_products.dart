import 'package:flutter/material.dart';
import 'package:tamwink/admin/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSearch extends SearchDelegate<ProductService> {
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
    return Container();
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
