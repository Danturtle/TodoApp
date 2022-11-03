
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen/home_screen.dart';

main(){
  runApp(
    const MaterialApp(
      title: "Todo App",
      home: Homescreen(),
    )
  );
}