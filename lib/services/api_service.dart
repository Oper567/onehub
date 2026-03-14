import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class ApiService {
  // 1. Fetch Products
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/products'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  // 2. Escrow Purchase
  Future<bool> purchaseItem(String productId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/transactions/purchase'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productId': productId, 
          'amount': amount
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Purchase Error: $e');
      return false;
    }
  }

  // 3. Image Upload (Multipart)
  Future<String?> uploadImage(dynamic fileBytes, String fileName) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}/upload'));
      
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        fileBytes,
        filename: fileName,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['imageUrl']; // Returns the server path, e.g., "/uploads/123.jpg"
      }
      return null;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }

  // 4. Fetch Messages
  Future<List<dynamic>> fetchMessages() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/messages'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Chat Fetch Error: $e');
      return [];
    }
  }
}
