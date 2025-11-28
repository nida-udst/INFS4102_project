
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/navigation_bar.dart';
import '../services/product_service.dart';
import '../utils/cart_manager.dart';
import '../services/cart_service.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({super.key});

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  String selectedCategory = "All";
  String sortBy = "None";
  final CartService _cartService = CartService();

  List<Product> filterAndSort(List<Product> products) {
    List<Product> filtered = products;

    // Filter
    if (selectedCategory != "All") {
      filtered = filtered
          .where(
            (p) => p.category.toLowerCase() == selectedCategory.toLowerCase(),
          )
          .toList();
    }

    // Sort
    if (sortBy == "Price: Low to High") {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == "Price: High to Low") {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: bg,
      appBar: const NavBar(title: 'Product Catalog'),
      body: Column(
        children: [
          // 🔥 FILTER + SORT BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Category Filter
                DropdownButton<String>(
                  value: selectedCategory,
                  items: const [
                    DropdownMenuItem(value: "All", child: Text("All")),
                    DropdownMenuItem(
                      value: "Equipment",
                      child: Text("Equipment"),
                    ),
                    DropdownMenuItem(
                      value: "Clothing",
                      child: Text("Clothing"),
                    ),
                    DropdownMenuItem(
                      value: "Supplements",
                      child: Text("Supplements"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedCategory = value!);
                  },
                ),
                const SizedBox(width: 16),
                // Sort Dropdown
                DropdownButton<String>(
                  value: sortBy,
                  items: const [
                    DropdownMenuItem(value: "None", child: Text("None")),
                    DropdownMenuItem(
                      value: "Price: Low to High",
                      child: Text("Price: Low to High"),
                    ),
                    DropdownMenuItem(
                      value: "Price: High to Low",
                      child: Text("Price: High to Low"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => sortBy = value!);
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Product>>(
              future: ProductService.fetchAllProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: textStyle.bodyMedium,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No products available',
                      style: textStyle.bodyMedium,
                    ),
                  );
                }

                final products = filterAndSort(snapshot.data!);

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 3,
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: product.imageURL.isNotEmpty
                                ? Image.network(
                                    product.imageURL,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            product.name,
                            style: textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(product.category, style: textStyle.bodySmall),
                          Text('ID: ${product.id}', style: textStyle.bodySmall),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: textStyle.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ElevatedButton(
                            onPressed: () async {
                              final userEmail =
                                  await CartManager.getUserEmail();
                              if (userEmail == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please login first'),
                                  ),
                                );
                                return;
                              }

                              final productId = product.id.trim();
                              if (productId.isEmpty) {
                                debugPrint(
                                  'Add to cart failed — product.id is empty for product: ${product.name}',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Failed to add: product id missing',
                                    ),
                                  ),
                                );
                                return;
                              }

                              try {
                                debugPrint(
                                  'Adding productId=$productId to cart for user=$userEmail',
                                );
                                await _cartService.incrementQuantity(
                                  userEmail,
                                  productId,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.name} added to cart!',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                debugPrint('Add to cart error: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add product: $e'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Add to Cart'),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

