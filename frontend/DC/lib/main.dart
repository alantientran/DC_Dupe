import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Make sure this is imported
import 'utilities/theme_provider.dart'; // Ensure this points to the correct path
import 'package:get/get.dart';
import 'utilities/dependencies.dart' as dependencies;
import 'utilities/routes.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          ThemeProvider(), // Creating the ThemeProvider instance
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
        context); // Access the ThemeProvider instance

    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: themeProvider.themeMode, // Dynamically choose theme
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Memo yes',
      // theme: customTheme(),
      debugShowCheckedModeBanner: false,
      initialBinding: dependencies.InitialBindings(),
      getPages: Routes.pages,
      home: const HomePage(),
    );
  }
}

// -------------------------------------------------------------------------------------------------------------------------------------
// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    //?            last item on list is followed by a comma!
    primary: Color(0xff3872FF), //appbar color
    onPrimary: Colors.white,
    secondary: Color(0xFFF7F8FA), //grey boxes
    onSecondary: Color(0xff21212f),
    surface: Colors.white, //background
    onSurface: Color(0xff21212f),
    onSurfaceVariant:
        Color(0xffadaeb2), //!we put this on top of white and grey boxes!!!!
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff3872FF), //appbar color
      onPrimary: Colors.white,
      secondary: Color(0xFF181a25), //grey boxes
      onSecondary: Color(0xff21212f),
      surface: Color(0xFF0F1018), //background
      onSurface: Colors.white, //! guessed
      onSurfaceVariant: Color(0xffadaeb2), //! guessed
    ));
