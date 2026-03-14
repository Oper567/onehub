import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/api_constants.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';
import '../merchant/merchant_dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  bool _isUploading = false;
  String? _localUploadedImageUrl;

  Future<void> _pickAndUploadProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() => _isUploading = true);
      try {
        final bytes = await image.readAsBytes();
        // Upload to your Node.js server
        final imageUrl = await _apiService.uploadImage(bytes, image.name);
        
        if (imageUrl != null && mounted) {
          setState(() {
            _localUploadedImageUrl = imageUrl;
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile picture updated!')));
          // In a production app, you would also save this URL to the User's row in the database here.
        }
      } catch (e) {
        if (mounted) setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userData;
    final String role = user?['role'] ?? 'buyer';
    
    // Construct the full image URL if one exists
    final serverUrl = ApiConstants.baseUrl.replaceAll('/api', '');
    final displayImageUrl = _localUploadedImageUrl != null ? '$serverUrl$_localUploadedImageUrl' : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Color(0xFF1A237E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          const Text('My Profile', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(user?['full_name'] ?? 'Guest User', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(20)),
                            child: Text(role.toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -45,
                  child: GestureDetector(
                    onTap: _isUploading ? null : _pickAndUploadProfileImage,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: AppColors.background,
                            backgroundImage: displayImageUrl != null ? NetworkImage(displayImageUrl) : null,
                            child: displayImageUrl == null 
                                ? const Icon(Icons.person, size: 50, color: AppColors.primary)
                                : null,
                          ),
                          if (_isUploading)
                            const CircularProgressIndicator(color: AppColors.accent),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt, size: 16, color: AppColors.primary),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 70),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (role == 'seller' || role == 'freelancer') ...[
                    _buildMenuCard(context, Icons.storefront, 'Merchant Dashboard', 'Upload new products to the store', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MerchantDashboard())), iconColor: AppColors.accent),
                    const SizedBox(height: 16),
                  ],
                  _buildMenuCard(context, Icons.shopping_bag_outlined, 'My Orders', 'Track your recent purchases', () {}),
                  const SizedBox(height: 16),
                  _buildMenuCard(context, Icons.logout_rounded, 'Log Out', 'Sign out of your account', () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (r) => false);
                  }, isDestructive: true),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: isDestructive ? Colors.red.withOpacity(0.1) : (iconColor ?? AppColors.primary).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: isDestructive ? Colors.red : (iconColor ?? AppColors.primary)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDestructive ? Colors.red : AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
