import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop/models/order.dart';
import 'package:coffee_shop/database/order_service.dart';
import 'package:coffee_shop/widgets/button_primary.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class CartFragment extends StatelessWidget {
  const CartFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        if (orderService.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffC67C4E)),
          );
        }

        if (orderService.cart == null || orderService.cart!.items.isEmpty) {
          return _buildEmptyCart();
        }

        return _buildCart(context, orderService);
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/bag.gif',
            width: 120,
            height: 120,
          ),
          const Gap(16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(8),
          const Text(
            'Add some delicious coffee to your cart',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xffA2A2A2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCart(BuildContext context, OrderService orderService) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xffF9F9F9),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showClearCartDialog(context, orderService);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orderService.cart!.items.length,
              itemBuilder: (context, index) {
                final item = orderService.cart!.items[index];
                return _buildCartItem(context, item, orderService);
              },
            ),
          ),
          _buildCheckoutSection(context, orderService, currencyFormat),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context, 
    OrderItem item, 
    OrderService orderService
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.coffee.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.coffee.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    '${item.coffee.type} • Size ${item.size}',
                    style: const TextStyle(
                      color: Color(0xffA2A2A2),
                      fontSize: 12,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    currencyFormat.format(item.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xffC67C4E),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    orderService.removeFromCart(item.id);
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: item.quantity > 1
                            ? () {
                                orderService.updateCartItemQuantity(
                                  item.id,
                                  item.quantity - 1,
                                );
                              }
                            : null,
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () {
                          orderService.updateCartItemQuantity(
                            item.id,
                            item.quantity + 1,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(
    BuildContext context, 
    OrderService orderService,
    NumberFormat currencyFormat,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                currencyFormat.format(orderService.cartTotal),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffC67C4E),
                ),
              ),
            ],
          ),
          const Gap(16),
          ButtonPrimary(
            title: 'Checkout',
            onTap: () async {
              String? orderId = await orderService.checkout();
              if (orderId != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed successfully!'),
                    backgroundColor: Color(0xffC67C4E),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, OrderService orderService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              orderService.clearCart();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}