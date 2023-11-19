import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_movil/edamam.dart';
import 'package:app_movil/main_page.dart';


class BottomList extends StatelessWidget{

  getCont(String nextBlock){
    List<String> subs1 = nextBlock.split("&_cont=");
    List<String> subs2 = subs1.elementAt(1).split("&type=");
    return subs2.elementAt(0);
  }
  
  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.
      headline5?.fontSize
  );
  return 
    BottomNavigationBar(
          unselectedItemColor: Colors.teal,
          items: const [
          BottomNavigationBarItem(label: "Previous", icon: Icon(Icons.navigate_before)),
          BottomNavigationBarItem(label: "Next", icon: Icon(Icons.navigate_next))
          ],
          onTap: (int index) {
            if (index == 0) {
              var recipeBlock = context.read<RecipeModel>().recipeBlock;
              if (recipeBlock != null && context.read<NavigationModel>().conts.length > 1) {
                context.read<NavigationModel>().conts.removeLast();
                context.read<NavigationModel>().setCont(context.read<NavigationModel>().conts.last);
              }else if (recipeBlock != null){
                  showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('WARNING!', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
                      content: const Text(
                      'You are already on the first page', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
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
              }
            }
            if (index == 1) {
               var recipeBlock = context.read<RecipeModel>().recipeBlock;
               if (recipeBlock != null && recipeBlock.nextBlock != null) {
                 context.read<NavigationModel>().setCont(getCont(recipeBlock.nextBlock!));
               }else if (recipeBlock != null && recipeBlock.nextBlock == null) {
                 showDialog<void>(
                   context: context,
                   builder: (BuildContext context) {
                     return AlertDialog(
                       title: const Text('WARNING!', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
                       content: const Text(
                           'You are already on the last page', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
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
               }
            }
         } 
      );
 }
}

class RecipesListInfo extends StatelessWidget{

  List<String> arguments;
  RecipesListInfo({required this.arguments});

  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.
      headline5?.fontSize
    );
    var recipeBlock = context.watch<RecipeModel>().recipeBlock;
    if (recipeBlock == null){
       return const Center(
        child: CircularProgressIndicator(),
       );
    }
    else{
      if (recipeBlock==SERVER_ERROR || recipeBlock==CONNECTION_ERROR){
        return Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (recipeBlock == SERVER_ERROR)
                    Text('There was an error obtaining recipes', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
                  if (recipeBlock == CONNECTION_ERROR)
                    Text('There was a network error', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
                  ElevatedButton(
                    child: Text('Try again', style: TextStyle(fontFamily: 'Lobster', color: Colors.white)),
                    onPressed: () {
                      String keyword=arguments[0];
                      String filter=arguments[1];
                      String cont = context.read<NavigationModel>().cont; 
                      context.read<RecipeModel>().setRecipeBlockNull();
                      context.read<RecipeModel>().fetchRecipesBlock(keyword, filter, cont);
                    },
                  ),
                ],
              ),
            ),
          );
      }
      else if (recipeBlock.recipes==null){
        return Center(
            child: Text('No recipes found', style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.teal)),
          ); 
      }
      else{
        List<Recipe> recipes = recipeBlock.recipes!;
        return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (BuildContext context, int index) {
                      Recipe recipe = recipes[index]; 
                      return ListTile(
                        leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(recipe.thumbnail!)
                        ),
                        title: Text(recipe.label!, style: TextStyle(fontFamily: 'SignikaNegative', color: Colors.black45, fontSize: 19)),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          context.read<ExpansionPanelModel>().reset();
                          bool tablet = context.read<NavigationModel>().tablet;
                          if (!tablet){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailedRecipeScreen(title:app_title, recipe: recipe)
                              ),
                            );
                          }
                          else{
                            context.read<SelectedRecipeModel>().setSelectedRecipe(recipe);
                          }                         
                        }
                      );
                  }
              );              
         
     }          
    }
}

}
 
class RecipesList extends StatelessWidget {


  List<String> arguments;
  RecipesList({required this.arguments});

  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.
      headline5?.fontSize
    );
    String keyword=arguments[0];
    String filter=arguments[1];
    String cont = context.watch<NavigationModel>().cont;
    context.read<RecipeModel>().fetchRecipesBlock(keyword, filter, cont);
    return RecipesListInfo(arguments: arguments);
    
  }
}


