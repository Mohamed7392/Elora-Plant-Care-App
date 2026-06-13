
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/plant_detalies_page.dart';
import 'package:flutter_application_1/services/plants_service.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import '../favorites_controller.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';

  final PlantService _plantService = PlantService();

  Future<List<Map<String, dynamic>>> getPlants() async {
    return await _plantService.getPlants();
  }

  List<Map<String, dynamic>> filterPlants(List<Map<String, dynamic>> plants) {
    return plants.where((plant) {
      final matchesCategory =
          selectedCategory == 'All' || plant['category'] == selectedCategory;

      final matchesSearch = plant['name'].toString().toLowerCase().contains(
        searchController.text.toLowerCase(),
      );

      return matchesCategory && matchesSearch;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1F16),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Market',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_checkout_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // SEARCH BAR
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3325),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.white54),
                    hintText: 'Find your perfect plant...',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // CATEGORIES
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoryChip('All'),
                    _categoryChip('Indoor'),
                    _categoryChip('Succulents'),

                    _categoryChip('Outdoor'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // GRID
              // Expanded(
              //   child: GridView.builder(
              //     itemCount: filteredPlants.length,
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       crossAxisSpacing: 14,
              //       mainAxisSpacing: 14,
              //       childAspectRatio: 0.72,
              //     ),
              //     itemBuilder: (context, index) {
              //       final plant = filteredPlants[index];
              //       return _plantCard(plant);
              //     },
              //   ),
              // ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getPlants(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.yellow),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No plants found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final plants = filterPlants(snapshot.data!);

                    return GridView.builder(
                      itemCount: plants.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.72,
                          ),
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        return _plantCard(plant);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(String label) {
    final bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : const Color(0xFF1A3325),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  Widget _plantCard(Map<String, dynamic> plant) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => PlantDetailsPage(
              id: plant['id'],
              name: plant['name'],
              category: plant['category'],
              imageUrl: plant['imageUrl'],
              price: plant['price'].toDouble(),
            ),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FAVORITE BUTTON
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        FavoritesController.toggleFavorite(plant);
                      });
                        if (FavoritesController.isFavorite(plant['name'])) {
                          await PlantService().addMyPlants([plant['id']], 24);
                          await NotificationService.addNotification(
                            'Added to Favorites',
                            '${plant['name']} was saved 🌱',
                            'favorite',
                          );
                          if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved to My Plants 🌱'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        FavoritesController.isFavorite(plant['name'])
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ),

                // IMAGE with Hero and ErrorBuilder
                Expanded(
                  child: Hero(
                    tag: 'plant-image-${plant['name']}',
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          plant['imageUrl'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.white.withOpacity(0.1),
                              child: const Center(
                                child: Icon(Icons.local_florist, size: 40, color: Colors.greenAccent),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  plant['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${plant['price'].toStringAsFixed(2)}', 
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_shopping_cart, color: Colors.black, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
