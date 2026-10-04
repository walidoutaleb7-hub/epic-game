import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/epic_game.dart';
import 'game/ui/achievements_panel.dart';
import 'game/ui/dialogue_box.dart';
import 'game/ui/game_over_screen.dart';
import 'game/ui/hud.dart';
import 'game/ui/main_menu.dart';
import 'game/ui/pause_menu.dart';
import 'game/ui/settings_menu.dart';
import 'game/ui/splash_screen.dart';
import 'game/ui/tutorial_hint.dart';
import 'game/ui/victory_screen.dart';

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
      home: const GameWrapper(),
    );
  }
}

class GameWrapper extends StatefulWidget {
  const GameWrapper({super.key});

  @override
  State<GameWrapper> createState() => _GameWrapperState();
}

class _GameWrapperState extends State<GameWrapper> {
  late final EpicGame _game;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _game = EpicGame();
    _game.overlays.add('splash');
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      _game.overlays.remove('splash');
      setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<EpicGame>(
        game: _game,
        overlayBuilderMap: {
          'splash': (context, game) => const SplashScreenOverlay(),
          'mainMenu': (context, game) => MainMenuOverlay(game: game),
          'hud': (context, game) => HudOverlay(game: game),
          'pauseMenu': (context, game) => PauseMenuOverlay(game: game),
          'settings': (context, game) => SettingsMenuOverlay(onClose: game.closeSettings),
          'achievements': (context, game) => AchievementsPanelOverlay(
                system: game.achievements,
                onClose: game.closeAchievements,
              ),
          'dialogue': (context, game) => DialogueBoxOverlay(
                lines: game.dialogue.getDialogue('intro')!,
                onComplete: () {
                  game.overlays.remove('dialogue');
                  if (game.isPlaying) game.overlays.add('hud');
                },
              ),
          'gameOver': (context, game) => GameOverOverlay(
                onRetry: game.retryLevel,
                onMenu: game.returnToMenu,
                score: game.score,
                kills: game.enemiesKilled,
              ),
          'victory': (context, game) => VictoryOverlay(
                onNextLevel: game.nextLevel,
                onMenu: game.returnToMenu,
                score: game.score,
                isLastLevel: game.levels.isLastLevel,
              ),
          'hint': (context, game) => TutorialHintOverlay(hint: game.currentHint),
        },
      ),
    );
  }
}
