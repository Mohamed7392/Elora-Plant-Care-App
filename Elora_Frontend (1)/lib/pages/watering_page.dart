import 'package:flutter/material.dart';

class WateringPage extends StatefulWidget {
  const WateringPage({super.key});

  @override
  State<WateringPage> createState() => _WateringPageState();
}

class _WateringPageState extends State<WateringPage> {
  // Mock watering plants list
  List<Map<String, dynamic>> wateringPlants = [];

  void markAsWatered(Map<String, dynamic> plant) {
    setState(() {
      wateringPlants.removeWhere((p) => p['docId'] == plant['docId']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1C0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1C0F),
        title: const Text('Watering'),
        centerTitle: true,
      ),
      body: wateringPlants.isEmpty
          ? Center(
              child: Text(
                'No plants need watering 🌱',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wateringPlants.length,
              itemBuilder: (context, index) {
                final plant = wateringPlants[index];
                return GestureDetector(
                  onTap: () => markAsWatered(plant),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C3A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(plant['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          plant['plantName'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.water_drop, color: Colors.blueAccent),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
