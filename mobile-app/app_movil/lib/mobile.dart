import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movil/edamam.dart';
import 'package:app_movil/main_page.dart';
import 'package:app_movil/detailed_info.dart';


class RecipesListScreen extends StatefulWidget { 
  const RecipesListScreen({super.key, required this.title, required this.arguments});
  final String title;
  final List<String> arguments;
  @override
  State<RecipesListScreen> createState() => _RecipesListScreen();
}

class _RecipesListScreen extends State<RecipesListScreen> { //DISEÑO MÓVIL
  
  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.
      headline4?.fontSize
    );
    
    return Scaffold (
    appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontFamily: 'Lobster', color: Colors.white)),
    ),
    body: 
      RecipesList(arguments: widget.arguments),
    bottomNavigationBar:
      BottomList()
   );     
  }
}
