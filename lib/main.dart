import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/class_Service.dart';
import 'package:spaghetti/startPage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClassService()),
        ChangeNotifierProvider(create: (_) => ClassOpinion()),
      ],
      child: MaterialApp(
        home: PageSlideExample(),
        theme: ThemeData(fontFamily: 'NanumB'),
      ),
    ),
  );
}
