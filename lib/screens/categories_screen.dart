import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'meals_screen.dart';
import 'meal_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<MealCategory> _categories = [];
  List<MealCategory> _filtered = [];
  bool _isLoading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await ApiService.fetchCategories();
      setState(() {
        _categories = cats;
        _filtered = cats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _filterCategories(String value) {
    setState(() {
      _search = value.toLowerCase();
      _filtered = _categories
          .where((c) => c.name.toLowerCase().contains(_search))
          .toList();
    });
  }

  Future<void> _openRandomMeal() async {
    try {
      final meal = await ApiService.fetchRandomMeal();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(meal: meal),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Categories'),
        actions: [
          IconButton(
            onPressed: _openRandomMeal,
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random recipe',
          ),
        ],
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
                hintText: 'Search categories...',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCategories,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final category = _filtered[index];
                return CategoryCard(
                  category: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealsScreen(
                          categoryName: category.name,
                        ),
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
