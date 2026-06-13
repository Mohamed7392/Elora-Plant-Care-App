class AppData {
  static String username = "";

  static List<String> favorites = [];

  // ===== CART =====
  static List<CartItem> cart = [];
}

class CartItem {
  final String name;
  final int price;
  int qty;
  final String image;

  CartItem({
    required this.name,
    required this.price,
    required this.qty,
    required this.image,
  });
}
