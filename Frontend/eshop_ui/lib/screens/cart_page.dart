import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import '../utils/cart_manager.dart';
import '../widgets/navigation_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  Future<Cart>? futureCart;
  String? _cartId;

  @override
  void initState() {
    super.initState();
    _initCart();
  }

  Future<void> _initCart() async {
    _cartId = await CartManager.getOrCreateCartId();
    setState(() {
      futureCart = _cartService.getCart(_cartId!);
    });
  }

  Future<void> _refreshCart() async {
    if (_cartId != null) {
      setState(() {
        futureCart = _cartService.getCart(_cartId!);
      });
    }
  }

  Future<void> _incrementItem(String productId) async {
    if (_cartId != null) {
      await _cartService.incrementQuantity(_cartId!, productId);
      _refreshCart();
    }
  }

  Future<void> _decrementItem(String productId) async {
    if (_cartId != null) {
      await _cartService.decrementQuantity(_cartId!, productId);
      _refreshCart();
    }
  }

  Future<void> _removeItem(String productId) async {
    if (_cartId != null) {
      await _cartService.removeFromCart(_cartId!, productId);
      _refreshCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 207, 219),
      appBar: const NavBar(title: 'Shopping Cart'),
      body: futureCart == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Cart>(
              future: futureCart,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }

                final cart = snapshot.data!;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, idx) {
                          final ci = cart.items[idx];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: ci.product.imageURL.isNotEmpty
                                  ? Image.network(
                                      ci.product.imageURL,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              title: Text(
                                ci.product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Price: \$${ci.product.price.toStringAsFixed(2)}\nSubtotal: \$${(ci.product.price * ci.quantity).toStringAsFixed(2)}',
                              ),
                              isThreeLine: true,
                              trailing: SizedBox(
                                width: 140,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () =>
                                          _decrementItem(ci.product.id),
                                    ),
                                    Text('${ci.quantity}'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () =>
                                          _incrementItem(ci.product.id),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          _removeItem(ci.product.id),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${cart.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: cart.items.isEmpty
                                ? null
                                : () async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Checkout: implement order placement',
                                        ),
                                      ),
                                    );
                                  },
                            child: const Text('Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
