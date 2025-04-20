import 'package:flutter/foundation.dart';
import 'package:coffee_shop/models/coffee.dart';
import 'package:coffee_shop/models/order.dart';
import 'package:coffee_shop/database/order.dart';

class OrderService with ChangeNotifier {
  final OrderDatabase _db = OrderDatabase();

  Order? _cart;
  List<Order> _orders = [];
  bool _isLoading = false;

  Order? get cart => _cart;
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  int get cartItemCount => _cart?.items.length ?? 0;
  double get cartTotal => _cart?.totalPrice ?? 0;

  OrderService() {
    loadCart();
    _loadOrders();
  }

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    _cart = await _db.getCart();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadOrders() async {
    _isLoading = true;
    notifyListeners();
    //semua pesanan kecuali keranjang
    _orders = await _db.getOrders();
    _orders.removeWhere((order) => order.status == 'cart');

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(Coffee coffee, int quantity, String size) async {
    double price = coffee.price;

    // Apply price adjustment based on size
    if (size == 'L') {
      price += 5000;
    } else if (size == 'S') {
      price -= 2000;
    }

    OrderItem item = OrderItem(
      id: '',
      coffee: coffee,
      quantity: quantity,
      size: size,
      price: price * quantity,
    );

    await _db.addToCart(item);
    print('Item added to cart, now loading cart...');
    await loadCart(); // Gunakan metode public
    print('Cart after adding: ${_cart?.items.length ?? 0} items');
  }

  Future<void> updateCartItemQuantity(String itemId, int quantity) async {
    await _db.updateCartItemQuantity(itemId, quantity);
    await loadCart();
  }

  Future<void> removeFromCart(String itemId) async {
    await _db.removeFromCart(itemId);
    await loadCart();
  }

  Future<void> clearCart() async {
    if (_cart != null) {
      await _db.deleteOrder(_cart!.id);
      await loadCart();
    }
  }

  Future<String?> checkout() async {
    String? orderId = await _db.checkoutCart();

    if (orderId != null) {
      await loadCart();
      await _loadOrders();
    }

    return orderId;
  }

  Future<void> cancelOrder(String orderId) async {
    Order? order = await _db.getOrder(orderId);

    if (order != null) {
      order.status = 'cancelled';
      await _db.updateOrder(order);
      await _loadOrders();
    }
  }

  Future<void> refreshOrders() async {
    await _loadOrders();
  }

  // Metode untuk refresh manual
  Future<void> refreshCart() async {
    await loadCart();
  }
}
