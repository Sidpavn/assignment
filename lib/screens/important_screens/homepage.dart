import 'dart:ui';
import 'package:assignment/models/cart_item_model.dart';
import 'package:assignment/models/item_model.dart';
import 'package:assignment/screens/important_screens/add_to_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:badges/badges.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorage storage = LocalStorage('ShoppingApp');
  List<Item> _items = [];
  int cart_item_count = 0;
  int item_id = 0;
  int particular_item_count = 0;
  int item_quantity = 0;
  List<Cart_Item> cart_items = [];
  List selected_item = [];

  final bool showActions = false;

  void initState() {
    super.initState();
    ItemServices().getItem().then((item) {
      setState(() {
        _items = item;
      });
    });
    if(storage.getItem('selected_item') != null){
      selected_item = storage.getItem('selected_item');
    }
    if(storage.getItem('cart_item_count') == null){
      storage.setItem('cart_item_count', 0);
    }
    if(storage.getItem('item_id') == null){
      storage.setItem('item_id', 0);
    }
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
              title: Text('Shopping App',
                style:GoogleFonts.robotoMono(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Badge(
                    position: BadgePosition.topEnd(top: 3, end: 3),
                    badgeContent: storage.getItem('cart_item_count') == null ? Text(
                      '0',
                      style:GoogleFonts.robotoMono(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.normal,
                      ),
                    ): Text(
                      (storage.getItem('cart_item_count')).toString(),
                      style:GoogleFonts.robotoMono(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    badgeColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart_rounded),
                      onPressed: () {
                        storage.getItem('cart_item_count') != 0 ?
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => AddToCart(),
                            transitionDuration: Duration.zero,
                          ),
                        ) :
                        Toast.show("No items in the cart",
                            context,
                            duration: Toast.LENGTH_SHORT,
                            gravity:  Toast.BOTTOM,
                            textColor: Color(0xAA000000),
                            backgroundColor: Color(0xAAFFF31C));
                      },
                    ),
                  ),
                ),
              ],
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
                                                            width: parentWidth/1.1,
                                                            margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                                                            child: Flexible(child: Text('Fruits Section',
                                                              style:GoogleFonts.robotoMono(
                                                                textStyle: Theme.of(context).textTheme.headline4,
                                                                color: Colors.black,
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.w900,
                                                                fontStyle: FontStyle.normal,
                                                              ),
                                                            ),)
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: parentWidth /1.1,
                                                          margin: EdgeInsets.fromLTRB(20, 5, 0, 20),
                                                          child: Flexible(
                                                            child: Text('Add items to your shopping cart for checkout',
                                                              style:GoogleFonts.robotoMono(
                                                                textStyle: Theme.of(context).textTheme.headline4,
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w400,
                                                                fontStyle: FontStyle.normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                            width: parentWidth /1.1,
                                                            margin: EdgeInsets.fromLTRB(20, 10, 0, 20),
                                                            child: GridView.builder(
                                                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                                  maxCrossAxisExtent: 250,
                                                                  childAspectRatio: 2/1,
                                                                  crossAxisSpacing: 5,
                                                                  mainAxisSpacing: 5),
                                                              physics: NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: _items.length,
                                                              itemBuilder: (context, index) {
                                                                if(storage.getItem('${_items[index].item_name}_count') == null){
                                                                  storage.setItem('${_items[index].item_name}_count', int.parse(_items[index].item_count));
                                                                }
                                                                return Container(
                                                                  margin: EdgeInsets.only(top:0),
                                                                  child :MaterialButton(
                                                                    padding: EdgeInsets.fromLTRB(10,15,10,15),
                                                                    elevation: 4,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(0.0),
                                                                        side: BorderSide(color: Colors.black,width: 2.0)
                                                                    ),
                                                                    highlightElevation: 0,
                                                                    color: storage.getItem('${_items[index].item_name}_count') == 0 ?
                                                                    Colors.white70 : Colors.white,
                                                                    child:
                                                                    ListTile(
                                                                      title: Text(_items[index].item_name,
                                                                        style:GoogleFonts.robotoMono(
                                                                          textStyle: Theme.of(context).textTheme.headline4,
                                                                          color: Colors.black,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight.w800,
                                                                          fontStyle: FontStyle.normal,
                                                                        ),
                                                                      ),
                                                                      subtitle: storage.getItem('${_items[index].item_name}_count') == 0 ?
                                                                       Text('LKR ' + _items[index].item_price +'.00 \n\n'
                                                                          + 'Out of stock',
                                                                        style:GoogleFonts.robotoMono(
                                                                          textStyle: Theme.of(context).textTheme.headline4,
                                                                          color: Colors.black.withOpacity(0.8),
                                                                          fontSize: 13,
                                                                          fontWeight: FontWeight.w400,
                                                                          fontStyle: FontStyle.normal,
                                                                        ),
                                                                      ) : Text('LKR ' + _items[index].item_price +'.00 \n\n'
                                                                    + 'In Stock('+ (storage.getItem('${_items[index].item_name}_count')).toString() +')',
                                                                      style:GoogleFonts.robotoMono(
                                                                        textStyle: Theme.of(context).textTheme.headline4,
                                                                        color: Colors.black.withOpacity(0.8),
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight.w400,
                                                                        fontStyle: FontStyle.normal,
                                                                      ),
                                                                    ),
                                                                    ),
                                                                    onPressed: () async {
                                                                      particular_item_count = storage.getItem('${_items[index].item_name}_count');
                                                                      storage.setItem('quantity', 1);
                                                                      particular_item_count == 0 ? null :
                                                                      showDialog(context: context, builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                          insetPadding: EdgeInsets.all(10.0),
                                                                          backgroundColor: Colors.white,
                                                                          title: Text( 'Add ${_items[index].item_name} to the cart?',
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
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text('Choose quantity: ',
                                                                                    style:GoogleFonts.robotoMono(
                                                                                      textStyle: Theme.of(context).textTheme.headline4,
                                                                                      color: Colors.black,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FontStyle.normal,
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    child: CustomNumberPicker(
                                                                                      initialValue: 1,
                                                                                      maxValue: particular_item_count,
                                                                                      minValue: 1,
                                                                                      step: 1,
                                                                                      customAddButton:
                                                                                      Icon(Icons.add_outlined,
                                                                                        color: Colors.black,
                                                                                        size: parentWidth/15,),
                                                                                      valueTextStyle : TextStyle(
                                                                                        color: Colors.black, fontSize: parentWidth/20,
                                                                                      ),
                                                                                      customMinusButton:
                                                                                      Icon(Icons.remove,
                                                                                          color: Colors.black,
                                                                                          size: parentWidth/15),
                                                                                      enable: true,
                                                                                      onValue: (quantity) {
                                                                                        storage.setItem('quantity', quantity);
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
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
                                                                                    int item_count = storage.getItem('${_items[index].item_name}_count')
                                                                                        - storage.getItem('quantity');
                                                                                    storage.setItem('${_items[index].item_name}_count', item_count);
                                                                                    if (storage.getItem('item_id') == null){
                                                                                      storage.setItem('item_id', 0);
                                                                                    }
                                                                                    storage.setItem('item_id', storage.getItem('item_id') + 1);
                                                                                    selected_item.add(
                                                                                        {
                                                                                          "id": storage.getItem('item_id'),
                                                                                          "item_name": _items[index].item_name,
                                                                                          "item_price": int.parse(_items[index].item_price) * storage.getItem('quantity'),
                                                                                          "item_image": _items[index].item_image,
                                                                                          "quantity": storage.getItem('quantity'),
                                                                                        });
                                                                                    storage.setItem('cart_item_count', selected_item.length);
                                                                                    storage.setItem('selected_item', selected_item);
                                                                                    print('testing');
                                                                                    print(storage.getItem('selected_item'));
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
                                                                  )
                                                                );
                                                              },
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