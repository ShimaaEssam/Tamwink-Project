//import 'dart:html';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tamwink/customer/crudfile.dart';

class EditProducts extends StatefulWidget {
  final String id;

  const EditProducts({Key key, this.id}) : super(key: key);
  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {

  // img by type file
  File _image;
  CrudFile crud = new CrudFile();
  static const routeName = '/details-screen';
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();

  var _email, _member, _card, _images;
  var _password, _newPassword, _confirmNewPassword;
  //String _email,_password,_member,_card;
  TextEditingController _numberControllr=TextEditingController();
  TextEditingController _priceControllr=TextEditingController();
  TextEditingController _reviewControllr=TextEditingController();
  Future<File> _imageFile;
  File _image1;
  login() async {
    final formdata = _formState.currentState;
    if (formdata.validate()) {
      formdata.save();

      FirebaseUser fireauth =
      (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      )) as FirebaseUser;
    }
  }

  addContact() {
    if (_formState.currentState.validate()) {
    }
  }

  // get currentUser
  FirebaseUser user;
  getuserdata() async {
    FirebaseUser userdata = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userdata;
      print("user ${user.uid}");
    });
  }

  @override
  void initState() {
    super.initState();
    getuserdata();
  }

  @override
  Widget build(BuildContext context) {
    // when click on camera icon
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future<String> uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await (taskSnapshot.ref.getDownloadURL());
      return url;
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

    return
      Directionality( textDirection: TextDirection.rtl,
        child:
        Scaffold(
          //backgroundColor: Colors.amberAccent[100],
          appBar: AppBar(

            title: Text('تعديل المنتج'),
            backgroundColor: Colors.orange[900],
          ),
          // resizeToAvoidBottomPadding: false,
          //drawer: MainDrawer(),
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
                          controller: _numberControllr,
                          decoration: InputDecoration(labelText: 'عدد المنتج'),
                        ),
                        new  TextField(
                          keyboardType: TextInputType.number,
                          controller: _priceControllr,
                          decoration: InputDecoration(labelText: 'سعر المنتج'),
                        ),
                        new  TextField(
                          controller: _reviewControllr,
                          decoration: InputDecoration(labelText: 'التقييم'),
                        ),
                        new SizedBox(
                          height: 15.0,
                        ),

                        new SizedBox(
                          height: 15.0,),
                        FlatButton(
                          onPressed: () async {
                            if(_priceControllr.text.isNotEmpty&&_numberControllr.text.isNotEmpty&&_reviewControllr.text.isNotEmpty){

                            var firebaseUser = await FirebaseAuth.instance
                                .currentUser();
                            print("id $widget.id");
                            Firestore.instance.collection("products").document(
                                widget.id).updateData({
                              "price": _priceControllr.text,
                              "quantity": _numberControllr.text,
                              "review": _reviewControllr.text
                            }).then((_) {
                              print("success!");
                            });
                            Navigator.pop(context);

                          }},
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
        child: new Icon(Icons.add),
      );
    }else{
      return Image.file(_image1, fit: BoxFit.fill, width: double.infinity,);
    }
  }
}
