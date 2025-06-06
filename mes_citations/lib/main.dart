import 'package:flutter/material.dart';
import 'package:mes_citations/pages/home_page.dart';
import 'package:mes_citations/services/local_storage_service.dart';
import 'bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  StorageService().init();

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    var citationsfav = ['Citation1', 'Citation2', 'Citation3'];
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}


