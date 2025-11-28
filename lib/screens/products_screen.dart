import 'package:flutter/material.dart';
import '../models/navigation_models.dart';
import '../services/navigation_service.dart';

class ProductsScreen extends StatefulWidget {
  final String? categoryId;
  final String? productId;

  const ProductsScreen({super.key, this.categoryId, this.productId});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductNavigationData? _productData;
  String? _selectedProduct;

  @override
  void initState() {
    super.initState();
    // Get data from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = NavigationService.getNavigationData<ProductNavigationData>(context);
      if (data != null) {
        setState(() {
          _productData = data;
        });
      } else if (widget.categoryId != null || widget.productId != null) {
        // Fallback to provided IDs
        setState(() {
          _productData = ProductNavigationData(
            productId: widget.productId ?? 'unknown',
            categoryId: widget.categoryId,
          );
        });
      }
    });
  }

  void _selectProduct(String productName) {
    setState(() {
      _selectedProduct = productName;
    });

    // Return selected product data
    final result = ProductNavigationData(
      productId: 'prod_${DateTime.now().millisecondsSinceEpoch}',
      productName: productName,
      categoryId: _productData?.categoryId,
      price: 99.99,
    );

    NavigationService.navigateBackWithSuccess(
      context: context,
      data: result,
      message: 'Product selected: $productName',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Screen'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_productData != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Information:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_productData!.productName != null)
                        Text('Product: ${_productData!.productName}'),
                      Text('Product ID: ${_productData!.productId}'),
                      if (_productData!.categoryId != null)
                        Text('Category ID: ${_productData!.categoryId}'),
                      if (_productData!.price != null)
                        Text('Price: \$${_productData!.price!.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ] else if (widget.categoryId != null || widget.productId != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.categoryId != null)
                        Text('Category ID: ${widget.categoryId}'),
                      if (widget.productId != null)
                        Text('Product ID: ${widget.productId}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            const Text(
              'Select a Product:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...['Product A', 'Product B', 'Product C'].map((product) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: Text(product),
                  subtitle: Text('Price: \$99.99'),
                  trailing: _selectedProduct == product
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () => _selectProduct(product),
                ),
              );
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                NavigationService.navigateBack(context: context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

