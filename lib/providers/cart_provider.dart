// import 'package:flutter/material.dart';

// class CartProvider with ChangeNotifier {
//   final List<Map<String, dynamic>> _items = [];

//   List<Need> get items => _items;

//   void addToCart(Need need) {
//     if (!_items.contains(need)) {
//       _items.add(need);
//       notifyListeners();
//     }
//   }

//   void removeFromCart(Need need) {
//     _items.remove(need);
//     notifyListeners();
//   }

//   void clearCart() {
//     _items.clear();
//     notifyListeners();
//   }

//   double get totalAmount {
//     double total = 0;
//     for (var item in _items) {
//       total += item.unitCost;
//     }
//     return total;
//   }
// }
