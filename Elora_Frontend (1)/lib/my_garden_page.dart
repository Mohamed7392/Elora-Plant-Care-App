import 'package:flutter/material.dart';

class MyGardenPage extends StatefulWidget {
  const MyGardenPage({super.key});

  @override
  State<MyGardenPage> createState() => _MyGardenPageState();
}

class _MyGardenPageState extends State<MyGardenPage> {
  int wateredToday = 3;
  int totalToday = 4;

  bool monsteraNeedsWater = true;

  void showMessage(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("My Garden"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green),
            onPressed: () => showMessage("Add new plant"),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// ===== Top Stats =====
          Row(
            children: const [
              Expanded(
                child: InfoCard(
                  icon: Icons.water_drop,
                  label: "Humidity",
                  value: "45%",
                  iconColor: Colors.lightBlue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: InfoCard(
                  icon: Icons.wb_sunny,
                  label: "Temp",
                  value: "72°F",
                  iconColor: Colors.amber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text("TODAY'S TASKS"),

          const SizedBox(height: 12),
          TaskCard(
            progress: wateredToday / totalToday,
            text: "$wateredToday/$totalToday",
            onView: () => showMessage("Opening schedule"),
          ),

          const SizedBox(height: 24),
          const Text("YOUR COLLECTION"),

          const SizedBox(height: 12),

          /// ===== Monstera =====
          PlantCard(
            name: "Monstera Deliciosa",
            location: "Indoor • Living Room",
            nextWater: monsteraNeedsWater ? "Today" : "In 7 days",
            frequency: "Every 7 days",
            status: monsteraNeedsWater ? "NEEDS WATER" : "HEALTHY",
            statusColor:
                monsteraNeedsWater ? Colors.blue : Colors.green,
            actionText:
                monsteraNeedsWater ? "Water Now" : "Done",
            onAction: () {
              if (monsteraNeedsWater) {
                setState(() {
                  monsteraNeedsWater = false;
                  wateredToday++;
                });
                showMessage("Monstera watered 🌱");
              }
            },
          ),

          /// ===== Snake Plant =====
          const PlantCard(
            name: "Snake Plant",
            location: "Indoor • Bedroom",
            nextWater: "In 5 days",
            frequency: "Every 14 days",
            status: "HEALTHY",
            statusColor: Colors.green,
          ),

          /// ===== Fiddle Leaf Fig =====
          const PlantCard(
            name: "Fiddle Leaf Fig",
            location: "Indoor • Office",
            recommendation: "Skip Water",
            warning: "Soil too moist",
          ),

          const SizedBox(height: 16),

          /// ===== Smart Tip =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                Icon(Icons.lightbulb, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Smart Tip\nMove your Fiddle Leaf Fig closer to the window. Light levels have been low.",
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      /// ===== Bottom Navigation =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          showMessage("Tab $index clicked");
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_florist), label: "My Plants"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Schedule"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Identify"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

/// ================= Widgets =================

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70)),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final double progress;
  final String text;
  final VoidCallback onView;

  const TaskCard({
    super.key,
    required this.progress,
    required this.text,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                color: Colors.green,
              ),
              Text(text),
            ],
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text("Watering Routine\n1 plant remaining"),
          ),
          TextButton(
            onPressed: onView,
            child: const Text("View Schedule"),
          )
        ],
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final String name;
  final String location;
  final String? nextWater;
  final String? frequency;
  final String? status;
  final Color? statusColor;
  final String? actionText;
  final VoidCallback? onAction;
  final String? recommendation;
  final String? warning;

  const PlantCard({
    super.key,
    required this.name,
    required this.location,
    this.nextWater,
    this.frequency,
    this.status,
    this.statusColor,
    this.actionText,
    this.onAction,
    this.recommendation,
    this.warning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(Icons.local_florist, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(location,
                        style: const TextStyle(
                            color: Colors.white70)),
                  ],
                ),
              ),
              if (status != null)
                Chip(
                  label: Text(status!, style: const TextStyle(fontSize: 12)),
                  backgroundColor:
                      statusColor?.withOpacity(0.2),
                ),
            ],
          ),

          if (nextWater != null || frequency != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (nextWater != null)
                    Text("Next: $nextWater"),
                  if (frequency != null)
                    Text("Freq: $frequency"),
                ],
              ),
            ),

          if (recommendation != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Recommendation: $recommendation",
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),

          if (warning != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                warning!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          if (actionText != null)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                child: Text(actionText!),
              ),
            ),
        ],
      ),
    );
  }
}
