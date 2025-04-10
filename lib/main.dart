import 'package:flutter/material.dart';//import 'package:lms_lms/view/Student/studentcourses.dart';

import 'package:provider/provider.dart';
import 'package:yoga/admin/provider/adminprovider.dart';
import 'package:yoga/bottomnavi.dart';
import 'package:yoga/homescreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Adminprovider()),
        // Add more providers here if needed
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const Studentbottomnav(),
      ),
    );
  }
}
