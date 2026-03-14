import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import '../../core/constants/colors.dart';
import '../../core/constants/api_constants.dart';
import '../../services/api_service.dart';

class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({super.key});

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final ApiService _apiService = ApiService();
  
  bool _isUploading = false;
  Uint8List? _imageBytes;
  String? _imageFileName;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageFileName = image.name;
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;
    setState(() => _isUploading = true);

    try {
      String? imageUrl;
      // 1. Upload Image First if selected
      if (_imageBytes != null && _imageFileName != null) {
        imageUrl = await _apiService.uploadImage(_imageBytes, _imageFileName!);
      }

      // 2. Save Product to Database
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'image_url': imageUrl ?? '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product & Image Live!')));
          _nameController.clear();
          _priceController.clear();
          setState(() => _imageBytes = null);
        }
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Merchant Hub'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Upload New Product', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            // Image Picker Box
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.5), style: BorderStyle.solid),
                ),
                child: _imageBytes != null 
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_imageBytes!, fit: BoxFit.cover))
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.primary),
                        SizedBox(height: 8),
                        Text('Tap to select product image', style: TextStyle(color: AppColors.primary)),
                      ],
                    ),
              ),
            ),
            const SizedBox(height: 24),

            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price (\$)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadProduct,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.all(16)),
              child: _isUploading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.primary)) 
                : const Text('Publish to Store', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
