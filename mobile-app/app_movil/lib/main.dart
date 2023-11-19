//@dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_movil/main_page.dart';
import 'package:app_movil/detailed_info.dart';
import 'package:app_movil/edamam.dart';

void main() {
  // Si no inicializamos aquí, salta la excepción :(
  // [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: Binding has not
  // yet been initialized.

  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationModel()),
        ChangeNotifierProvider(create: (_) => RecipeModel()),
        ChangeNotifierProvider(create: (_) => SelectedRecipeModel()),
        ChangeNotifierProvider(create: (_) => ExpansionPanelModel())
      ],
      child: const RecipesApp(),
    ),
  );
}
