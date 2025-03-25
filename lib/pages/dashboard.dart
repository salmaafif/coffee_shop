import 'package:coffee_shop/pages/fragments/dashboard_fragments.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int indexMenu = 0;
  final menu = [
    {
      'icon': 'assets/home.png',
      'icon_active': 'assets/logotomoro.png',
      'fragment': const HomeFragment(),
    },
    {
      'icon': 'assets/checklist.png',
      'icon_active': 'assets/bag.gif',
      'fragment': const Center(child: Text('Keranjang')),
    },
    {
      'icon': 'assets/coffee-cup.png',
      'icon_active': 'assets/coffee-cup.png',
      'fragment': const Center(child: Text('Menu')),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: menu[indexMenu]['fragment'] as Widget,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: List.generate(menu.length, (index) {
            Map item = menu[index];
            bool isActive = indexMenu == index;
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
                      Image.asset(
                        item[isActive ? 'icon_active' : 'icon'],
                        width: 24,
                        height: 24,
                      ),
                      // ImageIcon(
                      //   AssetImage(item[isActive ? 'icon_active' : 'icon']),
                      //   size: 24,
                      //   color: Color(isActive ? 0xffC67C4E : 0xffA2A2A2),
                      // ),
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
  }
}
