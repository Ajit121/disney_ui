import 'dart:ui';

import 'package:disney_ui/animations.dart';
import 'package:disney_ui/app_bar_widget.dart';
import 'package:disney_ui/character_menu.dart';
import 'package:disney_ui/characters_view_page.dart';
import 'package:disney_ui/entity/character.dart';
import 'package:disney_ui/entity/example_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CharacterDetailsPage extends StatelessWidget {
  final Character character;

  const CharacterDetailsPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBarWidget(),
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: _CharacterDetailsPageBody(
          character: character,
        ),
      ),
    );
  }
}

final ValueNotifier<bool> notifierBackButtonClicked = ValueNotifier(false);

class _CharacterDetailsPageBody extends StatefulWidget {
  final Character character;

  _CharacterDetailsPageBody({super.key, required this.character});

  @override
  State<_CharacterDetailsPageBody> createState() =>
      _CharacterDetailsPageBodyState();
}

class _CharacterDetailsPageBodyState extends State<_CharacterDetailsPageBody> {
  final radius = 100.0;

  final names = exampleCharacters.expand((e) => e.map((e) => e.name)).toList();

  final double backgroundPosition = 200;

  final double closeButtonPosition = 200 - 40;
  AnimationController? _logoController;
  AnimationController? _closeButtonController;
  AnimationController? _descriptionController;
  AnimationController? _clipController;

  final backgroundTopPadding = .2;
  final imageRightPosition = .58;
  final imageLeftPosition = .06;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ValueListenableBuilder(
        valueListenable: notifierBackButtonClicked,
        child: Stack(
          children: [
            Positioned(
                left: 0,
                bottom: 0,
                top: constraints.maxHeight * backgroundTopPadding,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: CharacterMenu(
                    categories: names,
                    selectedCategory: names.firstWhere(
                        (element) => element == widget.character.name,
                        orElse: () => names.first),
                  ),
                )),
            Positioned(
              top: constraints.maxHeight * backgroundTopPadding,
              left: constraints.maxWidth * .08,
              right: -100,
              bottom: -100,
              child: Hero(
                tag: "${widget.character.name}_bg",
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(widget.character.color),
                      Color(widget.character.color).withOpacity(.5),
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                    borderRadius: BorderRadius.all(Radius.circular(radius)),
                  ),
                ),
              ),
            ),
            Positioned(
              left: constraints.maxWidth * .4,
              right: 0,
              top: constraints.maxHeight * backgroundTopPadding,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Hero(
                                tag: "${widget.character.name}_character",
                                child: Text(
                                  widget.character.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withOpacity(.6),
                                      ),
                                ),
                              ),
                              Hero(
                                tag: "${widget.character.name}_movie",
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Movie ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white
                                                  .withOpacity(.8),
                                            ),
                                      ),
                                      TextSpan(
                                          text: widget.character.movieName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                color: Colors.white
                                                    .withOpacity(.8),
                                              ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Animate(
                                onComplete: (controller) =>
                                    _descriptionController = controller,
                                effects: const [
                                  FadeEffect(
                                      duration: navDuration,
                                      curve: Curves.linear,
                                      begin: 0,
                                      end: 1)
                                ],
                                child: Text(
                                  widget.character.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white.withOpacity(.8),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Animate(
                          onComplete: (controller) =>
                              _logoController = controller,
                          effects: [
                            ScaleEffect(
                              delay: navDuration,
                              duration: 400.ms,
                              curve: Curves.fastLinearToSlowEaseIn,
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 32),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: Image.asset(
                                widget.character.logo,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Animate(
                      onComplete: (controller) => _clipController = controller,
                      effects: const [
                        FadeEffect(
                            duration: navDuration,
                            curve: Curves.linear,
                            begin: 0,
                            end: 1)
                      ],
                      child: Text(
                        'Clips',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          color: Colors.white.withOpacity(.8),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 180,
                      child: ClipThumbnails(
                        clips: widget.character.clips,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: constraints.maxWidth * imageLeftPosition,
              top: 0,
              right: constraints.maxWidth * imageRightPosition,
              bottom: constraints.maxHeight * .2,
              child: Hero(
                tag: "${widget.character.name}_img",
                child: Image.asset(
                  widget.character.image,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Positioned(
              top: constraints.maxHeight * backgroundTopPadding - 40,
              right: 20,
              child: Animate(
                onComplete: (controller) => _closeButtonController = controller,
                effects: characterDetailsWidgetLoadEffects,
                delay: navDuration,
                child: TextButton.icon(
                  onPressed: () {
                    notifierBackButtonClicked.value = true;
                    Future.delayed(navDuration, () {
                      Navigator.of(context).pop();
                    });
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Close',style: TextStyle(color: Colors.black),),
                ),
              ),
            ),
          ],
        ),
        builder: (context, value, child) {
          if (value) {
            _logoController?.reverse();
            _closeButtonController?.reverse();
            _descriptionController?.reverse();
            _clipController?.reverse();
          }
          return child!;
        },
      ),
    );
  }

  @override
  void dispose() {
    notifierBackButtonClicked.value = false;

    notifierBackButtonClicked.removeListener(() {});
    super.dispose();
  }
}

class ClipThumbnails extends StatelessWidget {
  ClipThumbnails({
    super.key,
    required this.clips,
  });

  final List<AnimationController> _clipWidgetController =
      <AnimationController>[];
  final List<String> clips;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifierBackButtonClicked,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: AnimateList(
          delay: 600.ms,
          onComplete: (value) => _clipWidgetController.add(value),
          children: clips
              .map(
                (e) => Container(
                  margin: const EdgeInsets.only(right: 16),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.asset(
                      e,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
              .toList(),
          interval: animationInterval.ms,
          effects: characterDetailsWidgetLoadEffects,
        ),
      ),
      builder: (context, value, child) {
        if (value) {
          _startBack();
        }
        return child!;
      },
    );
  }

  void _startBack() async {
    var c = _clipWidgetController.reversed;
    try {
      for (var a in c) {
        await Future.delayed(100.ms);
        a.reverse();
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
