import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/edamam.dart';
import 'package:app_movil/main_page.dart';
import 'package:app_movil/detailed_info.dart';

class MasterAndDetailScreen extends StatelessWidget { //DISEÑO TÁBLET
  final String title;
  final List<String> arguments;
  
  MasterAndDetailScreen({required this.title, required this.arguments});
   //Todo lo de abajo transforma bottom en widget
  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.
      headline5?.fontSize
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: 'Lobster', color: Colors.white)),
    ),
      body: 
        Row(
          children: <Widget>[
            Flexible(
              flex: 13,
              child: Material(
                elevation: 4.0,
                child: RecipesList(
                  arguments: arguments
                ),
              ),
            ),
            TabletRecipeDetail()
          ],
        ),
      bottomNavigationBar: BottomList()   
    );
  }
}

class TabletRecipeDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final TextStyle fontStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.
      headline5?.fontSize
    );
    Recipe? recipe = context.watch<SelectedRecipeModel>().selectedRecipe;
    return Flexible(
              flex: 27, 
              child: recipe == null
              ? Center(
                  child: Text(
                    'Please select a recipe from the list',
                    style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal),
                    textAlign: TextAlign.center,
                  )
                )  
             : DetailedRecipeTablet(recipe: recipe!),     
          );
  }
}


