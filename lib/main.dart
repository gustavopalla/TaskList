import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list/Classes/tarefa_provider.dart';
import 'package:task_list/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); 
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => TarefaProvider(), 
      child: const MyApp(), // MyApp é o widget raiz
    ),
  );
}
