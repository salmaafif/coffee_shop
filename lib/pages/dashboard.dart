import 'package:coffee_shop/pages/fragments/cart_fragment.dart';
import 'package:coffee_shop/pages/fragments/dashboard_fragments.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop/database/order_service.dart';

class DashboardPage extends StatefulWidget {
  final int initialTabIndex;
  
  const DashboardPage({
    super.key, 
    this.initialTabIndex = 0
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late int indexMenu;
  @override
  void initState() {
    super.initState();
    // Gunakan initialTabIndex jika disediakan
    indexMenu = widget.initialTabIndex;
  }
  final menu = [
    {
      'icon': 'assets/home.png',
      'icon_active': 'assets/logotomoro.png',
      'fragment': const HomeFragment(),
    },
    // {
    //   'icon': 'assets/coffee-cup.png',
    //   'icon_active': 'assets/coffee-cup.png',
    //   'fragment': const MenuFragment(),
    // },
    {
      'icon': 'assets/checklist.png',
      'icon_active': 'assets/checklist.png',
      'fragment': const CartFragment(),
    },
    {
      'icon': 'assets/user.png',
      'icon_active': 'assets/user.png',
      'fragment': const Center(child: Text('User')),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderService(),
      child: Consumer<OrderService>(
        builder: (context, orderService, child) {
          return Scaffold(
            body: menu[indexMenu]['fragment'] as Widget,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: List.generate(menu.length, (index) {
                  Map item = menu[index];
                  bool isActive = indexMenu == index;

                  //tampilan keranjang
                  bool showCartBadge =
                      index == 1 && orderService.cartItemCount > 0;

                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        indexMenu = index;
                        setState(() {});
                      },
                      child: SizedBox(
                        height: 70,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Gap(20),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Image.asset(
                                  item[isActive ? 'icon_active' : 'icon'],
                                  width: 24,
                                  height: 24,
                                ),
                                if (showCartBadge)
                                  Positioned(
                                    right: -8,
                                    top: -8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xffC67C4E),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${orderService.cartItemCount}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            if (isActive) const Gap(6),
                            if (isActive)
                              Container(
                                height: 5,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xffC67C4E),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
