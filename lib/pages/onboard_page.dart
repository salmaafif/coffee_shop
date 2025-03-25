import 'package:flutter/material.dart';
import 'package:coffee_shop/widgets/button_primary.dart';
import 'package:gap/gap.dart';

class OnBoardPage extends StatelessWidget {
  const OnBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset('assets/kopibg.png'),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    //Colors.transparent,
                    Color.fromARGB(160, 255, 255, 255),
                    //Color.fromARGB(199, 216, 110, 60),
                    Color.fromARGB(255, 240, 129, 78),
                    Color(0xffEE7944),
                    Color.fromARGB(255, 236, 112, 55),
                    
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(40),
                  const Text(
                    'Embrace The Goodness & Yearn for Tomorrow!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const Gap(30),
                  ButtonPrimary(
                    title: 'Get Started',
                    onTap: () {
                      Navigator.pushNamed(context, '/dashboard');
                    },
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
