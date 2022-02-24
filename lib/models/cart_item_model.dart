import 'package:flutter/material.dart';

import 'dart:convert';

List<Cart_Item> cart_itemFromJson(String str) =>
    List<Cart_Item>.from(json.decode(str).map((x) => Cart_Item.fromJson(x)));

String cart_itemToJson(List<Cart_Item> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart_Item {
  Cart_Item({
    required this.id,
    required this.item_name,
    required this.item_price,
    required this.item_count,
    required this.item_image,
  });

  String id;
  String item_name;
  String item_price;
  String item_count;
  String item_image;

  factory Cart_Item.fromJson(Map<String, dynamic> json) => Cart_Item(
    id: json["id"],
    item_name: json["item_name"],
    item_price: json["item_price"],
    item_count: json["item_count"],
    item_image: json["item_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item_name": item_name,
    "item_price": item_price,
    "item_count": item_count,
    "item_image": item_image,
  };
}
