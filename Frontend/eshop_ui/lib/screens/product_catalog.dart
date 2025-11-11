import 'package:eshop_ui/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/Order_Screens.dart'; // <-- import your OrdersPage

class ProductCatalog extends StatelessWidget {
  const ProductCatalog({super.key});
  static List<Product> products = [
    Product(
      id: '1',
      name: 'Sneakers',
      price: 79.99,
      category: 'Clothing',
      desc: 'Comfortable sneakers',
      imageURL: 'https://images.com/sneakers.jpg',
    ),
    Product(
      id: '2',
      name: 'T-Shirt',
      price: 29.99,
      category: 'Clothing',
      desc: 'Casual cotton t-shirt',
      imageURL: 'https://images.com/tshirt.jpg',
    ),
    Product(
      id: '3',
      name: 'Headphones',
      price: 59.99,
      category: 'Accessories',
      desc: 'Wireless headphones',
      imageURL: 'https://images.com/headphones.jpg',
    ),
    Product(
      id: '4',
      name: 'Dumbbell Set',
      price: 49.99,
      category: 'Equipment',
      desc: 'Adjustable dumbbells',
      imageURL: 'https://images.com/dumbbells.jpg',
    ),
    Product(
      id: '5',
      name: 'Water Bottle',
      price: 12.99,
      category: 'Accessories',
      desc: 'Insulated water bottle',
      imageURL: 'https://images.com/waterbottle.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 243, 249),
      appBar: const NavBar(title: 'Product Catalog'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersPage(),
                  ),
                );
              },
              child: const Text('View Orders'),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: products.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(product.imageURL,
                          height: 80, fit: BoxFit.cover),
                      const SizedBox(height: 5),
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(product.category),
                      Text('\$${product.price.toStringAsFixed(2)}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

