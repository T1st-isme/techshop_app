import 'package:flutter/material.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Order ${index + 1}'),
            subtitle: const Text('Order details'),
            onTap: () {
              // Handle order item tap
            },
          );
        },
      ),
    );
  }
}
