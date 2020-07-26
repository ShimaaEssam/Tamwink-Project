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
import './crudfile.dart';
import 'package:progress_indicators/progress_indicators.dart';
import './editPassword.dart';
import './member.dart';
import './editRationCard.dart';
import 'package:tamwink/customer/maincustomer.dart';
import 'product_detail.dart';

class DetailsScreen extends StatefulWidget {
//  final String url;
//
//  const DetailsScreen({Key key, this.url}) : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  // img by type file
  File _image;
  CrudFile crud = new CrudFile();
  static const routeName = '/details-screen';
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();

  var _email, _member, _card, _images;
  var _password, _newPassword, _confirmNewPassword;
  //String _email,_password,_member,_card;
  TextEditingController _phoneControllr=TextEditingController();
  TextEditingController _nameControllr=TextEditingController();
  TextEditingController _cardControllr=TextEditingController();
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
      _formState.currentState.save();
      crud.create({
        'email': _email,
        'password': _password,
        'member': _member,
        'cardnumber': _card,
        'images': _image
      });
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

            title: Text('حسابي'),
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

//                 widget.url==null? CircleAvatar(
//                    radius: 50,
//                    backgroundImage: NetworkImage('https://www.wepal.net/ar/uploads/2732018-073911PM-1.jpg'),
//
//                  ): CircleAvatar(radius: 50,
//                   backgroundImage: NetworkImage(
//              widget.url,
//            ),
//                  ),

//                  Text('mohamed ali',style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),
//                  ),
                  SizedBox(
                    height: 20,
                    width: 200,
                    child: Divider(
                      color: Colors.black54,
                    ),

                  ),
                  // once write Contairner the photo and text will write in center
                  Container(
                    child: Column(
                      children: <Widget>[

//                        new  TextField(
//                          controller: _emailControllr,
//                          decoration: InputDecoration(icon: Icon(Icons.email,color: Colors.deepOrange   ),labelText: 'البريد الالكتروني'),
//                        ),
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
//                        FlatButton(
//                          onPressed: () async {
//                            _selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 1);
//                            setState(() {
//                              _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
//                            });
//                            var firebaseUser = await FirebaseAuth.instance
//                                .currentUser();
//                            String fileName = 'UsersImages/${firebaseUser.uid}.jpg';
//                            print(_image);
//                            final uploadTask =
//                                await FirebaseStorage.instance.ref().child(fileName).putFile(await _imageFile);
//                            final downloadLink = (await uploadTask.onComplete);
//                            Navigator.pop(context);
//                          },
//                          textColor:  Colors.orange[900],
//                          padding: const EdgeInsets.all(15),
//                          child: Text('تغيير الصورة',style: TextStyle(fontSize: 17),),
//                          shape: OutlineInputBorder(
//                            borderSide: BorderSide(color: Colors.orange[900]),
//                            borderRadius: BorderRadius.circular(5),
//
//                          ),
//
//                        ),
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
