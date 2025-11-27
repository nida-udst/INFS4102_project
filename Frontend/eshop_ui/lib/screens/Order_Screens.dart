import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';
import '../widgets/navigation_bar.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderService orderService = OrderService();
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = orderService.getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 207, 219),
      appBar: const NavBar(title: 'Orders'),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders yet'));
          } else {
            return ListView(
              children: snapshot.data!.map((order) {
                return Card(
                  child: ListTile(
                    title: Text('Order #${order.id} - ${order.status}'),
                    subtitle: Text(
                      'Total: \$${order.total}\nItems: ${order.items.length}\nDate: ${order.createdAt}',
                    ),
                    isThreeLine: true,
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
