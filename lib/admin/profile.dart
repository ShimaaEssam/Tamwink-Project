//import 'package:cust/screens/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import './main_drawer.dart';
class DetailsScreen extends StatelessWidget {
  static const routeName= '/details-screen';
  TextEditingController _phoneControllr=TextEditingController();
  TextEditingController _nameControllr=TextEditingController();
  TextEditingController _cardControllr=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
      Directionality( textDirection: TextDirection.rtl,
        child:
        Scaffold(
          //backgroundColor: Colors.amberAccent[100],
          appBar: AppBar(

            title: Text('حسابي'),
            backgroundColor: Colors.orange[900],
          ),
          body: SafeArea(
            // SingleChildScrollView  to solve write problem
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    width: 200,

                  ),
                  // once write Contairner the photo and text will write in center
                  Container(
                    child: Column(
                      children: <Widget>[
                        new  TextField(
                          controller: _phoneControllr,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(icon: Icon(Icons.call,color: Colors.deepOrange   ),labelText: 'رقم التليفون'),
                        ),
                        new  TextField(
                          controller: _nameControllr,
                          decoration: InputDecoration(icon: Icon(Icons.perm_identity,color: Colors.deepOrange   ),labelText: 'الاسم'),
                        ),
                        new  TextField(
                          keyboardType: TextInputType.number,
                          controller: _cardControllr,
                          decoration: InputDecoration(icon: Icon(Icons.credit_card,color: Colors.deepOrange   ),labelText: 'رقم البطاقة'),
                        ),
                        new SizedBox(
                          height: 15.0,
                        ),
                        new SizedBox(
                          height: 15.0,),
                        FlatButton(
                          onPressed: () async {
                            var firebaseUser = await FirebaseAuth.instance
                                .currentUser();
                            Firestore.instance.collection("users").document(
                                firebaseUser.uid).updateData({
                              "phone": _phoneControllr.text,
                              "name": _nameControllr.text,
                              "cardNumber": _cardControllr.text
                            }).then((_) {
                              print("success!");
                            });
                            Navigator.pop(context);

                          },
                          textColor:  Colors.orange[900],
                          padding: const EdgeInsets.all(15),
                          child: Text('تحديث',style: TextStyle(fontSize: 20),),
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange[900]),
                            borderRadius: BorderRadius.circular(5),

                          ),

                        ),
                        //Icon(Icons.phone,color: Colors.black54   ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        ),
      );

  }

}
