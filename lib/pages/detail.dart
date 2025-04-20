import 'package:coffee_shop/database/order_service.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop/models/coffee.dart';
import 'package:coffee_shop/widgets/button_primary.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';


class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.coffee});
  final Coffee coffee;

  @override
  State<DetailPage> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  String sizeSelected = 'R';
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Gap(68),
          buildHeader(),
          const Gap(24),
          buildImage(),
          const Gap(20),
          buildMainInfo(),
          const Gap(20),
          buildDescription(),
          const Gap(30),
          buildSize(),
          const Gap(24),
          buildQuantity(),
          const Gap(24),
        ],
      ),
      bottomNavigationBar: buildPrice(),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const ImageIcon(AssetImage('assets/ic_arrow_left.png')),
        ),
        const Text(
          'Detail',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const ImageIcon(AssetImage('assets/ic_heart_border.png')),
        ),
      ],
    );
  }

  Widget buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        widget.coffee.image,
        width: double.infinity,
        height: 202,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.coffee.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xff242424),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(4),
                Text(
                  widget.coffee.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Color(0xffA2A2A2),
                  ),
                ),
                const Gap(16),
                Row(
                  children: [
                    // Image.asset('assets/ic_star_filled.png',
                    // width: 20, height: 20),
                    const Gap(4),
                    Text(
                      '(${widget.coffee.review})',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Color(0xffA2A2A2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children:
                  ['assets/bike.png', 'assets/bean.png', 'assets/milk.png'].map(
                    (e) {
                      return Container(
                        margin: const EdgeInsets.only(left: 12),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xffEDEDED).withOpacity(0.35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(e, height: 24, width: 24),
                      );
                    },
                  ).toList(),
            ),
          ],
        ),
        const Gap(16),
        const Divider(
          indent: 16,
          endIndent: 16,
          color: Color(0xffE3E3E3),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Widget buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        const Gap(8),
        ReadMoreText(
          widget.coffee.desc,
          trimLength: 110,
          trimMode: TrimMode.Length,
          trimCollapsedText: 'Read More',
          trimExpandedText: 'Read Less',
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: Color(0xffA2A2A2),
          ),
          moreStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xffC67C4E),
          ),
          lessStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xffC67C4E),
          ),
        ),
      ],
    );
  }

  Widget buildSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        const Gap(16),
        Row(
          children:
              ['R', '', 'L', '', 'J'].map((e) {
                if (e == '') return const Gap(16);

                bool isSelected = sizeSelected == e;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      sizeSelected = e;
                      setState(() {});
                    },
                    child: Container(
                      height: 41,
                      decoration: BoxDecoration(
                        color: Color(isSelected ? 0xffF9F2ED : 0xffFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(isSelected ? 0xffC67C4E : 0xffE3E3E3),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        e,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Color(isSelected ? 0xffC67C4E : 0xff242424),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget buildQuantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        const Gap(16),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffF9F9F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed:
                        quantity > 1
                            ? () {
                              setState(() {
                                quantity--;
                              });
                            }
                            : null,
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPrice() {
    double price = widget.coffee.price;

    // Apply price adjustment based on size
    if (sizeSelected == 'L') {
      price += 5000;
    } else if (sizeSelected == 'J') {
      price += 10000;
    }

    // Multiply by quantity
    double totalPrice = price * quantity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Price',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color(0xff909090),
                  ),
                ),
                const Gap(4),
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(totalPrice),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xffC67C4E),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 217,
            child: ButtonPrimary(
              title: 'Add to Cart',
              onTap: () {
                _addToCart(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final orderService = Provider.of<OrderService>(context, listen: false);

    orderService.addToCart(widget.coffee, quantity, sizeSelected);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.coffee.name} added to cart'),
        backgroundColor: const Color(0xffC67C4E),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            // Navigasi ke halaman dashboard dengan tab cart (index 2)
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/dashboard',
              (route) => false,
              arguments: 2,
            ); // Passing index tab cart
            // Navigate to cart tab
            // You'll need to implement this navigation
          },
        ),
      ),
    );
  }
}
