import 'package:flutter/material.dart';
import 'package:klimatic_app/ui/home_ui.dart';


void main()
{
  String title = "Klimatic";
  runApp(new MaterialApp(
    title: title,
    home: new HomeUi(title),
  )
  );
}