class DetailedRecipeScreen extends StatefulWidget { 
  const DetailedRecipeScreen({super.key, required this.title, required this.recipe});
  final String title;
  final Recipe recipe;
  @override
  State<DetailedRecipeScreen> createState() => _DetailedRecipeScreen();
}


class _DetailedRecipeScreen extends State<DetailedRecipeScreen> { 
  
  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle = TextStyle(
        fontSize: Theme.of(context).textTheme.
        headline4?.fontSize
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontFamily: 'Lobster', color: Colors.white)),
      ),
      body: DetailedRecipeMobile(recipe: widget.recipe),

    );
  }
}



class CommonTitle extends StatelessWidget {

  final Recipe recipe;
  CommonTitle({required this.recipe});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(   //Para añadir separación
         height: 15,
        ),
        Center(
          child: Text(recipe.label!, style: TextStyle(fontFamily: 'Lobster', fontWeight: FontWeight.w400, color: Colors.teal, fontSize: 35))
        ),
        const SizedBox(   //Para añadir separación
         height: 30,
        ),
      ]
    );
  }
}



class CommonHeader extends StatelessWidget{
  final Recipe recipe;
  CommonHeader({required this.recipe});
  
  String tag (var value, bool decimal) {
    if (value == null || value == 0.0)
      return 'Data not available';
    else if (decimal)
      return value.toStringAsFixed(2);
    return value.toString();
  }  

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(fontFamily: 'SignikaNegative', fontWeight: FontWeight.w400, color: Colors.teal, fontSize: 15, height: 1.5);
    return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    const SizedBox(   //Para añadir separación
                      height: 30,
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(recipe.thumbnail!)//ejecutando así aparecen las imágenes: flutter run -d chrome --web-renderer html
                    ),
                      const SizedBox(   //Para añadir separación
                        height: 30,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Source: ', style: style),
                            InkWell(
                              child: new Text(tag(recipe.source, false), style: style),
                              onTap: () => launch(tag(recipe.sourceUrl, false))
                            ),
                          ]
                      ),
                      Text(
                          '\nServings: '+tag(recipe.servings, true) + "\n" +
                          'Calories: '+tag(recipe.calories, true) + " kcal\n" +
                          'Glycemic Index: '+tag(recipe.glycemicIndex, true) + "\n" +
                          'Total CO2 Emissions: '+tag(recipe.totalCO2Emissions, true) + " MMTCDE\n" +
                          'CO2 Emissions Class: '+tag(recipe.co2EmissionsClass, false) + "\n" +
                          'Total Time: '+tag(recipe.totalTime, true) + " min", style: style
                      )
                      ]
        );
  }
}


class ExpansionPanelModel extends ChangeNotifier{
  List<bool> _isOpen=[false,false,false,false,false,false,false,false,false];
  void reset () {
    for(int i=0; i< _isOpen.length; i++) {
      _isOpen[i]=false;
    }
    notifyListeners();
  }
  void setOpen (int i, bool isOpen) {
    _isOpen[i] = !isOpen;
    notifyListeners();
  }

}


