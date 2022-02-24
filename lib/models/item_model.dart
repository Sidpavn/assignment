import 'package:flutter/material.dart';

import 'dart:convert';

List<Item> itemFromJson(String str) =>
    List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
  Item({
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

  factory Item.fromJson(Map<String, dynamic> json) => Item(
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

class ItemServices {
  Future<List<Item>> getItem() {
    String jsonString = '''
    [
      {
        "id": "1",
        "item_name": "Apple",
        "item_price": "100",
        "item_count": "0",
        "item_image": "n/a"
      },
      {
        "id": "2",
        "item_name": "Orange",
        "item_price": "50",
        "item_count": "1",
        "item_image": "n/a"
      },
      {
        "id": "3",
        "item_name": "Dragon Fruit",
        "item_price": "200",
        "item_count": "2",
        "item_image": "n/a"
      },
      {
        "id": "4",
        "item_name": "Pear",
        "item_price": "70",
        "item_count": "6",
        "item_image": "n/a"
      },
      {
        "id": "5",
        "item_name": "Mango",
        "item_price": "55",
        "item_count": "16",
        "item_image": "n/a"
      }
    ]
    ''';
    List<Item> itemList = itemFromJson(jsonString);
    return Future.value(itemList);
  }
}