import 'dart:math';

import 'package:flame/components.dart';

import 'doodle_dash.dart';
import 'sprites/platform.dart';

class PlatformManager extends Component with HasGameRef<DoodleDash> {
  final Random random = Random();
  final List<Platform> platforms = [];
  final double maxVerticalDistanceToNextPlatform;
  final double minVerticalDistanceToNextPlatform = 200;

  PlatformManager({required this.maxVerticalDistanceToNextPlatform}) : super();

  @override
  void onMount() {
    var currentY =
        gameRef.size.y - (random.nextInt(gameRef.size.y.floor()) / 3);
    for (var i = 0; i < 9; i++) {
      if (i != 0) {
        currentY = _generateNextY();
      }
      platforms.add(
        Platform(
          position: Vector2(
            random.nextInt(gameRef.size.x.floor()).toDouble(),
            currentY,
          ),
        ),
      );
    }

    for (var platform in platforms) {
      add(platform);
    }

    super.onMount();
  }

  double _generateNextY() {
    final currentHighestPlatformY = platforms.last.center.y;
    final distanceToNextY = minVerticalDistanceToNextPlatform.toInt() +
        random
            .nextInt((maxVerticalDistanceToNextPlatform -
                    minVerticalDistanceToNextPlatform)
                .floor())
            .toDouble();

    return currentHighestPlatformY - distanceToNextY;
  }

  @override
  void update(double dt) {
    final topOfLowestPlatform = platforms.first.position.y;

    final screenBottom = gameRef.dash.position.y +
        (gameRef.size.x / 2) +
        gameRef.screenBufferSpace;

    // When the lowest platform is offscreen, it can be removed and a new platform
    // should be added
    if (topOfLowestPlatform > screenBottom) {
      var newPlatY = _generateNextY();

      // TODO (sprint 2): Update to take into account the width of the platform
      // this way, the platform is not generated and cut off at the side?
      var newPlatX = random.nextInt(gameRef.size.x.floor() - 60).toDouble();
      final newPlat = Platform(position: Vector2(newPlatX, newPlatY));
      add(newPlat);

      // after rendering, add to platforms queue for management
      platforms.add(newPlat);

      // remove the lowest platform
      final lowestPlat = platforms.removeAt(0);
      // remove component from game
      lowestPlat.removeFromParent();
    }
    super.update(dt);
  }
}