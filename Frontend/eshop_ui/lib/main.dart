import 'package:flutter/material.dart';
import 'package:eshop_ui/screens/product_catalog.dart';
import 'package:eshop_ui/services/auth_service.dart';
import 'package:eshop_ui/screens/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey, useMaterial3: true),
      home: const HomeWrapper(),
    );
  }
}

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    // Show login dialog after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_loggedIn) {
        _showLoginDialog();
      }
    });
  }

  Future<void> _showLoginDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Must log in
      builder: (context) => const LoginDialog(),
    );

    setState(() {
      _loggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ProductCatalog(), // App is visible in background
        if (!_loggedIn)
          Opacity(
            opacity: 0.5,
            child: const ModalBarrier(
              dismissible: false,
              color: Colors.black45, // dims background
            ),
          ),
      ],
    );
  }
}
