import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';

class MealDetailsScreen extends StatelessWidget{
  const MealDetailsScreen({super.key,required this.meal,required this.onToggleFavorite});
  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;
  

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text(meal.title),
      actions: [
        IconButton(onPressed: (){
          onToggleFavorite(meal);
        }, icon: Icon(Icons.star),),
      ],
    ),
    body: Image.network(
      meal.imageUrl,
      height: 300,
      width: double.infinity,
      fit: BoxFit.cover,

      ),
   );
  }
}