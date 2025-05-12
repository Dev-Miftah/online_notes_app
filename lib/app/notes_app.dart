import 'package:flutter/material.dart';
import '../routes/app_router.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'Notes App',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
