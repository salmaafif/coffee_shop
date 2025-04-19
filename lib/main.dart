import 'package:coffee_shop/database/order_service.dart';
import 'package:coffee_shop/models/coffee.dart';
import 'package:coffee_shop/pages/detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_shop/pages/onboard_page.dart';
import 'package:coffee_shop/pages/dashboard.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderService()), // Provide OrderService at app level
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffF9F9F9),
          textTheme: GoogleFonts.soraTextTheme(),
        ),
        home: const OnBoardPage(),
        routes: {
          '/dashboard': (context) {
            //mengecek apakah ada argumen untuk tab index
            final args = ModalRoute.of(context)?.settings.arguments;
            int initialTabIndex = 0;
            if (args != null && args is int) {
              initialTabIndex = args;
            }
            return DashboardPage(initialTabIndex: initialTabIndex);
          },
          '/detail': (context) {
            Coffee coffee = ModalRoute.of(context)!.settings.arguments as Coffee;
            return DetailPage(coffee: coffee);
          }
        },
      ),
    );
  }
}
