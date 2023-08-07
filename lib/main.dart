import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:untitled/layout/home_layout.dart';
import 'package:untitled/shared/bloc_observer.dart';

void main() {
  Bloc.observer =MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomeLayout(),

    );
  }
}

