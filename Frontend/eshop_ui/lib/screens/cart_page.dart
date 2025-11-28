import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import '../services/order_service.dart';
import '../utils/cart_manager.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();

  bool loading = true;
  String? userEmail;
  String? _selectedPayment;

  // Form fields
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> loadCart() async {
    userEmail = await CartManager.getUserEmail();

    if (userEmail == null) {
      setState(() => loading = false);
      return;
    }

    try {
      final cart = await _cartService.getCart(userEmail!);
      final List<Map<String, dynamic>> finalItems = [];

      for (var item in cart.items) {
        final productId = item.productId;
        final quantity = item.quantity;

        Product product = await ProductService.fetchProductById(productId);

        finalItems.add({"quantity": quantity, "product": product});
      }

      setState(() {
        cartItems = finalItems;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> _incrementItem(String productId) async {
    if (userEmail != null) {
      try {
        await _cartService.incrementQuantity(userEmail!, productId);
        loadCart();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _decrementItem(String productId) async {
    if (userEmail != null) {
      try {
        await _cartService.decrementQuantity(userEmail!, productId);
        loadCart();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _removeItem(String productId) async {
    if (userEmail != null) {
      try {
        await _cartService.removeFromCart(userEmail!, productId);
        loadCart();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _clearCart() async {
    if (userEmail != null) {
      try {
        await _cartService.clearCart(userEmail!);
        loadCart();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  double _calculateTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      final product = item["product"] as Product;
      final quantity = item["quantity"] as int;
      total += product.price * quantity;
    }
    return total;
  }

  bool _validateForm() {
    if (_fullNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter full name')));
      return false;
    }
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number')),
      );
      return false;
    }
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter address')));
      return false;
    }

    if (_selectedPayment == 'Credit Card' || _selectedPayment == 'Debit Card') {
      if (_cardNumberController.text.isEmpty ||
          _cardNumberController.text.length != 16) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter valid 16-digit card number'),
          ),
        );
        return false;
      }
      if (_cardHolderController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter cardholder name')),
        );
        return false;
      }
      if (_expiryController.text.isEmpty ||
          !RegExp(r'^\d{2}/\d{2}$').hasMatch(_expiryController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter expiry in MM/YY format')),
        );
        return false;
      }
      if (_cvvController.text.isEmpty || _cvvController.text.length != 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid 3-digit CVV')),
        );
        return false;
      }
    }

    return true;
  }

  Future<void> _checkout() async {
    final email = userEmail ?? await CartManager.getUserEmail();
    if (email == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    }

    if (_selectedPayment == null || _selectedPayment!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    if (!_validateForm()) {
      return;
    }

    try {
      final order = await _orderService.placeOrder(email, _selectedPayment!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Order placed — ID: ${order.id}')));
      await _clearCart();
      _clearFormFields();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Checkout failed: $e')));
    }
  }

  void _clearFormFields() {
    _fullNameController.clear();
    _phoneController.clear();
    _addressController.clear();
    _cardNumberController.clear();
    _cardHolderController.clear();
    _expiryController.clear();
    _cvvController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final surface = Theme.of(context).colorScheme.surface;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: bg,
      appBar: const NavBar(title: "My Cart"),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: textStyle.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            )
          : Row(
              children: [
                // Left: Cart Items List
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final Product product = item["product"];
                      final int quantity = item["quantity"];

                      return Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              product.imageURL.isNotEmpty
                                  ? Image.network(
                                      product.imageURL,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.06),
                                      child: const Icon(Icons.image),
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: textStyle.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      product.category,
                                      style: textStyle.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: textStyle.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Subtotal: \$${(product.price * quantity).toStringAsFixed(2)}',
                                      style: textStyle.bodyMedium?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () =>
                                              _decrementItem(product.id),
                                          iconSize: 18,
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(),
                                        ),
                                        SizedBox(
                                          width: 30,
                                          child: Center(
                                            child: Text(
                                              '$quantity',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () =>
                                              _incrementItem(product.id),
                                          iconSize: 18,
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                    onPressed: () => _removeItem(product.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Right: Checkout Sidebar
                Container(
                  width: 350,
                  color: surface,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: textStyle.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Items:'),
                            Text(
                              '${cartItems.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Theme.of(context).dividerColor),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '\$${_calculateTotal().toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Delivery Info Form
                        Text(
                          'Delivery Information',
                          style: textStyle.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 24),
                        // Payment Method
                        Text(
                          'Payment Method',
                          style: textStyle.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          value: _selectedPayment,
                          hint: const Text('Select payment method'),
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'Credit Card',
                              child: Text('Credit Card'),
                            ),
                            DropdownMenuItem(
                              value: 'Debit Card',
                              child: Text('Debit Card'),
                            ),
                            DropdownMenuItem(
                              value: 'Pay Later',
                              child: Text('Pay Later'),
                            ),
                            DropdownMenuItem(
                              value: 'Cash on Delivery',
                              child: Text('Cash on Delivery'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPayment = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Card Details (show only for card payments)
                        if (_selectedPayment == 'Credit Card' ||
                            _selectedPayment == 'Debit Card') ...[
                          Text(
                            'Card Details',
                            style: textStyle.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _cardNumberController,
                            decoration: InputDecoration(
                              labelText: 'Card Number (16 digits)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 16,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _cardHolderController,
                            decoration: InputDecoration(
                              labelText: 'Cardholder Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _expiryController,
                                  decoration: InputDecoration(
                                    labelText: 'Expiry (MM/YY)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _cvvController,
                                  decoration: InputDecoration(
                                    labelText: 'CVV',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 3,
                                  obscureText: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _checkout,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Checkout',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _clearCart,
                            icon: const Icon(Icons.delete_sweep),
                            label: const Text('Clear Cart'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
