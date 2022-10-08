import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:info_app/providers/theme_provider.dart';
import 'package:info_app/screeens/search_city_weather.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ListTile(
          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const SearchWeather();
            },
          )),
          leading: const Icon(IconlyLight.location),
          title: const Text(
            'Manage location',
            style: TextStyle(fontSize: 25),
          ),
        ),
        const Divider(thickness: 2),
        SwitchListTile(
          title: ListTile(
            leading: Icon(themeProvider.getDarkTheme
                ? Icons.dark_mode
                : Icons.light_mode),
            title: Text(
              themeProvider.getDarkTheme ? 'Dark' : 'Light',
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          value: themeProvider.getDarkTheme,
          onChanged: (value) {
            setState(() {
              themeProvider.setDarkTheme = value;
            });
          },
        ),
        const Divider(thickness: 2),
      ]),
    );
  }
}