class ExpansionPanelRecipes extends StatefulWidget{
  const ExpansionPanelRecipes({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<ExpansionPanelRecipes> createState() => _ExpansionPanelRecipes();
}

class _ExpansionPanelRecipes extends State<ExpansionPanelRecipes> {

  String listToString (List<String> list){

    String returnValue="";
    if(list.isEmpty){
      return 'Data not available\n';
    }
    for (int i = 0 ; i < list.length ; i++) {
      returnValue+="${list[i]}\n";
    }
    return returnValue;
  }

  String nutrientsToString (List<Nutrient> list){
    String returnValue = "";
    if(list.isEmpty){
      return 'Data not available\n';
    }
    for (int i = 0 ; i < list.length ; i++) {
      returnValue+= list[i].toString();
    }
    return returnValue;
  }
  
  @override
  Widget build(BuildContext context) {
  var style = TextStyle(fontFamily: 'SignikaNegative', fontWeight: FontWeight.w400, color: Colors.teal, fontSize: 15, height: 1.5);
  var styleTitles = TextStyle(fontFamily: 'SignikaNegative', fontWeight: FontWeight.w400, color: Colors.black45, fontSize: 15, height: 1.5);
  return ExpansionPanelList(
                          children: [
                            ExpansionPanel(
                              isExpanded: context.watch<ExpansionPanelModel>()._isOpen[0],
                              headerBuilder: (context, isOpen) {
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Ingredients", style: styleTitles));
                              },
                              body: Text(listToString(widget.recipe.ingredients!), style: style),
                            ),
                            ExpansionPanel(
                              isExpanded: context.watch<ExpansionPanelModel>()._isOpen[1],
                              headerBuilder: (context, isOpen) {
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Health Labels", style: styleTitles));
                              },
                              body: Text(listToString(widget.recipe.healthLabels!), style: style),
                            ),
                            ExpansionPanel(
                              isExpanded: context.watch<ExpansionPanelModel>()._isOpen[2],
                              headerBuilder: (context, isOpen) {
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Diet Labels", style: styleTitles));
                              },
                              body: Text(listToString(widget.recipe.dietLabels!), style: style),
                            ),
                            ExpansionPanel(
                              isExpanded: context.watch<ExpansionPanelModel>()._isOpen[3],
                              headerBuilder: (context, isOpen) {
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Cautions", style: styleTitles));
                              },
                              body: Text(listToString(widget.recipe.cautions!), style: style),
                            ),
                            ExpansionPanel(
                              isExpanded: context.watch<ExpansionPanelModel>()._isOpen[4],
                              headerBuilder: (context, isOpen) {
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Cuisine Type", style: styleTitles));
                              },
                              body: Text(listToString(widget.recipe.cuisineType!), style: style),
                            ),
                            ExpansionPanel(
                              isExpanded: context.watch<ExpansionPanelModel>()._isOpen[5],
                              headerBuilder: (context, isOpen) {
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Meal Type", style: styleTitles));
                              },
                              body: Text(listToString(widget.recipe.mealType!), style: style),
                            ),
                            ExpansionPanel(
                              isExpanded: context.watch<ExpansionPanelModel>()._isOpen[6],
                              headerBuilder: (context, isOpen) {
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Dish Type", style: styleTitles));
                              },
                              body: Text(listToString(widget.recipe.dishType!), style: style),
                            ),
                            ExpansionPanel(
                              isExpanded: context.watch<ExpansionPanelModel>()._isOpen[7],
                              headerBuilder: (context, isOpen) {
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Total Nutrients", style: styleTitles));
                              },
                              body: Text(nutrientsToString(widget.recipe.totalNutrients!), style: style),
                            ),
                            ExpansionPanel(
                              isExpanded: context.watch<ExpansionPanelModel>()._isOpen[8],
                              headerBuilder: (context, isOpen) {
                                return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Total Daily", style: styleTitles));
                              },
                              body: Text(nutrientsToString(widget.recipe.totalDaily!), style: style),
                            )
                          ],
                          expansionCallback: (i, isOpen) =>
                              context.read<ExpansionPanelModel>().setOpen(i, isOpen)
                      );    
  }
}



class DetailedRecipeMobile extends StatefulWidget{
  const DetailedRecipeMobile({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<DetailedRecipeMobile> createState() => _DetailedRecipeMobile();
}
class _DetailedRecipeMobile extends State<DetailedRecipeMobile> {
  
  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle = TextStyle(
        fontSize: Theme.of(context).textTheme.
        headline4?.fontSize
    );
    return
      SizedBox(
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(30.0),
                child:
                    Column(
                      children:[
                      CommonTitle(recipe: widget.recipe),
                      CommonHeader(recipe: widget.recipe),
                      ExpansionPanelRecipes(recipe: widget.recipe),
                    ])
                    )),
      );
  }
}



class DetailedRecipeTablet extends StatefulWidget{
  
  const DetailedRecipeTablet({super.key, required this.recipe});
  final Recipe recipe;
  @override
  State<DetailedRecipeTablet> createState() => _DetailedRecipeTablet();
}
class _DetailedRecipeTablet extends State<DetailedRecipeTablet> {

  String tag (var value, bool decimal) {
    if (value == null || value == 0.0)
      return 'Data not available';
    else if (decimal)
      return value.toStringAsFixed(2);
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle = TextStyle(
        fontSize: Theme.of(context).textTheme.
        headline4?.fontSize
    );
    return
      SizedBox(
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(30.0),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTitle(recipe: widget.recipe),
                    Row(                    
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.tight,
                            child: CommonHeader(recipe: widget.recipe),
                          ),

                          Flexible(  
                            child: Column(
                              children:[
                               ExpansionPanelRecipes(recipe: widget.recipe),
                              ]
                            )
                          ), 

                     ]
                    )
                   ]
                )
            )),
      );
  }
}


