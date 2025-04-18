import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Wrapper extends StatefulWidget {
  const _Wrapper({
    required this.child,
    // ignore: unused_element, unused_element_parameter
    this.small = false,
  });

  final Widget child;
  final bool small;

  @override
  State<_Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<_Wrapper> {
  late bool _small;

  @override
  void initState() {
    super.initState();

    _small = widget.small;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              width: _small ? 50 : 100,
              height: _small ? 50 : 100,
              child: widget.child,
            ),
            ElevatedButton(
              child: const Text('Toggle'),
              onPressed: () {
                setState(() => _small = !_small);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MyGame extends FlameGame {
  int updateCount = 0;
  int renderCount = 0;
  double timePassed = 0;

  @override
  void update(double dt) {
    super.update(dt);
    timePassed += dt;
    updateCount++;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderCount++;
  }
}

void main() {
  FlameTester<_MyGame> myGame({bool paused = false}) {
    return FlameTester(
      () => _MyGame()..paused = paused,
      pumpWidget: (gameWidget, tester) async {
        await tester.pumpWidget(_Wrapper(child: gameWidget));
      },
    );
  }

  myGame().testGameWidget(
    'can pause the engine',
    verify: (game, tester) async {
      // Run two frames
      await tester.pump();
      await tester.pump();

      game.pauseEngine();

      // shouldn't run another frame on the game
      await tester.pump();

      // Remember that there is one initial update(0) called.
      expect(game.updateCount, equals(3));
    },
  );

  myGame().testGameWidget(
    'can resume the engine',
    verify: (game, tester) async {
      // Run two frames
      await tester.pump();
      await tester.pump();

      game.pauseEngine();

      // shouldn't run another frame on the game
      await tester.pump();

      game.resumeEngine();
      await tester.pump();

      // Remember that there is one initial update(0) called.
      expect(game.updateCount, equals(4));
    },
  );

  myGame().testGameWidget(
    "when paused, don't auto start after a rebuild",
    verify: (game, tester) async {
      // Run two frames
      await tester.pump();
      await tester.pump();

      game.pauseEngine();

      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();

      // Remember that there is one initial update(0) called.
      expect(game.updateCount, equals(3));
    },
  );

  myGame(paused: true).testGameWidget(
    'can start paused',
    verify: (game, tester) async {
      // Run two frames
      await tester.pump();
      await tester.pump();

      expect(game.updateCount, equals(0));
    },
  );

  myGame(paused: true).testGameWidget(
    'can start paused and resumed later',
    verify: (game, tester) async {
      // Run two frames
      await tester.pump();
      await tester.pump();

      game.resumeEngine();

      // Run two frames
      await tester.pump();
      await tester.pump();

      expect(game.updateCount, equals(2));
    },
  );

  myGame().testGameWidget(
    'will not add time to dt when paused',
    verify: (game, tester) async {
      const frameLength = Duration(seconds: 1);
      // Run two frames.
      await tester.pump(frameLength);
      await tester.pump(frameLength);

      game.pauseEngine();

      // Run two frames when the engine is paused.
      await tester.pump(frameLength);
      await tester.pump(frameLength);

      game.resumeEngine();
      // This time will be thrown away since the ticker hasn't received its
      // first timestamp yet.
      await tester.pump(const Duration(seconds: 100));
      await tester.pump(frameLength);

      // Remember that there is one initial update(0) after mount
      expect(game.updateCount, equals(5));
      expect(game.timePassed, equals(3));
    },
  );
}
