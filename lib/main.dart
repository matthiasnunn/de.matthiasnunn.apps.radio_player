import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:radio_player/pages/player_page.dart';
import 'package:radio_player/utils/my_audio_handler.dart';


late MyAudioHandler audioHandler;


Future<void> main() async {
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelName: "Radio Player"
    )
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const blue = Color.fromRGBO(0, 130, 201, 1);
    return MaterialApp(
      title: "Radio Player",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: blue,
          foregroundColor: Colors.white
        ),
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: blue,
          onPrimary: Colors.white,
          secondary: blue,
          onSecondary: Colors.white,
          error: ThemeData.light().colorScheme.error,
          onError: ThemeData.light().colorScheme.onError,
          surface: const Color.fromRGBO(245, 245, 245, 1),
          onSurface: Colors.black,
          outlineVariant: blue  // color for non deactivatable divider after `DrawerHeader`
        ),
        scaffoldBackgroundColor: Colors.white
      ),
      darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: blue,
          foregroundColor: Colors.white
        ),
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: blue,
          onPrimary: Colors.white,
          secondary: blue,
          onSecondary: Colors.white,
          error: ThemeData.dark().colorScheme.error,
          onError: ThemeData.dark().colorScheme.onError,
          surface: Colors.black,
          onSurface: Colors.white,
          outlineVariant: blue  // color for non deactivatable divider after `DrawerHeader`
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(10, 10, 10, 1)
      ),
      home: PlayerPage()
    );
  }
}
