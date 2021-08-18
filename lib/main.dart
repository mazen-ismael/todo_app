import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'layout/home_layout.dart';
import 'package:flutter/services.dart';
import 'package:mazen_flutter_001/shared/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.blue,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomeLayout(),
    );
  }
}
