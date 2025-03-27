import 'package:sqflite/sqflite.dart';
import 'package:coffee_shop/models/order.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class OrderDatabase {
  static final OrderDatabase _instance = OrderDatabase._internal();

  static Database? _database;
  factory OrderDatabase() => _instance;

  OrderDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'coffee_orders.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    //order table
    await db.execute('''
      CREATE TABLE orders(
      id TEXT PRIMARY KEY,
      total_price REAL NOT NULL,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL)
    ''');

    //order item table
    await db.execute('''
      CREATE TABLE order_items(
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        coffee_name TEXT NOT NULL,
        coffee_image TEXT NOT NULL,
        coffee_type TEXT NOT NULL,
        coffee_price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        size TEXT NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
      )
    ''');
  }

  //crud
  //create
  Future<String> createOrder(Order order) async {
    final db = await database;
    final batch = db.batch();

    //generate id krn blm ada fitur login
    if (order.id.isEmpty) {
      order = Order(
        id: const Uuid().v4(),
        items: order.items,
        totalPrice: order.totalPrice,
        status: order.status,
        createdAt: order.createdAt,
      );
    }

    //insert
    batch.insert('orders', order.toMap());

    for (var item in order.items) {
      if (item.id.isEmpty) {
        item.id = const Uuid().v4();
      }
      batch.insert('order_items', {...item.toMap(), 'order_id': order.id});
    }

    await batch.commit(noResult: true);
    return order.id;
  }

  //get
  Future<List<Order>> getOrders({String? status}) async {
    final db = await database;

    // Query orders
    List<Map<String, dynamic>> orderMaps;
    if (status != null) {
      orderMaps = await db.query(
        'orders',
        where: 'status = ?',
        whereArgs: [status],
        orderBy: 'created_at DESC',
      );
    } else {
      orderMaps = await db.query('orders', orderBy: 'created_at DESC');
    }

    // Build orders with their items
    List<Order> orders = [];
    for (var orderMap in orderMaps) {
      String orderId = orderMap['id'];

      // Get items for this order
      List<Map<String, dynamic>> itemMaps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      List<OrderItem> items =
          itemMaps.map((item) => OrderItem.fromMap(item)).toList();

      orders.add(Order.fromMap(orderMap, items));
    }

    return orders;
  }

  // Get a specific order
  Future<Order?> getOrder(String id) async {
    final db = await database;

    List<Map<String, dynamic>> orderMaps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (orderMaps.isEmpty) {
      return null;
    }

    // Get items for this order
    List<Map<String, dynamic>> itemMaps = await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [id],
    );

    List<OrderItem> items =
        itemMaps.map((item) => OrderItem.fromMap(item)).toList();

    return Order.fromMap(orderMaps.first, items);
  }

  // Get cart (active order with status 'cart')
  Future<Order?> getCart() async {
    List<Order> carts = await getOrders(status: 'cart');
    return carts.isNotEmpty ? carts.first : null;
  }

  // Update an order
  Future<void> updateOrder(Order order) async {
    final db = await database;
    final batch = db.batch();

    // Update order
    batch.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );

    // Delete existing items
    batch.delete('order_items', where: 'order_id = ?', whereArgs: [order.id]);

    // Insert updated items
    for (var item in order.items) {
      if (item.id.isEmpty) {
        item.id = const Uuid().v4();
      }

      batch.insert('order_items', {...item.toMap(), 'order_id': order.id});
    }

    await batch.commit(noResult: true);
  }

  // Delete an order
  Future<void> deleteOrder(String id) async {
    final db = await database;

    await db.transaction((txn) async {
      // Delete order items first (due to foreign key constraint)
      await txn.delete('order_items', where: 'order_id = ?', whereArgs: [id]);

      // Delete the order
      await txn.delete('orders', where: 'id = ?', whereArgs: [id]);
    });
  }

  // Add item to cart
  Future<void> addToCart(OrderItem item) async {
    // Get or create cart
    Order? cart = await getCart();

    if (cart == null) {
      // Create a new cart
      cart = Order(
        id: '',
        items: [item],
        totalPrice: item.price * item.quantity,
        status: 'cart',
        createdAt: DateTime.now(),
      );

      await createOrder(cart);
    } else {
      // Check if the same coffee and size already exists in cart
      int existingIndex = cart.items.indexWhere(
        (i) => i.coffee.name == item.coffee.name && i.size == item.size,
      );

      if (existingIndex >= 0) {
        // Update existing item
        cart.items[existingIndex].quantity += item.quantity;
        cart.items[existingIndex].price += item.price;
      } else {
        // Add new item
        cart.items.add(item);
      }

      // Recalculate total price
      cart.totalPrice = cart.items.fold(0, (sum, item) => sum + item.price);

      await updateOrder(cart);
    }
  }

  // Update cart item quantity
  Future<void> updateCartItemQuantity(String itemId, int quantity) async {
    Order? cart = await getCart();

    if (cart != null) {
      int itemIndex = cart.items.indexWhere((item) => item.id == itemId);

      if (itemIndex >= 0) {
        OrderItem item = cart.items[itemIndex];

        if (quantity <= 0) {
          // Remove item if quantity is 0 or less
          cart.items.removeAt(itemIndex);
        } else {
          // Update quantity and price
          double pricePerUnit = item.price / item.quantity;
          item.quantity = quantity;
          item.price = pricePerUnit * quantity;
        }

        // Recalculate total price
        cart.totalPrice = cart.items.fold(0, (sum, item) => sum + item.price);

        if (cart.items.isEmpty) {
          // Delete cart if empty
          await deleteOrder(cart.id);
        } else {
          // Update cart
          await updateOrder(cart);
        }
      }
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    await updateCartItemQuantity(itemId, 0);
  }

  // Checkout cart
  Future<String?> checkoutCart() async {
    Order? cart = await getCart();

    if (cart != null && cart.items.isNotEmpty) {
      cart.status = 'pending';
      await updateOrder(cart);
      return cart.id;
    }

    return null;
  }
}
