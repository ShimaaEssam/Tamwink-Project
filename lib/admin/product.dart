
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:convert/convert.dart';

class ProductService{
  Firestore _firestore = Firestore.instance;
  String ref = 'products';
  //String productName;
 // int quantity;

  void uploadProduct( String productName  /*, String category , int quantity ,List images , int price*/){
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(ref).document(productId).setData({
      'name' : productName,
      'id':productId,
    });
  }
}