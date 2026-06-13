// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/profile_service.dart';

// class MyProfilePage extends StatefulWidget {
//   const MyProfilePage({super.key});

//   @override
//   State<MyProfilePage> createState() => _MyProfilePageState();
// }

// class _MyProfilePageState extends State<MyProfilePage> {
//   final ProfileService _service = ProfileService();
//   final ImagePicker _picker = ImagePicker();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();

//   bool isLoading = true;
//   bool isEdit = false;

//   String? imageUrl;
//   XFile? pickedImage;

//   @override
//   void initState() {
//     super.initState();
//     loadProfile();
//   }

//   Future<void> loadProfile() async {
//     final data = await _service.getProfile();
//     nameController.text = data['fullName'] ?? '';
//     emailController.text = data['email'] ?? '';
//     imageUrl = data['imageUrl'];
//     setState(() => isLoading = false);
//   }

//   Future<void> pickImage() async {
//     final img = await _picker.pickImage(source: ImageSource.gallery);
//     if (img != null) {
//       setState(() => pickedImage = img);
//     }
//   }

//   // Future<void> saveChanges() async {
//   //   setState(() => isLoading = true);

//   //   final user = _service.getCurrentUser();
//   //   if (user == null) return;

//   //   String? newImageUrl = imageUrl;

//   //   if (pickedImage != null) {
//   //     newImageUrl = await _service.uploadProfileImage(user.uid, pickedImage!);
//   //   }

//   //   await _service.updateProfile(
//   //     fullName: nameController.text,
//   //     imageUrl: newImageUrl,
//   //   );

//   //   if (emailController.text != user.email) {
//   //     await _service.updateEmail(emailController.text);
//   //   }

//   //   setState(() {
//   //     imageUrl = newImageUrl;
//   //     pickedImage = null;
//   //     isEdit = false;
//   //     isLoading = false;
//   //   });
//   // }
//   Future<void> saveChanges() async {
//     setState(() => isLoading = true);

//     final user = _service.getCurrentUser();
//     if (user == null) {
//       setState(() => isLoading = false);
//       return;
//     }

//     try {
//       String? newImageUrl = imageUrl;

//       if (pickedImage != null) {
//         newImageUrl = await _service.uploadProfileImage(user.uid, pickedImage!);
//       }

//       // تحديث الاسم والصورة
//       await _service.updateProfile(
//         fullName: nameController.text,
//         imageUrl: newImageUrl,
//       );

//       // تحديث الإيميل مع التعامل مع requires-recent-login
//       if (emailController.text != user.email) {
//         try {
//           await _service.updateEmail(emailController.text);
//         } on FirebaseAuthException catch (e) {
//           if (e.code == 'requires-recent-login') {
//             final password = await showPasswordDialog();
//             if (password == null) {
//               setState(() => isLoading = false);
//               return;
//             }

//             await _service.reAuthenticate(password);
//             await _service.updateEmail(emailController.text);
//           } else {
//             rethrow;
//           }
//         }
//       }

//       setState(() {
//         imageUrl = newImageUrl;
//         pickedImage = null;
//         isEdit = false;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Something went wrong')));
//     }
//   }

//   Future<String?> showPasswordDialog() async {
//     final controller = TextEditingController();

//     return await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Confirm Password'),
//           content: TextField(
//             controller: controller,
//             obscureText: true,
//             decoration: const InputDecoration(labelText: 'Password'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, controller.text);
//               },
//               child: const Text('Confirm'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           IconButton(
//             icon: Icon(isEdit ? Icons.close : Icons.edit),
//             onPressed: () => setState(() => isEdit = !isEdit),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: isEdit ? pickImage : null,
//               child: Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: pickedImage != null
//                         ? FileImage(File(pickedImage!.path))
//                         : imageUrl != null
//                         ? NetworkImage(imageUrl!) as ImageProvider
//                         : const AssetImage('assets/avatar.png'),
//                   ),
//                   if (isEdit)
//                     CircleAvatar(
//                       radius: 16,
//                       backgroundColor: colors.primary,
//                       child: Icon(
//                         Icons.camera_alt,
//                         size: 16,
//                         color: colors.onPrimary,
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             TextField(
//               controller: nameController,
//               enabled: isEdit,
//               style: theme.textTheme.bodyLarge,
//               decoration: const InputDecoration(labelText: 'Full Name'),
//             ),

//             const SizedBox(height: 12),

//             TextField(
//               controller: emailController,
//               enabled: isEdit,
//               style: theme.textTheme.bodyLarge,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),

//             const Spacer(),

//             if (isEdit)
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: saveChanges,
//                   child: const Text('Save Changes'),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profile_service.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final ProfileService _service = ProfileService();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isLoading = true;
  bool isEdit = false;

  String? imageUrl;
  XFile? pickedImage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await _service.getProfile();
    nameController.text = data['fullName'] ?? '';
    emailController.text = data['email'] ?? '';
    imageUrl = data['imageUrl'];
    setState(() => isLoading = false);
  }

  Future<void> pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => pickedImage = img);
    }
  }

  Future<void> saveChanges() async {
    setState(() => isLoading = true);

    try {
      String? newImageUrl = imageUrl;

      if (pickedImage != null) {
        newImageUrl = await _service.uploadProfileImage('mockedUid', pickedImage!);
      }

      // تحديث الاسم والصورة
      await _service.updateProfile(
        fullName: nameController.text,
        imageUrl: newImageUrl,
      );

      // تحديث الإيميل 
      if (emailController.text != 'guest@example.com') {
        await _service.updateEmail(emailController.text);
      }

      setState(() {
        imageUrl = newImageUrl;
        pickedImage = null;
        isEdit = false;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      // setState(() => isLoading = false);
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('Something went wrong')));
    }
  }

  Future<String?> showPasswordDialog() async {
    final controller = TextEditingController();

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C3A2A),
          title: const Text(
            'Confirm Password',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF59E329)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF59E329),
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF59E329),
              ),
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0E1F16),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF59E329)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E1F16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1C0F),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEdit ? Icons.close : Icons.edit, color: Colors.white),
            onPressed: () => setState(() => isEdit = !isEdit),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ================= AVATAR =================
                GestureDetector(
                  onTap: null,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF59E329),
                        backgroundImage: pickedImage != null
                            ? FileImage(File(pickedImage!.path))
                            : imageUrl != null
                            ? NetworkImage(imageUrl!) as ImageProvider
                            : null,
                        child: pickedImage == null && imageUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.black,
                              )
                            : null,
                      ),
                      // if (isEdit)
                      //   CircleAvatar(
                      //     radius: 16,
                      //     backgroundColor: const Color(0xFF59E329),
                      //     child: const Icon(
                      //       Icons.camera_alt,
                      //       size: 16,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ================= NAME =================
                Text(
                  nameController.text.isEmpty ? 'User' : nameController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  emailController.text,
                  style: const TextStyle(color: Colors.white54),
                ),

                const SizedBox(height: 30),

                // ================= EDIT FIELDS =================
                if (isEdit) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C3A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: nameController,
                      onChanged: (value) => setState(() {}),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C3A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: emailController,
                      onChanged: (value) => setState(() {}),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF59E329),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: saveChanges,
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C3A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: Text(
                        nameController.text.isEmpty
                            ? 'Full Name'
                            : nameController.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C3A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.email, color: Colors.white),
                      title: Text(
                        emailController.text.isEmpty
                            ? 'Email'
                            : emailController.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
