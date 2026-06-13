class CartController {
  // العناصر اللي في الكارت
  static final List<Map<String, dynamic>> cartItems = [];

  // الطلبات اللي اتعمل لها checkout
  static final List<Map<String, dynamic>> orders = [];

  // إضافة للكارت
  static void addToCart(Map<String, dynamic> plant) {
    cartItems.add(plant);
  }

  // حذف عنصر
  static void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  // تنفيذ الشراء
  static void checkout() {
    orders.addAll(cartItems);
    cartItems.clear();
  }

  // هل الكارت فاضي
  static bool get isEmpty => cartItems.isEmpty;

  // إجمالي السعر
  static double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      total += (item['price'] ?? 0);
    }
    return total;
  }
}