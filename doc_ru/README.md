# Начало работы

## О Flame

Flame — это модульный игровой движок на Flutter, предоставляющий полный набор решений, не мешающих разработке игр. Он использует мощную инфраструктуру Flutter, но упрощает код, необходимый для создания ваших проектов.

Он предоставляет простую, но эффективную реализацию игрового цикла и необходимые функции, которые могут понадобиться в игре. Например: ввод, изображения, спрайты, таблицы спрайтов, анимации, обнаружение столкновений и компонентную систему, которую мы называем Flame Component System (сокращённо FCS).

Мы также предоставляем отдельные пакеты, расширяющие функциональность Flame, которые можно найти в разделе [Bridge Packages](bridge_packages/bridge_packages.md).

Вы можете выбрать и использовать любые части, которые вам нужны, так как все они независимы и модульны.

Движок и его экосистема постоянно развиваются сообществом, поэтому не стесняйтесь обращаться, открывать задачи и pull-запросы, а также предлагать улучшения.

Поставьте нам звезду, если хотите помочь распространить движок и развить сообщество. :)


## Установка

Добавьте пакет `flame` в зависимости вашего `pubspec.yaml`, выполнив следующую команду:

```console
flutter pub add flame
```

Актуальную версию можно найти на [pub.dev](https://pub.dev/packages/flame/install).

Затем выполните `flutter pub get`, и вы готовы к работе!


## Начало работы

Существует набор учебных руководств, которые вы можете пройти в
[папке tutorials](https://github.com/flame-engine/flame/tree/main/doc/tutorials).

Простые примеры всех функций можно найти в
[папке examples](https://github.com/flame-engine/flame/tree/main/examples).

Для запуска Flame необходимо использовать `GameWidget`, который является обычным виджетом и может находиться где угодно в дереве виджетов. Вы можете использовать его в качестве корневого виджета приложения или как дочерний элемент другого виджета.

Вот простой пример использования `GameWidget`:

```dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: FlameGame(),
    ),
  );
}
```

Во Flame мы предлагаем концепцию под названием Flame Component System (FCS), которая помогает организовать игровые объекты так, чтобы ими было легко управлять. Подробнее об этом читайте в разделе [Components](flame/components.md).

При создании новой игры вы должны расширить либо класс `FlameGame`, либо класс `World`. `FlameGame` является корнем вашей игры и отвечает за управление игровым циклом и компонентами. Класс `World` — это компонент, который можно использовать для создания игрового мира.

Простой пример игры может выглядеть так:

```dart
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    GameWidget(
      game: FlameGame(world: MyWorld()),
    ),
  );
}

class MyWorld extends World {
  @override
  Future<void> onLoad() async {
    add(Player(position: Vector2(0, 0)));
  }
}
```

Как видите, мы создали класс `MyWorld`, расширяющий `World`. Мы переопределили метод `onLoad`, чтобы добавить компонент `Player` (который пока не существует) в мир. В `FlameGame` по умолчанию есть `camera`, которая наблюдает за миром. Камера по умолчанию смотрит на точку (0, 0) в центре экрана. Подробнее о камере и мире читайте в разделе [Camera Component](flame/camera.md).

Компонент `Player` может быть любым типом компонента, но для начала мы рекомендуем использовать класс `SpriteComponent`, который может отображать спрайт (изображение) на экране.

Например:

```dart
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/extensions.dart';

class Player extends SpriteComponent {
  Player({super.position}) :
    super(size: Vector2.all(200), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
  }
}
```

В этом примере мы создали класс `Player`, расширяющий `SpriteComponent`. Мы переопределили метод `onLoad`, чтобы загрузить спрайт из файла изображения `player.png`. Изображение должно находиться в директории `assets/images` вашего проекта (см. [Assets Directory Structure](flame/structure.md)), и вы должны добавить его в [раздел assets](https://docs.flutter.dev/ui/assets/assets-and-images) файла `pubspec.yaml`.

В этом классе мы также устанавливаем размер компонента 200x200 и [anchor](flame/components.md#anchor) в центр компонента через конструктор `super`. Мы также позволяем пользователю установить позицию компонента при создании (`Player(position: Vector2(0, 0))`).

Чтобы обрабатывать ввод для компонента, вы можете добавить один из [input mixins](flame/inputs/inputs.md) к компоненту. Например, если вы хотите обрабатывать касания, добавьте миксин `TapCallbacks` к компоненту игрока, и вы будете получать события касания в пределах компонента. Или, если вы хотите обрабатывать касания по всему миру, добавьте `TapCallbacks` к расширенному классу `World`.

Следующий пример обрабатывает касания компонента игрока. При касании его размер увеличивается на 50 пикселей по ширине и высоте:

```dart
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/extensions.dart';

class Player extends SpriteComponent with TapCallbacks {
  Player({super.position}) :
    super(size: Vector2.all(200), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
  }
  
  @override
  void onTapUp(TapUpEvent info) {
    size += Vector2.all(50);
  }
}
```

Это всего лишь простой пример начала работы с Flame. Существует множество других функций, которые вы можете использовать (и, вероятно, понадобятся) для создания вашей игры, но это должно дать хорошую отправную точку.

Вы также можете заглянуть в [awesome flame repository](https://github.com/flame-engine/awesome-flame#user-content-articles--tutorials), там собраны отличные руководства и статьи от сообщества, которые помогут вам начать работу с Flame.


## За пределами возможностей движка

Игры иногда требуют сложных наборов функций в зависимости от того, о чём сама игра. Некоторые из этих возможностей выходят за рамки экосистемы Flame Engine. В этом разделе вы найдёте их, а также рекомендации по пакетам и сервисам, которые можно использовать:

### Мультиплеер (сетевой код)

Flame не содержит встроенных сетевых функций, которые могут понадобиться для создания онлайн-игр с мультиплеером.

Если вы разрабатываете многопользовательскую игру, вот некоторые рекомендуемые пакеты и сервисы:

- [Nakama](https://github.com/obrunsmann/flutter_nakama/): Открытый сервер, созданный для современных игр и приложений.
- [Firebase](https://firebase.google.com/): Предоставляет десятки сервисов, которые можно использовать для создания простого мультиплеера.
- [Supabase](https://supabase.com/): Более доступная альтернатива Firebase на основе Postgres.
