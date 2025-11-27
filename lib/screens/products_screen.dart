import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  final String? categoryId;
  final String? productId;

  const ProductsScreen({super.key, this.categoryId, this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Screen'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            const Text(
              'Products Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (categoryId != null) ...[
              const SizedBox(height: 20),
              Text(
                'Category ID: $categoryId',
                style: const TextStyle(fontSize: 18),
              ),
            ],
            if (productId != null) ...[
              const SizedBox(height: 10),
              Text(
                'Product ID: $productId',
                style: const TextStyle(fontSize: 18),
              ),
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

