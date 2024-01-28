
import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/meain_drawer.dart';
const  kinitialFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  };
class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
 
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedpageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  Map<Filter,bool> _selectedFilters = kinitialFilters;
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavoriteScreen(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showMessage('Meal is no longer a favorite');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showMessage('Marked as a favorite');
    }
  }

  void selectPage(int index) {
    setState(() {
      _selectedpageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.pop(context);

    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) =>  FiltersScreen(currentFilter: _selectedFilters),
        ),
      );

      setState(() {
             _selectedFilters = result ?? kinitialFilters ;

      });

    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree){
      return  false;
      }
      if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
      return  false;
      }
      if(_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian){
      return  false;
      }
      if(_selectedFilters[Filter.vegan]! && !meal.isVegan){
      return  false;
      }
      return true;
    }).toList();
    Widget activeScreen = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteScreen,
      availableMeals: availableMeals,
    );
    var activePagetitle = 'Categories';

    if (_selectedpageIndex == 1) {
      activeScreen = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteScreen,
      );
      activePagetitle = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePagetitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: _selectedpageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
