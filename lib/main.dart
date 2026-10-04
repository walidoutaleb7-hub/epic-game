import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/epic_game.dart';
import 'game/ui/hud.dart';
import 'game/ui/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const EpicGameApp());
}

class EpicGameApp extends StatelessWidget {
  const EpicGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epic Story',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        body: GameWidget<EpicGame>(
          game: EpicGame(),
          overlayBuilderMap: {
            'mainMenu': (context, game) => MainMenuOverlay(game: game),
            'hud': (context, game) => HudOverlay(game: game),
          },
        ),
      ),
    );
  }
}
