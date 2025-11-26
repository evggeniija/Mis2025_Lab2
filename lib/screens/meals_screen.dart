import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String categoryName;

  const MealsScreen({super.key, required this.categoryName});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<MealSummary> _meals = [];
  List<MealSummary> _filtered = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      final meals =
      await ApiService.fetchMealsByCategory(widget.categoryName);
      setState(() {
        _meals = meals;
        _filtered = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // локално пребарување во рамки на категоријата
  void _filterMealsLocal(String value) {
    final query = value.toLowerCase();
    setState(() {
      _filtered = _meals
          .where((m) => m.name.toLowerCase().contains(query))
          .toList();
    });
  }

  // Дополнително: пример како би се користел search.php (ако сакаш да го активираш)
  /*
  Future<void> _searchMealsFromApi(String value) async {
    if (value.isEmpty) {
      setState(() => _filtered = _meals);
      return;
    }
    final all = await ApiService.searchMeals(value);
    setState(() {
      _filtered = all
          .where((m) => m.category == widget.categoryName)
          .toList();
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search meals in this category...',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterMealsLocal,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final meal = _filtered[index];
                return MealGridItem(
                  meal: meal,
                  onTap: () async {
                    final detail =
                    await ApiService.fetchMealDetail(meal.id);
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(meal: detail),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
