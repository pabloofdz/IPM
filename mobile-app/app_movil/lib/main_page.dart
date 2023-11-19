import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_movil/mobile.dart';
import 'package:app_movil/tablet.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:app_movil/edamam.dart';

import 'detailed_info.dart'; //Lo que vamos a usar para consultar las recetas

const String app_title = "Recipes App";
const int breakPoint = 600; //Límite de tamaño para cambiar entre móvil y táblet

const int CONNECTION_ERROR = 2;
const int SERVER_ERROR = 1;

//---


/*

TESTS:

LISTA RECETAS (Y ERROR)

CARGAR SIGUIENTE BLOQUE RECETAS

ABRIR DETALLES

*/


//----
class RecipesApp extends StatelessWidget {
  final String title;

  const RecipesApp({super.key, this.title = app_title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainMenu(title: app_title),
    );
  }
}


/*
---------------------------------------INICIO ELEGIR MÓVIL O TABLET----------------------------------------------------------
*/

class MasterDetail extends StatelessWidget { 
  final String title;
  final List<String> arguments;
  
  const MasterDetail({super.key, required this.title, required this.arguments});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool chooseMasterAndDetail = (
          constraints.smallest.longestSide > breakPoint &&
          MediaQuery.of(context).orientation == Orientation.landscape
        );
        context.read<NavigationModel>().setTablet(chooseMasterAndDetail);
        if (chooseMasterAndDetail) {
          return MasterAndDetailScreen(title: title, arguments: arguments);
        }
        else {
          return RecipesListScreen(title: title, arguments: arguments);
        }
      }
    );
  }
}


/*
---------------------------------------FIN ELEGIR MÓVIL O TABLET----------------------------------------------------------
*/


/*
---------------------------------------INICIO CLASE CON BARRA DE BÚSQUEDA----------------------------------------------------------
*/
 
 
 
class NavigationModel extends ChangeNotifier{ 
  
  bool tablet=false;
  String cont="";
  List<String> conts = <String>[""];
  
  void resetContsList () {
    conts=[""];
  }
  
  void setTablet (bool value) {
    tablet = value;
  }

  void setCont (String value) {
    cont=value;
    if(conts.last != value){
      conts.add(value);
    }
    notifyListeners();
  }  
  
}
 
class RecipeModel extends ChangeNotifier{
  var recipeBlock;

  void setRecipeBlockNull () {
    recipeBlock = null;
    notifyListeners();
  }

  void fetchRecipesBlock(String keyword, String filter, String cont) {
    recipeBlock=null;
    var futureRecipeBlock = search_recipes(keyword, filter, cont);
    futureRecipeBlock.then((retrievedBlock) {
      recipeBlock=retrievedBlock;
      notifyListeners();
    },
    onError: (e) {
      if (e is SocketException)
        recipeBlock = CONNECTION_ERROR;
      else 
        recipeBlock = SERVER_ERROR;
      notifyListeners();
    });
  }
}

class SelectedRecipeModel extends ChangeNotifier{
  var selectedRecipe;

  void setSelectedRecipe (var value) {
    selectedRecipe=null;
    selectedRecipe=value;
    notifyListeners();
  }
}
  
 
class MainMenu extends StatefulWidget { 
  const MainMenu({super.key, required this.title});
  final String title;
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  
  String keyword="";
  String filter="";
  List<String> arguments=[];
    
  
  bool correctSearch(String filter) {
    if ( filter == '' ) {
      return false;
    }
    return true;      
  }
  
  List<String> listaDeOpciones = <String>["Breakfast","Dinner","Lunch","Snack","Teatime"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontFamily: 'Lobster', color: Colors.white)),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
    child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  Image.asset('assets/logo_recipesApp.jpg', width: 250),
                  TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: 'Enter a keyword (chicken, fish...)',
                    ),
                    onChanged: (String value) async { //CONTROLA CUANDO LE DOY A ENTER
                      keyword=value;
                    }
                  ),
                  DropdownButtonFormField(
                      key: const ValueKey('dropdown'),
                      items:listaDeOpciones.map((e){
                        /// Ahora creamos "e" y contiene cada uno de los items de la lista.
                        return DropdownMenuItem(
                            value: e,
                            child: Text(e)
                        );
                      }).toList(),
                      hint: Container(
                        child: Text('Select a meal type',),
                      ),
                      onChanged:(String? value){
                        filter=value!;
                      }
                  ),
                  const SizedBox(   //Para añadir separación
                    height: 30,
                  ),
                  MaterialButton(
                    minWidth: 200.0,
                    height: 40.0,
                    onPressed: () async {
                      if (!correctSearch(filter)){
                         await showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('ERROR!', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
                              content: const Text(
                                  'Select one MealType', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
                                ),
                              ],
                            );
                          },
                        );
                      }else{
                        context.read<ExpansionPanelModel>().reset();
                        context.read<SelectedRecipeModel>().setSelectedRecipe(null);
                        context.read<NavigationModel>().resetContsList();
                        context.read<NavigationModel>().setCont("");
                        arguments=[keyword, filter];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MasterDetail(title:app_title, arguments: arguments)
                          ),
                        );
                      }
                    },
                    color: Colors.teal,
                    child: const Text('Search', style: TextStyle(fontFamily: 'Lobster', color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),

    );
  }
}

/*
--------------------------------------- FIN CLASE CON BARRA DE BÚSQUEDA----------------------------------------------------------
*/








