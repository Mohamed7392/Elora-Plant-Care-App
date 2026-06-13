import 'package:flutter/material.dart';
import 'package:flutter_application_1/favorites_controller.dart';
import 'package:flutter_application_1/services/cart_service.dart';
import 'package:flutter_application_1/services/plants_service.dart';
import 'package:flutter_application_1/services/notification_service.dart';

class PlantDetailsPage extends StatefulWidget {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double price;

  const PlantDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
  });

  @override
  State<PlantDetailsPage> createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> plant = {
      'id': widget.id,
      'name': widget.name,
      'category': widget.category,
      'imageUrl': widget.imageUrl,
      'price': widget.price,
    };
    return Scaffold(
      backgroundColor: const Color(0xFF0F1E17),
      body: SafeArea(
        child: Column(
          children: [
            // IMAGE
            Stack(
              children: [
                Hero(
                  tag: 'plant-image-${widget.name}',
                  child: Image.asset(
                    widget.imageUrl,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 350,
                        width: double.infinity,
                        color: const Color(0xFF1E3A2F),
                        child: const Center(
                          child: Icon(Icons.local_florist, size: 80, color: Colors.greenAccent),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: _circleIcon(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                    favorite: false,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: _circleIcon(
                    icon: Icons.favorite_border,
                    plant: plant,
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
                    favorite: true,
                  ),
                ),
              ],
            ),

            // CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.category,
                              style: const TextStyle(color: Colors.greenAccent),
                            ),
                          ],
                        ),
                        Text(
                          '\$${widget.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'About',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This plant is perfect for your home or garden.', // ممكن تجيب info من Firestore بعدين
                      style: TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 24),

                    // QUANTITY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _qtyBtn('-', () {
                              if (quantity > 1) setState(() => quantity--);
                            }),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            _qtyBtn('+', () {
                              setState(() => quantity++);
                            }),
                          ],
                        ),
                        Text(
                          'Total: \$${(widget.price * quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 200),

                    // BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await CartService().addToCart(
                              plantId: widget
                                  .name, // أو أي معرف فريد للنبات من Firestore
                              name: widget.name,
                              imageUrl: widget.imageUrl,
                              price: widget.price,
                              quantity: quantity,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to cart! 🛒'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            Navigator.pushNamed(context, '/cart');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },

                        child: const Text(
                          'Add to Cart',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon({
    required IconData icon,
    VoidCallback? onTap,
    required bool favorite,
    Map<String, dynamic>? plant,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: favorite
          ? CircleAvatar(
              backgroundColor: Colors.black45,
              child: Icon(
                FavoritesController.isFavorite(plant!['name'])
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.redAccent,
              ),
            )
          : CircleAvatar(
              backgroundColor: Colors.black45,
              child: Icon(icon, color: Colors.white),
            ),
    );
  }

  Widget _qtyBtn(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A2F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
