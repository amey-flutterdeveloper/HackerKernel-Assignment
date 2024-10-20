import 'dart:io';

import 'package:product_management_app/model/product.dart';
import 'package:product_management_app/pages/add_product_page.dart';
import 'package:product_management_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();


 // Initialize product data from Shared Preferences
  @override
  void initState() {
    super.initState();
    _loadProducts(); // Load products when the page is initialized
  }

  // Load products from Shared Preferences
  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productsData = prefs.getString('products');
    if (productsData != null) {
      List<Product> products = Product.decode(productsData);
      setState(() {
        _products = products;
        _filteredProducts = products; // Filter products for display
      });
    }
  }

  // Save products to Shared Preferences
  Future<void> _saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedProducts = Product.encode(_products);
    await prefs.setString('products', encodedProducts);
  }

  void _searchProduct(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = _products;
      });
    } else {
      setState(() {
        _filteredProducts = _products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _deleteProduct(Product product) {
    setState(() {
      _products.remove(product);
      _filteredProducts = _products;
    });
  }

  void _logout() async {
  
  await _saveProducts(); 

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token'); 
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Product',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchProduct,
            ),
            SizedBox(height: 10),
           Expanded(
            child: _filteredProducts.isEmpty
                ? Center(child: Text('No Products Found'))
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ListTile(
                        leading: product.imagePath!.isNotEmpty
                            ? Image.file(
                                File(product.imagePath!),
                                height: 50, 
                                width: 50, 
                                fit: BoxFit.cover,
                              )
                            : SizedBox(
                                height: 50, 
                                width: 50,
                              ),
                        title: Text(product.name),
                        subtitle: Text('\$${product.price.toString()}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteProduct(product);
                          },
          ),
          );
  }),
          )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage(existingProducts: _products,)),
          );

          if (newProduct != null) {
            setState(() {
              _products.add(newProduct);
              _filteredProducts = _products;
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

