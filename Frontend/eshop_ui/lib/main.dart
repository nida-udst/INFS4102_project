import 'package:flutter/material.dart';
import 'package:eshop_ui/screens/product_catalog.dart';
import 'package:eshop_ui/services/auth_service.dart';
import 'package:eshop_ui/screens/login_screen.dart';

// theme controller used by NavBar to toggle dark/light mode
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'E-Shop',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blueGrey,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF263238), // blueGrey[900]
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorSchemeSeed: Colors.blueGrey,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
            ),
          ),
          home: const HomeWrapper(),
        );
      },
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
