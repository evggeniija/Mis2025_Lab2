import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';

class MealDetailScreen extends StatelessWidget {
  final MealDetail meal;

  const MealDetailScreen({super.key, required this.meal});

  Future<void> _openYoutube() async {
    if (meal.youtubeUrl == null || meal.youtubeUrl!.isEmpty) return;
    final uri = Uri.parse(meal.youtubeUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        actions: [
          if (meal.youtubeUrl != null && meal.youtubeUrl!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_circle_fill),
              onPressed: _openYoutube,
              tooltip: 'Open YouTube',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(meal.thumbnail),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ...meal.ingredients.map(
                  (item) => ListTile(
                dense: true,
                leading: const Icon(Icons.check),
                title: Text(item['ingredient']!),
                trailing: Text(item['measure']!),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(meal.instructions),
          ],
        ),
      ),
    );
  }
}
