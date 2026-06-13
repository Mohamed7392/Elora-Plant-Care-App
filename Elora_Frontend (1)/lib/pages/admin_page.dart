import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final String baseUrl = 'http://127.0.0.1:5000/api/products';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingList = true;
  List<dynamic> _plants = [];

  @override
  void initState() {
    super.initState();
    _fetchPlants();
  }

  Future<void> _fetchPlants() async {
    setState(() => _isLoadingList = true);
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _plants = data['data'];
        });
      }
    } catch (e) {
      print('Error fetching plants: $e');
    } finally {
      setState(() => _isLoadingList = false);
    }
  }

  Future<void> _addPlant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'category': _categoryController.text.trim(),
          'price': double.parse(_priceController.text.trim()),
          'imageUrl': _imageController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plant added successfully to the Market!')),
        );
        _nameController.clear();
        _categoryController.clear();
        _priceController.clear();
        _imageController.clear();
        _fetchPlants(); // Refresh list
      } else {
        throw 'Failed to add plant';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding plant: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePlant(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plant removed from market')),
        );
        _fetchPlants(); // Refresh list
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing plant: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0E1F16),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1C0F),
          title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Color(0xFF59E329),
            labelColor: Color(0xFF59E329),
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(icon: Icon(Icons.add_circle_outline), text: "Add Plant"),
              Tab(icon: Icon(Icons.list_alt), text: "Manage Plants"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAddPlantTab(),
            _buildManagePlantsTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF0F1C0F),
          selectedItemColor: Colors.white54,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          currentIndex: 3, 
          onTap: (index) {
            Navigator.pushReplacementNamed(
              context, 
              '/main_nav', 
              arguments: index
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_florist),
              label: 'My Plants',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Color(0xFF59E329)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPlantTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Plant to Market',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fill in the details below to list a new plant.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Plant Name',
                    icon: Icons.local_florist,
                    validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _categoryController,
                    label: 'Category (e.g. Indoor, Succulents)',
                    icon: Icons.category,
                    validator: (val) => val!.isEmpty ? 'Please enter a category' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Price (\$)',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) return 'Please enter a price';
                      if (double.tryParse(val) == null) return 'Must be a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _imageController,
                    label: 'Image URL',
                    icon: Icons.image,
                    validator: (val) => val!.isEmpty ? 'Please enter an image URL' : null,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF59E329),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _isLoading ? null : _addPlant,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'Publish Plant',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagePlantsTab() {
    if (_isLoadingList) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF59E329)));
    }
    if (_plants.isEmpty) {
      return const Center(
        child: Text("No plants in the market.", style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _plants.length,
      itemBuilder: (context, index) {
        final data = _plants[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1C3A2A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                data['imageUrl'] ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.white54),
              ),
            ),
            title: Text(data['name'] ?? 'Unknown', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("\$${data['price']} • ${data['category'] ?? 'Uncategorized'}", style: const TextStyle(color: Colors.white70)),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1C3A2A),
                    title: const Text("Delete Plant", style: TextStyle(color: Colors.white)),
                    content: const Text("Are you sure you want to delete this plant from the market?", style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deletePlant(data['_id']);
                        },
                        child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: const Color(0xFF59E329)),
        filled: true,
        fillColor: const Color(0xFF1C3A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
