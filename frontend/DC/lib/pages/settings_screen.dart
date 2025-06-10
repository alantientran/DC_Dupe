import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  
import '../utilities/theme_provider.dart';  // Correct path to ThemeProvider class


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);  // Get ThemeProvider from the context

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Center(
        child: Switch(
          value: themeProvider.themeMode == ThemeMode.dark,  // Check if current theme is dark
          onChanged: (value) {
            themeProvider.toggleTheme();  // Toggle the theme when switch is flipped
          },
        ),
      ),
    );
  }
}

