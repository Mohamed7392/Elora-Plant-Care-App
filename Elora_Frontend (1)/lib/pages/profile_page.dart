import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/profile_service.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final ProfileService _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1C0F),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF0E1F16),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _profileService.getProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF59E329)),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text(
                      'No profile data',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final profile = snapshot.data!;
                final fullName = profile['fullName'] ?? 'User';
                final email = profile['email'] ?? '';

                return Column(
                  children: [
                    const SizedBox(height: 20),

                    // ================= AVATAR =================
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Color(0xFF59E329),
                      child: Icon(Icons.person, size: 50, color: Colors.black),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      fullName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(email, style: TextStyle(color: Colors.white54)),

                    const SizedBox(height: 30),

                    // ================= ITEMS =================
                    _profileItem(
                      context,
                      icon: Icons.person,
                      title: 'My Profile',
                      onTap: () {
                        Navigator.pushNamed(context, '/myprofile');
                      },
                    ),

                    _profileItem(
                      context,
                      icon: Icons.local_florist,
                      title: 'My Plants',
                      onTap: () {
                        Navigator.pushNamed(context, '/myplants');
                      },
                    ),

                    _profileItem(
                      context,
                      icon: Icons.shopping_bag,
                      title: 'My Orders',
                      onTap: () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),

                    _profileItem(
                      context,
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () {
                        Navigator.pushNamed(context, '/notifications');
                      },
                    ),
                    _profileItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                    _profileItem(
                      context,
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                    _profileItem(
                      context,
                      icon: Icons.admin_panel_settings,
                      title: 'Admin Dashboard',
                      color: const Color(0xFF59E329),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/admin');
                      },
                    ),
                    _profileItem(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Policy',
                      onTap: () {
                        Navigator.pushNamed(context, '/policy');
                      },
                    ),
                    _profileItem(
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                      color: Colors.redAccent,
                      onTap: () {
                        AuthService().logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ================= ITEM WIDGET =================
  Widget _profileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C3A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white38,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
