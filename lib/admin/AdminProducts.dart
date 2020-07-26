import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tamwink/customer/Product_Page.dart';
import 'package:tamwink/customer/cartmodel.dart';
import 'package:tamwink/newproduct/productdetails.dart';


class AdminProducts extends StatefulWidget {
  @override
  _AdminProductsState createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List categories = List<String>();
  List<Product> list=List<Product>();
  List<Product> categoryList=List<Product>();

  Widget selectedWidget=null;


  @override
  void initState() {
    super.initState();

    print(categories.length.toString());
    Firestore.instance.collection("products").getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) async {
        print(result.data);
        list.add(Product(id:result.documentID.toString(),category: (result.data)['category'],price:double.parse((result.data)['price']),title: (result.data)['productName'],qty:int.parse((result.data)['quantity']),review:(result.data)['review']));

      });
    });
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
      for(int i=0;i<list.length;i++){
        if(list[i].category==categories[0]){
          categoryList.add(list[i]);
        }
      }
      _tabController = TabController(length: categories.length, vsync: this);
      _tabController.addListener(_handleTabSelection);
      selectedWidget=ProductPage(category: categories[_tabController.index],categories: categoryList);

      setState(() {});
    });
//    if(categories.length==result.data.length){
//      setState(() {
//        print(categories.length.toString());
//      });
//    }
    print(categories.length.toString());
    print("list ${list.length.toString()}");

  }

  Widget getPList(String category)
  {

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
            height: MediaQuery.of(context).size.height - 80.0,
            child: GridView.count(
              crossAxisCount: 1,
              primary: false,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 0.8,
              children: <Widget>[
                GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: categoryList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
                  itemBuilder: (context, index){
                    return ScopedModelDescendant<CartModel>(
                        builder: (context, child, model) {
                          return GestureDetector(
                            onTap: () async {
                              Image m;
                              String url;
                              await FirebaseStorage.instance.ref().child(
                                  'ProductsImages/${categoryList[index].title}.jpg').getDownloadURL().then((
                                  downloadUrl) {
                                print(m);
                                url=downloadUrl.toString();
                                print(m);
                                print(downloadUrl.toString());
                              });

                              print("clicked");
                              print(categoryList[index].title);
                              print("idd ${categoryList[index].id}");
                              if(url !=null) {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (_) =>
                                    NoteDetailsPage(
                                      screen:"Admin",
                                      url:url,
                                      id: categoryList[index].id,
                                      productName: categoryList[index].title,
                                      quantity: categoryList[index].qty
                                          .toString(),
                                      price: categoryList[index].price
                                          .toString(),
                                      category: categoryList[index].category,
                                      review:categoryList[index].review,
                                    )));
                              }
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
                              Text(categoryList[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF575E67),
                                    fontFamily: 'Varela',
                                    fontSize: 14.0
                                ),

                              ),
                              Text(categoryList[index].price.toString()+" جنية",

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
          SizedBox(height: 15.0)
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if ((categories.length == null || categories.length == 0) &&(list.length == null || list.length == 0)) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange[900],
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                print(categories.length.toString());
              },
            ),
            title: Text(
              'تموينك',
              style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
          body: Center(child: Container(child: CircularProgressIndicator())));
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange[900],
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                print(categories.length.toString());
              },
            ),
            title: Text(
              'تموينك',
              style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
//            actions: <Widget>[
//              IconButton(
//                  icon: Icon(Icons.notifications_none, color: Colors.white),
//                  onPressed: () {}),
//            ],
          ),
          body: ListView(
            padding: EdgeInsets.only(left: 20.0),
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Text(
                'الأقسام',
                style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 42.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                labelColor: Colors.orange[900],
                isScrollable: true,
                labelPadding: EdgeInsets.only(right: 45.0),
                unselectedLabelColor: Color(0xFFCDCDCD),
                tabs: categories.map((entry) {
                  return  Tab(
                    child: Text(entry,
                        style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 21.0,
                        )),
                  );

                }).toList(),
              ),
              Container(
                  height: MediaQuery.of(context).size.height - 50.0,
                  width: double.infinity,
                  child: TabBarView(controller: _tabController,children:
                  List.generate(categories.length,(index){
                    return getPList(categories[index]);
                    //   return selectedWidget??Container();
                  }),
                  )),
              //),
            ],
          ),

        ),
      );
    }
  }

  void _handleTabSelection() {
    setState(() {
      categoryList.clear();
      for(int i=0;i<list.length;i++){
        if(list[i].category==categories[_tabController.index]){
          categoryList.add(list[i]);
        }
      }
      selectedWidget=ProductPage(category: categories[_tabController.index],categories: categoryList);
    });
    setState(() {

    });
  }
}
