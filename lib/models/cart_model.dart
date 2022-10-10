import 'package:demo4/models/catalog_model.dart';
import 'package:demo4/models/item.dart';
import 'package:flutter/material.dart';

class CartModel {
  /// The private field backing [catalog].1
  late CatalogModel _catalog;

  /// Internal, private state of the cart. Stores the ids of each item.2
  final List<int> _itemIds = [];

  CartModel();

  /// The current catalog. Used to construct items from numeric ids.3
  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    // notifyListeners();
  }

  /// List of items in the cart.
  List<Item> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  /// The current total price of all items.
  int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Item item) {
    _itemIds.add(item.id);

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    // notifyListeners();
  }

  void remove(Item item) {
    _itemIds.remove(item.id);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    // notifyListeners();
  }
}
