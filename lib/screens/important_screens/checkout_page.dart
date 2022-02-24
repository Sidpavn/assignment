import 'dart:ui';
import 'package:assignment/screens/important_screens/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:toast/toast.dart';
import 'add_to_cart_page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final LocalStorage storage = LocalStorage('ShoppingApp');
  List cart_items = [];
  List<String> namesList = [];
  List<String> pricesList = [];
  List<String> idsList = [];
  List<String> imagesList = [];
  List<String> quantityList = [];
  int total_amount = 0;
  late var _razorpay;
  var amountController = TextEditingController();

  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    cart_items = storage.getItem('selected_item');
    namesList = cart_items.map((e) => e["item_name"].toString()).toList();
    pricesList = cart_items.map((e) => e["item_price"].toString()).toList();
    idsList = cart_items.map((e) => e["id"].toString()).toList();
    imagesList = cart_items.map((e) => e["item_image"].toString()).toList();
    quantityList = cart_items.map((e) => e["quantity"].toString()).toList();
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error!!');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet');
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
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
            title: Text('Checkout',
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
                    pageBuilder: (context, animation1, animation2) => AddToCart(),
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
                                                children: [
                                                  Container(
                                                      width: parentWidth/1.1,
                                                      margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                                      child: Flexible(child: Text('Items List',
                                                        style:GoogleFonts.robotoMono(
                                                          textStyle: Theme.of(context).textTheme.headline4,
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w900,
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),)
                                                  ),
                                                  Container(
                                                    width: parentWidth /1.1,
                                                    margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                                    child: ListView.builder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: cart_items.length,
                                                      itemBuilder: (context, index) {
                                                        return Container(
                                                          margin: EdgeInsets.only(top:0),
                                                          child :Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // use whichever suits your need
                                                            children: <Widget>[
                                                              Text((namesList[index]).toString() + ' x${(quantityList[index]).toString()}',
                                                                style:GoogleFonts.robotoMono(
                                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                                  color: Colors.black,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontStyle: FontStyle.normal,
                                                                ),),
                                                              Text('LKR ' + (pricesList[index]).toString() + '.00',
                                                                style:GoogleFonts.robotoMono(
                                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                                  color: Colors.black,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontStyle: FontStyle.normal,
                                                                ),),
                                                            ],
                                                          )
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width: parentWidth /1.1,
                                                    margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
                                                    child:
                                                    Divider(
                                                      color: Colors.black,
                                                      thickness: 1,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: parentWidth /1.1,
                                                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                                    child: Container(
                                                        margin: EdgeInsets.only(top:0),
                                                        child :Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // use whichever suits your need
                                                          children: <Widget>[
                                                            Text('Total Amount:',
                                                              style:GoogleFonts.robotoMono(
                                                                textStyle: Theme.of(context).textTheme.headline4,
                                                                color: Colors.black,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w800,
                                                                fontStyle: FontStyle.normal,
                                                              ),),
                                                            Text('LKR ${storage.getItem('total_amount')}.00',
                                                              style:GoogleFonts.robotoMono(
                                                                textStyle: Theme.of(context).textTheme.headline4,
                                                                color: Colors.black,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w800,
                                                                fontStyle: FontStyle.normal,
                                                              ),),
                                                          ],
                                                        )
                                                    )
                                                  ),
                                                  Container(
                                                    width: parentWidth /1.1,
                                                    margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
                                                    child:
                                                    Divider(
                                                      color: Colors.black,
                                                      thickness: 1,
                                                    ),
                                                  ),
                                                  // payment method
                                                  Container(
                                                      width: parentWidth/1.1,
                                                      margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                                      child: Flexible(child: Text('Choose a payment method',
                                                        style:GoogleFonts.robotoMono(
                                                          textStyle: Theme.of(context).textTheme.headline4,
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w900,
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),)
                                                  ),
                                                  Container(
                                                      width: parentWidth/1.1,
                                                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                                      child: Flexible(child: Text('Toogle to change the method',
                                                        style:GoogleFonts.robotoMono(
                                                          textStyle: Theme.of(context).textTheme.headline4,
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                          fontStyle: FontStyle.normal,
                                                        ),
                                                      ),)
                                                  ),
                                                  Container(
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                      width: parentWidth/1.1,
                                                      height: 60,
                                                      child: storage.getItem('payment_method') == 'Cash' ?
                                                      MaterialButton(
                                                        highlightColor: Colors.white.withOpacity(0.2),
                                                        padding: EdgeInsets.fromLTRB(10,15,10,10),
                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(0.0),
                                                            side: BorderSide(color: Colors.green,width: 2.0)
                                                        ),
                                                        highlightElevation: 0,
                                                        child: Text('Payment Method: Cash on Delivery' ,
                                                          style:GoogleFonts.robotoMono(
                                                            textStyle: Theme.of(context).textTheme.headline4,
                                                            color: Colors.green,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w800,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          storage.setItem('payment_method', 'Card');
                                                          Navigator.pushReplacement(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (context, animation1, animation2) => CheckoutPage(),
                                                              transitionDuration: Duration.zero,
                                                            ),
                                                          );
                                                        },
                                                        color: Colors.white,
                                                      ) :
                                                      MaterialButton(
                                                        highlightColor: Colors.white.withOpacity(0.2),
                                                        padding: EdgeInsets.fromLTRB(10,15,10,10),
                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(0.0),
                                                            side: BorderSide(color: Colors.green,width: 2.0)
                                                        ),
                                                        child: Text('Payment Method: Card' ,
                                                          style:GoogleFonts.robotoMono(
                                                            textStyle: Theme.of(context).textTheme.headline4,
                                                            color: Colors.green,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w800,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          storage.setItem('payment_method', 'Cash');
                                                          Navigator.pushReplacement(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (context, animation1, animation2) => CheckoutPage(),
                                                              transitionDuration: Duration.zero,
                                                            ),
                                                          );
                                                        },
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: parentWidth /1.1,
                                                    margin: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                                                    child:
                                                    const Divider(
                                                      color: Colors.black,
                                                      thickness: 1,
                                                    ),
                                                  ),
                                                  storage.getItem('payment_method') == 'Cash' ? Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                      width: parentWidth/1.1,
                                                      height: 70,
                                                      child: MaterialButton(
                                                        child: Text('Order Now' ,
                                                          style:GoogleFonts.robotoMono(
                                                            textStyle: Theme.of(context).textTheme.headline4,
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Toast.show("Order has been placed.",
                                                              context,
                                                              duration: Toast.LENGTH_SHORT,
                                                              gravity:  Toast.BOTTOM,
                                                              textColor: Color(0xAA000000),
                                                              backgroundColor: Color(0xAAFFF31C));
                                                          storage.setItem('selected_item', []);
                                                          storage.setItem('cart_item_count', 0);
                                                          Navigator.pushReplacement(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (context, animation1, animation2) => HomePage(),
                                                              transitionDuration: Duration.zero,
                                                            ),
                                                          );
                                                        },
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ) :
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                    width: parentWidth/1.1,
                                                    height: 70,
                                                    child: MaterialButton(
                                                        color: Colors.green,
                                                        child: Text('Pay Now with Card' ,
                                                          style:GoogleFonts.robotoMono(
                                                            textStyle: Theme.of(context).textTheme.headline4,
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700,
                                                            fontStyle: FontStyle.normal,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          ///Make payment
                                                          var options = {
                                                            'key': "rzp_test_VEX9Iv8Vdr1SQ9",
                                                            // amount will be convert to indian rupees for razorpay gateway
                                                            'amount': ( ((storage.getItem('total_amount')) * 37))
                                                                .toStringAsFixed(1),
                                                            'name': 'iLabs',
                                                            'description': 'Demo',
                                                            'timeout': 300, // in seconds
                                                            'prefill': {
                                                              'contact': '8787878787',
                                                              'email': 'demo@gmail.com'
                                                            }
                                                          };
                                                          _razorpay.open(options);
                                                        })
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