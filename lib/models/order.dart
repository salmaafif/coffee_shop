import 'package:coffee_shop/models/coffee.dart';

class OrderItem {
  String id;
  Coffee coffee;
  int quantity;
  String size;
  double price;

  OrderItem({
    required this.id,
    required this.coffee,
    required this.quantity,
    required this.size,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coffee_name': coffee.name,
      'coffee_image': coffee.image,
      'coffee_type': coffee.type,
      'coffee_price': coffee.price,
      'quantity': quantity,
      'size': size,
      'price': price,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      coffee: Coffee(
        image: map['coffee_image'],
        name: map['coffee_name'],
        type: map['coffee_type'],
        review: 0,
        desc: '',
        price: map['coffee_price'],
      ),
      quantity: map['quantity'],
      size: map['size'],
      price: map['price'],
    );
  }
}

class Order {
  String id;
  List<OrderItem> items;
  double totalPrice;
  String status;
  DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return Order(
      id: map['id'],
      items: items,
      totalPrice: map['total_price'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
