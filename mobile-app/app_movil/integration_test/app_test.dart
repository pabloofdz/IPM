//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app_movil/main.dart' as app;

/*

TESTS:

LISTA RECETAS (Y ERROR)

CARGAR SIGUIENTE BLOQUE RECETAS

ABRIR DETALLES

*/


void main () {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('end-to-end test', () {
    testWidgets('correct recipes list', (tester) async {
      app.main();
      await tester.pumpAndSettle(); //Espera a que se cargue la interfaz
      final mealType = find.byKey(const ValueKey('dropdown'));
      await tester.ensureVisible(mealType);
      expect(mealType, findsOneWidget);
      await tester.tap(mealType);
      await tester.pumpAndSettle();
      final type = find.text('Dinner').last;
      await tester.ensureVisible(type);
      expect(type, findsOneWidget);
      await tester.tap(type);
      await tester.pumpAndSettle();
      final searchBar = find.text('Search');
      await tester.ensureVisible(searchBar);
      expect(searchBar, findsOneWidget);
      await tester.tap(searchBar);
      await tester.pumpAndSettle();
      final scrollableListview = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      );
      expect(scrollableListview, findsOneWidget);
      
    });
    
    testWidgets('error searching recipes: No recipes found', (tester) async {
      app.main();
      await tester.pumpAndSettle(); //Espera a que se cargue la interfaz
      final textBar = find.byType(TextField);
      await tester.ensureVisible(textBar);
      expect(textBar, findsOneWidget);
      await tester.enterText(textBar, 'cscdscds');
      final mealType = find.byKey(const ValueKey('dropdown'));
      await tester.ensureVisible(mealType);
      expect(mealType, findsOneWidget);
      await tester.tap(mealType);
      await tester.pumpAndSettle();
      final type = find.text('Dinner').last;
      await tester.ensureVisible(type);
      expect(type, findsOneWidget);
      await tester.tap(type);
      await tester.pumpAndSettle();
      final searchBar = find.text('Search');
      await tester.ensureVisible(searchBar);
      expect(searchBar, findsOneWidget);
      await tester.tap(searchBar);
      await tester.pumpAndSettle();
      final error = find.text('No recipes found');
      await tester.ensureVisible(error);
      expect(error, findsOneWidget);
      
    });
    
    testWidgets('error: press previous in the first page', (tester) async {
      app.main();
      await tester.pumpAndSettle(); //Espera a que se cargue la interfaz
      final mealType = find.byKey(const ValueKey('dropdown'));
      await tester.ensureVisible(mealType);
      expect(mealType, findsOneWidget);
      await tester.tap(mealType);
      await tester.pumpAndSettle();
      final type = find.text('Dinner').last;
      await tester.ensureVisible(type);
      expect(type, findsOneWidget);
      await tester.tap(type);
      await tester.pumpAndSettle();
      final searchBar = find.text('Search');
      await tester.ensureVisible(searchBar);
      expect(searchBar, findsOneWidget);
      await tester.tap(searchBar);
      await tester.pumpAndSettle();
      final scrollableListview = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      );
      expect(scrollableListview, findsOneWidget);
      final previousButton = find.text('Previous');
      await tester.ensureVisible(previousButton);
      expect(previousButton, findsOneWidget);
      await tester.tap(previousButton);
      await tester.pumpAndSettle();
      expect(scrollableListview, findsOneWidget);
      final error = find.text('You are already on the first page');
      await tester.ensureVisible(error);
      expect(error, findsOneWidget);
    });

    testWidgets('error: press next in the last page', (tester) async {
      app.main();
      await tester.pumpAndSettle(); //Espera a que se cargue la interfaz
      final textBar = find.byType(TextField);
      await tester.ensureVisible(textBar);
      expect(textBar, findsOneWidget);
      await tester.enterText(textBar, 'pollo');
      final mealType = find.byKey(const ValueKey('dropdown'));
      await tester.ensureVisible(mealType);
      expect(mealType, findsOneWidget);
      await tester.tap(mealType);
      await tester.pumpAndSettle();
      final type = find.text('Snack').last;
      await tester.ensureVisible(type);
      expect(type, findsOneWidget);
      await tester.tap(type);
      await tester.pumpAndSettle();
      final searchBar = find.text('Search');
      await tester.ensureVisible(searchBar);
      expect(searchBar, findsOneWidget);
      await tester.tap(searchBar);
      await tester.pumpAndSettle();
      final scrollableListview = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      );
      expect(scrollableListview, findsOneWidget);
      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      expect(nextButton, findsOneWidget);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(scrollableListview, findsOneWidget);
      final error = find.text('You are already on the last page');
      await tester.ensureVisible(error);
      expect(error, findsOneWidget);
    });

    testWidgets('load next block and precious block of recipes', (tester) async {
      app.main();
      await tester.pumpAndSettle(); //Espera a que se cargue la interfaz
      final mealType = find.byKey(const ValueKey('dropdown'));
      await tester.ensureVisible(mealType);
      expect(mealType, findsOneWidget);
      await tester.tap(mealType);
      await tester.pumpAndSettle();
      final type = find.text('Dinner').last;
      await tester.ensureVisible(type);
      expect(type, findsOneWidget);
      await tester.tap(type);
      await tester.pumpAndSettle();
      final searchBar = find.text('Search');
      await tester.ensureVisible(searchBar);
      expect(searchBar, findsOneWidget);
      await tester.tap(searchBar);
      await tester.pumpAndSettle();
      final scrollableListview = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      );
      expect(scrollableListview, findsOneWidget);
      final nextButton = find.text('Next');
      await tester.ensureVisible(nextButton);
      expect(nextButton, findsOneWidget);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      final previousButton = find.text('Previous');
      await tester.ensureVisible(previousButton);
      expect(previousButton, findsOneWidget);
      await tester.tap(previousButton);
      await tester.pumpAndSettle();
      expect(scrollableListview, findsOneWidget);
    });
    
    testWidgets('see details of a recipe', (tester) async {
      app.main();
      await tester.pumpAndSettle(); //Espera a que se cargue la interfaz
      final mealType = find.byKey(const ValueKey('dropdown'));
      await tester.ensureVisible(mealType);
      expect(mealType, findsOneWidget);
      await tester.tap(mealType);
      await tester.pumpAndSettle();
      final type = find.text('Dinner').last;
      await tester.ensureVisible(type);
      expect(type, findsOneWidget);
      await tester.tap(type);
      await tester.pumpAndSettle();
      final searchBar = find.text('Search');
      await tester.ensureVisible(searchBar);
      expect(searchBar, findsOneWidget);
      await tester.tap(searchBar);
      await tester.pumpAndSettle();
      final scrollableListview = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      );
      expect(scrollableListview, findsOneWidget);
      final recipe = find.text('Strawberry Vodka');
      await tester.ensureVisible(recipe);
      expect(recipe, findsOneWidget);
      await tester.tap(recipe);
      await tester.pumpAndSettle();
      final title = find.text('Strawberry Vodka').last;
      await tester.ensureVisible(title);
      expect(title, findsOneWidget);
      final genericInfo = find.text('\nServings: 14.00\nCalories: 1857.08 kcal\nGlycemic Index: Data not available\nTotal CO2 Emissions: 2367.16 MMTCDE\nCO2 Emissions Class: C\nTotal Time: 36.00 min');
      await tester.ensureVisible(genericInfo);
      expect(genericInfo, findsOneWidget);
      final ingredients = find.byIcon(Icons.expand_more).first; 
      await tester.ensureVisible(ingredients);
      expect(ingredients, findsOneWidget);
      await tester.tap(ingredients);
      await tester.pumpAndSettle();
      final textIngredient = find.text('One bottle (750ml) vodka\n2 pints (about 1 1/4 pounds, 575g) strawberries, organic or unsprayed\n');
      await tester.ensureVisible(textIngredient);
      expect(textIngredient, findsOneWidget);
      final dietLables = find.byIcon(Icons.expand_more).at(2); 
      await tester.ensureVisible(dietLables);
      expect(dietLables, findsOneWidget);
      await tester.tap(dietLables);
      await tester.pumpAndSettle();
      final textDietLabels= find.text('Low-Fat\nLow-Sodium\n');
      await tester.ensureVisible(textDietLabels);
      expect(textIngredient, findsOneWidget);
    });
    
  });
}
