import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/cart_provider.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Hire Experts',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          // Generating dynamic dummy data
          final String serviceId = 'srv_$index';
          final String serviceTitle = 'Expert Developer ${index + 1}';
          final double servicePrice = 500.00 + (index * 100);

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.accent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const Text('Full-Stack Web & Mobile'),
                  const SizedBox(height: 4),
                  Text('\$${servicePrice.toStringAsFixed(2)} Fixed Rate', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ],
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // ADD SERVICE TO CART LOGIC
                  cart.addItem(serviceId, serviceTitle, servicePrice, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$serviceTitle contract added to cart'), 
                      duration: const Duration(seconds: 1),
                      backgroundColor: AppColors.accent,
                    ),
                  );
                },
                child: const Text('Hire'),
              ),
            ),
          );
        },
      ),
    );
  }
}
