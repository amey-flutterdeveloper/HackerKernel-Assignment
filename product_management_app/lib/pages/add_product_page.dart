import 'package:flutter/material.dart';
import '../model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductPage extends StatefulWidget {
  final List<Product> existingProducts;

  AddProductPage({required this.existingProducts}); 

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _addProduct() {
    // Validation
    if (_nameController.text.isEmpty) {
      _showSnackbar('Please enter a product name.');
      return;
    }

    if (_priceController.text.isEmpty) {
      _showSnackbar('Please enter a price.');
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      _showSnackbar('Please enter a valid price.');
      return;
    }

    if (_imagePath == null) {
      _showSnackbar('Please select an image for the product.');
      return;
    }

    // Check for duplicate product names
    if (widget.existingProducts.any((product) => product.name == _nameController.text)) {
      _showSnackbar('Product with this name already exists.');
      return;
    }

    // Create a Product instance
    final product = Product(
      name: _nameController.text,
      price: price,
      imagePath: _imagePath!,
    );

    // Navigate back with the product data
    Navigator.pop(context, product);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            _imagePath == null
                ? Text('No image selected.')
                : Image.file(File(_imagePath!), height: 100, width: 100),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
