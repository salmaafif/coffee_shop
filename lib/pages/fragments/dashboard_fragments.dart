import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:coffee_shop/models/coffee.dart';
import 'package:intl/intl.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  String? selectedCategory;

  final List<String> categories = [
    'All',
    'Coffee',
    'Master S.O.E Series',
    'Cloud Series',
  ];
  @override
  Widget build(BuildContext context) {
    List<Coffee> filteredCoffeeList =
        selectedCategory == null || selectedCategory == 'All'
            ? coffeeList
            : coffeeList
                .where((coffee) => coffee.type == selectedCategory)
                .toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const Gap(24),
            buildHeader(),
            const Gap(24),
            buildSearch(),
            const Gap(24),
            buildBannerPromo(),
            const Gap(24),
            buildCategories(),
            const Gap(24),
            buildCoffeeList(filteredCoffeeList),
          ],
        ),
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xff111111), Color(0xff313131)],
        ),
      ),
    );
  }

  Widget buildSearch() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Gap(20),
          Image.asset('assets/search.png', width: 20, height: 20),
          const Gap(12),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search coffee',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Color(0xff989898),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xffC67C4E),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Image.asset('assets/ic_filter.png', width: 20, height: 20),
          ),
          const Gap(4),
        ],
      ),
    );
  }

  Widget buildBannerPromo() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xff242424),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset('assets/banner1.png', height: 140),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffED5151),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Promo',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Gap(8),
                const Text(
                  'Buy one get\none FREE',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: Color(0xffB7B7B7),
              ),
            ),
            const Gap(4),
            Row(
              children: [
                const Text(
                  'Pare, Kediri',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff242424),
                  ),
                ),
                const Gap(4),
                Image.asset('assets/ic_arrow_down.png', width: 14, height: 14),
              ],
            ),
          ],
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xffF9F9F9),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Image.asset('assets/notification.png', width: 24, height: 24),
        ),
      ],
    );
  }

  Widget buildCategories() {
    // final categories = [
    //   'All Coffee',
    //   'Cloud Series',
    //   'Outside Series',
    //   'Espresso Brewed Coffee',
    //   'Frappe',
    //   'Non-Coffee Beverage',
    //   'Master S.O.E Series',
    //   'Food and Bakery',
    // ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        const Gap(16),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    // Jika kategori yang sama ditekan lagi, reset filter
                    if (selectedCategory == category) {
                      selectedCategory = 'All';
                    } else {
                      selectedCategory = category;
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xffC67C4E)
                            : const Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color:
                          isSelected ? Colors.white : const Color(0xff242424),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildCoffeeList(List<Coffee> coffees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        //const Gap(16),
        // Tampilkan pesan jika tidak ada kopi yang sesuai dengan filter
        if (coffees.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No coffee found for category "$selectedCategory"',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        // Tampilkan daftar kopi yang difilter
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: coffees.length,
          itemBuilder: (context, index) {
            final coffee = coffees[index];
            return buildCoffeeItem(coffee);
          },
        ),
      ],
    );
  }

  Widget buildCoffeeItem(Coffee coffee) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: coffee);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coffee Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.asset(
                coffee.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coffee Name
                  Text(
                    coffee.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Gap(4),
                  // Coffee Type
                  Text(
                    coffee.type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xffA2A2A2),
                    ),
                  ),
                  const Gap(8),
                  // Price and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currencyFormat.format(coffee.price),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xffC67C4E),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xffFBBE21),
                            size: 16,
                          ),
                          const Gap(2),
                          Text(
                            '${coffee.review / 10}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridCoffee() {
    return GridView.builder(
      itemCount: coffeeList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 238,
        crossAxisSpacing: 15,
        mainAxisSpacing: 24,
      ),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Coffee coffee = coffeeList[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: coffee);
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            decoration: BoxDecoration(
              color: const Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        coffee.image,
                        height: 128,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              const Color(0xff111111).withValues(alpha: 0.3),
                              const Color(0xff313131).withValues(alpha: 0.3),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/search.png',
                              height: 12,
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  coffee.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xff242424),
                  ),
                ),
                const Gap(4),
                Text(
                  coffee.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Color(0xffA2A2A2),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      NumberFormat.decimalPattern()
                          .format(coffee.price)
                          .replaceAll(',', ''),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff050505),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xffC67C4E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
