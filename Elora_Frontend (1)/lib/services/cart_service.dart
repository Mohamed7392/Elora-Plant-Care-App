import 'dart:async';

class CartService {
  // Static memory storage for the session
  static final List<Map<String, dynamic>> _cartItems = [];
  static final List<Map<String, dynamic>> _orders = [];
  
  // Stream controllers to mimic Firebase real-time updates
  static final StreamController<List<Map<String, dynamic>>> _cartController = StreamController.broadcast();
  static final StreamController<List<Map<String, dynamic>>> _ordersController = StreamController.broadcast();

  Future<void> addToCart({
    required String plantId,
    required String name,
    required String imageUrl,
    required double price,
    required int quantity,
  }) async {
    final index = _cartItems.indexWhere((item) => item['plantId'] == plantId);
    if (index >= 0) {
      _cartItems[index]['quantity'] += quantity;
    } else {
      _cartItems.add({
        'plantId': plantId,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
      });
    }
    _cartController.add(List.from(_cartItems));
  }

  Stream<List<Map<String, dynamic>>> cartStream() {
    // Emit initial value
    Future.microtask(() => _cartController.add(List.from(_cartItems)));
    return _cartController.stream;
  }

  Future<void> updateQuantity(String plantId, int quantity) async {
    final index = _cartItems.indexWhere((item) => item['plantId'] == plantId);
    if (index >= 0) {
      _cartItems[index]['quantity'] = quantity;
      _cartController.add(List.from(_cartItems));
    }
  }

  Future<void> removeItem(String plantId) async {
    _cartItems.removeWhere((item) => item['plantId'] == plantId);
    _cartController.add(List.from(_cartItems));
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    _cartController.add(List.from(_cartItems));
  }

  Future<void> placeOrder() async {
    if (_cartItems.isEmpty) return;
    
    _orders.add({
      'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'items': List.from(_cartItems),
    });
    
    await clearCart();
    _ordersController.add(List.from(_orders));
  }

  Stream<List<Map<String, dynamic>>> ordersStream() {
    Future.microtask(() => _ordersController.add(List.from(_orders)));
    return _ordersController.stream;
  }
}
