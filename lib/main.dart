import 'package:flutter/material.dart';

import 'app.dart';
import 'core/firebase/firebase_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseInitializer.initializeFirebase();
  } catch (e) {
    debugPrint('Firebase failed to start: $e');
  }
  runApp(const PlantsFresherApp());
}
