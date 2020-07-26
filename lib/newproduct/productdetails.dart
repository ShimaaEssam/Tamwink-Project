import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tamwink/newproduct/EditProducts.dart';
import 'package:tamwink/newproduct/product.dart';

class NoteDetailsPage extends StatefulWidget {

  final String productName, quantity, price, category,url,review,screen,id;
  static const routeName = '/productdetails';
  const NoteDetailsPage(
      {Key key, this.productName, this.quantity, this.price, this.category, this.url,this.review, this.screen, this.id})
      : super(key: key);

  @override
  _NoteDetailsPageState createState() => _NoteDetailsPageState();
}
class _NoteDetailsPageState extends State<NoteDetailsPage> {

  @override
  Widget build(BuildContext context) {
    final Note args = ModalRoute
        .of(context)
        .settings
        .arguments;
    MaterialApp(
      routes: {
        NoteDetailsPage.routeName: (context) => NoteDetailsPage(),
      },
    );
if(widget.url==null){
  return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      appBar: AppBar(
      title: Text('التفاصيل'),
    ),
    body:Center(child: Container(child: CircularProgressIndicator()))));
}
else{
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text('التفاصيل'),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 36.0, right: 20.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                                widget.url,
                                fit: BoxFit.scaleDown,
                              ),
                    //This is button to toggle image.
//        loadButton(context),

                    const SizedBox(
                      height: 46.0,
                    ),
                    Text(
                      widget.category,
                      style: Theme
                          .of(context)
                          .textTheme
                          .title
                          .copyWith(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    const SizedBox(
                      height: 46.0,
                    ),
                    Text("اسم المنتج :"),
                    Text(widget.productName),
                    const SizedBox(
                      height: 46.0,
                    ),
                    Text("عدد المنتج :"),
                    Text(widget.quantity),
                    const SizedBox(
                      height: 46.0,
                    ),
                    Text("سعر المنتج :"),
                    Text(widget.price + " جنيه"),
                    const SizedBox(
                      height: 46.0,
                    ),
                    Text("التقييم :"),
                    Text(widget.review),
                    const SizedBox(
                      height: 46.0,
                    ),
                    widget.screen=="Admin"? GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => EditProducts(id:widget.id)));
                      },
                        child: Text("تعديل البيانات",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)):Container(),
                    const SizedBox(
                      height: 46.0,
                    ),
                  ],
                ),
              ),
            )
        ));}
  }

}
