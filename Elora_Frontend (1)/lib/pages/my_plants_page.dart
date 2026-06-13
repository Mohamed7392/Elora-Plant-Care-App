import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/plants_service.dart';

class MyPlantsPage extends StatefulWidget {
  const MyPlantsPage({super.key});

  @override
  State<MyPlantsPage> createState() => _MyPlantsPageState();
}

class _MyPlantsPageState extends State<MyPlantsPage> {
  final PlantService _service = PlantService();
  bool isLoading = true;
  List<Map<String, dynamic>> myPlants = [];
  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();
    loadMyPlants();

    _uiTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() {}), // تحديث كل دقيقة
    );
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    super.dispose();
  }

  Future<void> loadMyPlants() async {
    final data = await _service.getMyPlants();
    setState(() {
      myPlants = data;
      isLoading = false;
    });
  }

  // Duration getRemainingTime(Timestamp lastWateredAt) {
  //   final last = lastWateredAt.toDate().toLocal();
  //   final nextWatering = last.add(const Duration(hours: 24));
  //   return nextWatering.difference(DateTime.now());
  // }

  Duration getRemainingTime(String lastWateredAt, int frequencyHours) {
    final last = DateTime.parse(lastWateredAt).toLocal(); 
    final nextWatering = last.add(Duration(hours: frequencyHours));
    var remaining = nextWatering.difference(DateTime.now());

    if (remaining.isNegative) {
      // لو الوقت عدّى، نخلي العد يبدأ من جديد
      remaining = remaining + Duration(hours: frequencyHours);
    }

    return remaining;
  }

  String formatRemaining(Duration d) {
    if (d.isNegative) return 'Needs water 💧';
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '$hours h $minutes m';
  }

  void showAddPlantsBottomSheet() async {
    final plants = await _service.getPlants();
    final selected = <String>{};
    int selectedFrequency = 24;
    final TextEditingController customFreqController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F1C0F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16, // to handle keyboard
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Select Plants',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// GRID
                  SizedBox(
                    height: 250, // Reduced to make room for keyboard
                    child: GridView.builder(
                      itemCount: plants.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        final isSelected = selected.contains(plant['id']);

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                selected.remove(plant['id']);
                              } else {
                                selected.add(plant['id']);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C3A2A),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF59E329)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: const Color(0xFF59E329),
                                  backgroundImage: plant['imageUrl'] != null
                                      ? AssetImage(plant['imageUrl']) as ImageProvider
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  plant['name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// FREQUENCY DROPDOWN
                  Row(
                    children: [
                      const Text(
                        'Watering Frequency:',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: selectedFrequency,
                          dropdownColor: const Color(0xFF1C3A2A),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF59E329)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF59E329)),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 12, child: Text('12 Hours')),
                            DropdownMenuItem(value: 24, child: Text('24 Hours')),
                            DropdownMenuItem(value: 48, child: Text('48 Hours (2 Days)')),
                            DropdownMenuItem(value: 72, child: Text('72 Hours (3 Days)')),
                            DropdownMenuItem(value: 168, child: Text('1 Week')),
                            DropdownMenuItem(value: -1, child: Text('Custom (Hours)')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedFrequency = val;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  if (selectedFrequency == -1) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: customFreqController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter custom hours',
                        labelStyle: const TextStyle(color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF59E329)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF59E329)),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  /// ADD BUTTON
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
                      onPressed: () async {
                        int freqToSave = selectedFrequency;
                        if (selectedFrequency == -1) {
                          freqToSave = int.tryParse(customFreqController.text) ?? 24;
                          if (freqToSave <= 0) freqToSave = 24; // fallback
                        }
                        
                        await _service.addMyPlants(selected.toList(), freqToSave);
                        if (context.mounted) Navigator.pop(context);
                        loadMyPlants();
                      },
                      child: const Text(
                        'Add Selected',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1C0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1C0F),
        title: const Text('My Plants', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPlantsBottomSheet,
        backgroundColor: const Color(0xFF59E329),
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
          : myPlants.isEmpty
          ? Center(
              child: Text(
                'No plants yet 🌱',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myPlants.length,
              itemBuilder: (context, index) {
                final plant = myPlants[index];
                final lastWatered = plant['lastWateredAt'].toString();
                final freq = plant['wateringFrequencyHours'] ?? 24;
                final remaining = getRemainingTime(lastWatered, freq);
                return Container(
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
                            image: AssetImage(plant['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                formatRemaining(remaining),
                                style: TextStyle(
                                  color: remaining.isNegative
                                      ? Colors.redAccent
                                      : Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                remaining.isNegative
                                    ? Icons.water_drop
                                    : Icons.schedule,
                                color: remaining.isNegative
                                    ? Colors.blueAccent
                                    : Colors.white70,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await _service.removeMyPlant(plant['docId']);
                          loadMyPlants();
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.white70,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
