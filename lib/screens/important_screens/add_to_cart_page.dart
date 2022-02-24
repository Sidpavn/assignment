import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:toast/toast.dart';
import 'checkout_page.dart';
import 'homepage.dart';

class AddToCart extends StatefulWidget {
  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  final LocalStorage storage = LocalStorage('ShoppingApp');

  int cart_item_count = 0;
  List cart_items = [];
  List<String> namesList = [];
  List<String> pricesList = [];
  List<String> idsList = [];
  List<String> imagesList = [];
  List<String> quantityList = [];
  int total_amount = 0;

  void initState() {
    super.initState();
    cart_items = storage.getItem('selected_item');
    namesList = cart_items.map((e) => e["item_name"].toString()).toList();
    pricesList = cart_items.map((e) => e["item_price"].toString()).toList();
    idsList = cart_items.map((e) => e["id"].toString()).toList();
    imagesList = cart_items.map((e) => e["item_image"].toString()).toList();
    quantityList = cart_items.map((e) => e["quantity"].toString()).toList();
    print('testing cart');
    print(namesList);
    print(pricesList);
    print(idsList);
    print(imagesList);
    print(quantityList);
    for (var i = 0; i < pricesList.length; i++) {
      total_amount += int.parse(pricesList[i]);
    }
    storage.setItem('payment_method', 'Cash');
    storage.setItem('total_amount', total_amount);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text('Cart list',
              style:GoogleFonts.robotoMono(
                textStyle: Theme.of(context).textTheme.headline4,
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
            leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => HomePage(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
          ),
          body: Container(
            child: LayoutBuilder(
              builder: (context, constraints) {
                var status_bar_height = MediaQuery.of(context).padding.top;
                var parentHeight = constraints.maxHeight;
                var parentWidth = constraints.maxWidth;
                debugPrint('MaxHeight: $parentHeight, maxwidth: $parentWidth');
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //toolbar
                      Container(
                        height:status_bar_height,
                      ),
                      Container(
                        height: parentHeight * 1,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Expanded(
                              child:
                              ListView(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        child:Row(
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: parentWidth /1.1,
                                                        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                                        child: ListView.builder(
                                                          physics: NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount: cart_items.length,
                                                          itemBuilder: (context, index) {
                                                            return Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(0),
                                                                    border: Border.all(color: Colors.black, width: 2.0)
                                                                ),
                                                                margin: EdgeInsets.only(top:5),
                                                                child :ListTile(
                                                                  title: Text((namesList[index]).toString() + ' x${(quantityList[index]).toString()}',
                                                                    style:GoogleFonts.robotoMono(
                                                                      textStyle: Theme.of(context).textTheme.headline4,
                                                                      color: Colors.black,
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w800,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                  subtitle: Text('LKR ' + (pricesList[index]).toString() + '.00',
                                                                    style:GoogleFonts.robotoMono(
                                                                      textStyle: Theme.of(context).textTheme.headline4,
                                                                      color: Colors.black,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  ),
                                                                  trailing: Icon(Icons.delete),
                                                                  onTap: () async {
                                                                    showDialog(context: context, builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        insetPadding: EdgeInsets.all(10.0),
                                                                        backgroundColor: Colors.white,
                                                                        title: Text( 'Remove ${namesList[index]} from the cart?',
                                                                            style:GoogleFonts.robotoMono(
                                                                              textStyle: Theme.of(context).textTheme.headline4,
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontStyle: FontStyle.normal,
                                                                            )),
                                                                        content: Column(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            Container(
                                                                              margin: EdgeInsets.only(top:20),
                                                                              padding: EdgeInsets.all(0),
                                                                              alignment: Alignment.center,
                                                                              child: MaterialButton(
                                                                                padding: EdgeInsets.fromLTRB(10,15,10,10),
                                                                                elevation: 4,
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(0.0),
                                                                                    side: BorderSide(color: Colors.black,width: 2.0)
                                                                                ),
                                                                                highlightElevation: 0,
                                                                                child: Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: parentWidth/1.3,
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Container(
                                                                                                alignment: Alignment.center,
                                                                                                padding: EdgeInsets.fromLTRB( 10, 0, 0, 10),
                                                                                                child: Flexible(
                                                                                                  child : Text('Yes',
                                                                                                    style:GoogleFonts.robotoMono(
                                                                                                      textStyle: Theme.of(context).textTheme.headline4,
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 20,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontStyle: FontStyle.normal,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                onPressed: () async {
                                                                                  print(cart_items);
                                                                                  print(idsList[index]);
                                                                                  cart_items.removeWhere((item) =>  item['id'] == int.parse(idsList[index]));
                                                                                  int cart_count = storage.getItem('cart_item_count') - 1;
                                                                                  storage.setItem('cart_item_count', cart_count);
                                                                                  int item_count = storage.getItem('${namesList[index]}_count') + int.parse(quantityList[index]);
                                                                                  storage.setItem('${namesList[index]}_count', item_count);
                                                                                  storage.setItem('selected_item', cart_items);
                                                                                  Toast.show("${namesList[index]} Removed",
                                                                                      context,
                                                                                      duration: Toast.LENGTH_SHORT,
                                                                                      gravity:  Toast.BOTTOM,
                                                                                      textColor: Color(0xAA000000),
                                                                                      backgroundColor: Color(0xAAFFF31C));
                                                                                  Navigator.pushReplacement(
                                                                                    context,
                                                                                    PageRouteBuilder(
                                                                                      pageBuilder: (context, animation1, animation2) => AddToCart(),
                                                                                      transitionDuration: Duration.zero,
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        actions: <Widget>[
                                                                          FlatButton(
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text('Close',
                                                                              style:GoogleFonts.robotoMono(
                                                                                textStyle: Theme.of(context).textTheme.headline4,
                                                                                color: Colors.red,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontStyle: FontStyle.normal,
                                                                              ),),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                                  },
                                                                ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  cart_items.length != 0 ? Container(
                                                      width: parentWidth /1.1,
                                                      margin: EdgeInsets.fromLTRB(20, 25, 0, 0),
                                                      child: Container(
                                                          margin: EdgeInsets.only(top:0),
                                                          child :Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // use whichever suits your need
                                                            children: <Widget>[
                                                              Text('Total Amount:',
                                                                style:GoogleFonts.robotoMono(
                                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                                  color: Colors.black,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w800,
                                                                  fontStyle: FontStyle.normal,
                                                                ),),
                                                              Text('LKR ${storage.getItem('total_amount')}.00',
                                                                style:GoogleFonts.robotoMono(
                                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                                  color: Colors.black,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w800,
                                                                  fontStyle: FontStyle.normal,
                                                                ),),
                                                            ],
                                                          )
                                                      )
                                                  ) : Container(
                                                      width: parentWidth /1.1,
                                                      margin: EdgeInsets.fromLTRB(20, 25, 0, 25),
                                                      child: Container(
                                                          margin: EdgeInsets.only(top:0),
                                                          child :Row(
                                                            mainAxisAlignment: MainAxisAlignment.center, // use whichever suits your need
                                                            children: <Widget>[
                                                              Text('Cart Empty',
                                                                style:GoogleFonts.robotoMono(
                                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                                  color: Colors.black,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w800,
                                                                  fontStyle: FontStyle.normal,
                                                                ),),
                                                            ],
                                                          )
                                                      )
                                                  ),
                                                  cart_items.length != 0 ? Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                      width: parentWidth/1.1,
                                                      height: 70,
                                                      child: MaterialButton(
                                                        child: Text('Checkout' ,
                                                          style:GoogleFonts.robotoMono(
                                                            textStyle: Theme.of(context).textTheme.headline4,
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pushReplacement(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (context, animation1, animation2) => CheckoutPage(),
                                                              transitionDuration: Duration.zero,
                                                            ),
                                                          );
                                                        },
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ) :
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                      width: parentWidth/1.1,
                                                      height: 70,
                                                      child: MaterialButton(
                                                        child: Text('Cannot Proceed to Checkout' ,
                                                          style:GoogleFonts.robotoMono(
                                                            textStyle: Theme.of(context).textTheme.headline4,
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.w700,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                        onPressed: () {

                                                        },
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        )
    );
  }

}