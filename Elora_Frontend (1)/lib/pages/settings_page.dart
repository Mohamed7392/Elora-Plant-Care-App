// import 'package:flutter/material.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF0B2E13),
//               Color(0xFF061B0C),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),

//                 // APP BAR
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back,
//                           color: Colors.white),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     const Spacer(),
//                     const Text(
//                       "Settings",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Spacer(flex: 2),
//                   ],
//                 ),

//                 const SizedBox(height: 30),

//                 _settingItem(
//                   context,
//                   icon: Icons.person,
//                   title: "Profile",
//                   subtitle: "Manage account details",
//                   route: '/profile',
//                 ),

//                 const SizedBox(height: 16),

//                 _settingItem(
//                   context,
//                   icon: Icons.notifications,
//                   title: "Notifications",
//                   subtitle: "Alerts & reminders",
//                   route: '/notifications',
//                 ),

//                 const SizedBox(height: 16),

//                 _settingItem(
//                   context,
//                   icon: Icons.info_outline,
//                   title: "About",
//                   subtitle: "About the application",
//                   route: '/about',
//                 ),

//                 const SizedBox(height: 16),

//                 _settingItem(
//                   context,
//                   icon: Icons.privacy_tip_outlined,
//                   title: "Policy",
//                   subtitle: "Privacy & terms",
//                   route: '/policy',
//                 ),

//                 const SizedBox(height: 40),

//                 // LOGOUT
//                 Container(
//                   width: double.infinity,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(0xFF3A0F0F),
//                         Color(0xFF220909),
//                       ],
//                     ),
//                   ),
//                   child: TextButton.icon(
//                     onPressed: () {
//                       Navigator.pushNamedAndRemoveUntil(
//                         context,
//                         '/login',
//                         (route) => false,
//                       );
//                     },
//                     icon: const Icon(Icons.logout,
//                         color: Colors.redAccent),
//                     label: const Text(
//                       "Log Out",
//                       style: TextStyle(
//                         color: Colors.redAccent,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _settingItem(
//     BuildContext context, {

// required IconData icon,
//     required String title,
//     required String subtitle,
//     required String route,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(22),
//       onTap: () {
//         Navigator.pushNamed(context, route);
//       },
//       child: Container(
//         padding:
//             const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.07),
//           borderRadius: BorderRadius.circular(22),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 22,
//               backgroundColor: Colors.white.withOpacity(0.08),
//               child: Icon(icon,
//                   color: const Color(0xFF5CFF6A)),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios,
//                 color: Colors.white38, size: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1F16),
      body: SafeArea(
        child: Column(
          children: [
            // APP BAR بدون Stack
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ), // نفس عرض الـ IconButton لتوازن اليمين
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SETTINGS LIST
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _settingItem(
                    context,
                    icon: Icons.person,
                    title: "Profile",
                    subtitle: "Manage account details",
                    route: '/profile',
                  ),
                  const SizedBox(height: 16),
                  _settingItem(
                    context,
                    icon: Icons.notifications,
                    title: "Notifications",
                    subtitle: "Alerts & reminders",
                    route: '/notifications',
                  ),
                  const SizedBox(height: 16),
                  _settingItem(
                    context,
                    icon: Icons.info_outline,
                    title: "About",
                    subtitle: "About the application",
                    route: '/about',
                  ),
                  const SizedBox(height: 16),
                  _settingItem(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: "Policy",
                    subtitle: "Privacy & terms",
                    route: '/policy',
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white.withOpacity(0.12),
              child: Icon(icon, color: const Color(0xFF5CFF6A)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
