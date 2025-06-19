class CartService {
  static final List<Map<String, dynamic>> _cartItems = [];
  static double _totalPrice = 0.0;

  static void addItem({
    required int productId,
    required int subProductId,
    required int quantity,
    required double price,
  }) {
    final index = _cartItems.indexWhere(
      (item) => item['subProductId'] == subProductId,
    );

    if (index >= 0) {
      _cartItems[index]['quantity'] = quantity;
      _cartItems[index]['price'] = price; // ✅ consistent naming
    } else {
      _cartItems.add({
        'productId': productId,
        'subProductId': subProductId,
        'quantity': quantity,
        'price': price, // ✅ consistent naming
      });
    }

    calculateTotalPrice();
  }

  static void updateQuantity(int productId, int subProductId, int quantity) {
    final index = _cartItems.indexWhere(
      (item) =>
          item['productId'] == productId &&
          item['subProductId'] == subProductId,
    );
    if (index != -1) {
      _cartItems[index]['quantity'] = quantity;
      calculateTotalPrice();
    }
  }

  static void removeItem(int productId, int subProductId) {
    _cartItems.removeWhere(
      (item) =>
          item['productId'] == productId &&
          item['subProductId'] == subProductId,
    );
    calculateTotalPrice();
  }

  static void calculateTotalPrice() {
    _totalPrice = _cartItems.fold(0.0, (sum, item) {
      return sum + (item['price'] ?? 0.0) * (item['quantity'] ?? 1);
    });

    print('🧾 Total Cart Price: ₹$_totalPrice');
  }

  static List<Map<String, dynamic>> get items => _cartItems;
  static double get totalPrice => _totalPrice;

  static void clearCart() {
    _cartItems.clear();
    _totalPrice = 0.0;
  }
}
