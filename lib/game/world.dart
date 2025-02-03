import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import './doodle_dash.dart';

class World extends ParallaxComponent {
  final DoodleDash game;

  World(this.game);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    parallax = await game.loadParallax(
      [
        ParallaxImageData('game/graph_paper.png'),
        ParallaxImageData('game/clouds.png'), // Added background layer
      ],
      baseVelocity: Vector2(20, 0), // Adding parallax scrolling effect
      velocityMultiplierDelta: Vector2(1.5, 0), // Depth effect
    );
  }
}