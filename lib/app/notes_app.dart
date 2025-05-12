import 'package:flutter/material.dart';
import 'package:online_notes/presentation/screens/auth/waiting_for_verification_screen.dart';
import '../routes/app_router.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
     // routerConfig: appRouter,
      title: 'Notes App',
      home: WaitingForVerificationScreen(fullName: ""),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
