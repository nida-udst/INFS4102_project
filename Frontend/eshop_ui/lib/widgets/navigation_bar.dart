import 'package:eshop_ui/screens/cart_page.dart';
import 'package:flutter/material.dart';
import '../screens/product_catalog.dart';
import '../screens/Order_Screens.dart';
import '../utils/cart_manager.dart';
// import the theme notifier from main.dart
import 'package:eshop_ui/main.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const NavBar({super.key, required this.title});

  Future<void> _logout(BuildContext context) async {
    await CartManager.clearUserEmail();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final appBarBg =
        Theme.of(context).appBarTheme.backgroundColor ?? Colors.blueGrey[900];

    return AppBar(
      backgroundColor: appBarBg,
      title: Text(
        'ESHOP',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Theme.of(context).appBarTheme.foregroundColor ?? Colors.white,
        ),
      ),
      actions: [
        _NavButton(
          label: 'Catalog',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProductCatalog()),
            );
          },
        ),
        _NavButton(
          label: 'Shopping Cart',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
        _NavButton(
          label: 'Orders',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OrdersPage()),
            );
          },
        ),

        // Dark mode toggle button: listens to global themeNotifier
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                icon: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color:
                      Theme.of(context).appBarTheme.foregroundColor ??
                      Colors.white,
                ),
                onPressed: () {
                  themeNotifier.value = isDark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
              );
            },
          ),
        ),

        // Logout button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            tooltip: 'Logout',
            icon: Icon(
              Icons.logout,
              color:
                  Theme.of(context).appBarTheme.foregroundColor ?? Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _logout(context);
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _NavButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).appBarTheme.foregroundColor ?? Colors.white;
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: textColor, fontSize: 16)),
    );
  }
}
