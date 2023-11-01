import 'dart:math';

import 'package:disney_ui/character_details_page.dart';
import 'package:disney_ui/entity/example_date.dart';
import 'package:disney_ui/home_page.dart';
import 'package:disney_ui/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'entity/character.dart';

const navDuration = Duration(milliseconds: 1000);

class CharactersViewPage extends StatefulWidget {
  const CharactersViewPage({super.key});

  @override
  State<CharactersViewPage> createState() => _CharactersViewPageState();
}

const _duration = Duration(milliseconds: 400);
final double _animationInterval = _duration.inMilliseconds / 2;
int itemInPage = 3;

class _CharactersViewPageState extends State<CharactersViewPage> {
  final _pageController = PageController(viewportFraction: .75, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: PageView.builder(
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, pageIndex) {
            return Row(
              children: [
                ...AnimateList(
                  delay: (_animationInterval * itemInPage * pageIndex +
                          _animationInterval)
                      .milliseconds,
                  interval: _animationInterval.ms,
                  effects: [
                    const SlideEffect(
                        duration: _duration,
                        curve: Curves.linear,
                        begin: Offset(.1, 0),
                        end: Offset.zero),
                    const FadeEffect(curve: Curves.linear),
                    const ScaleEffect(
                        duration: _duration,
                        alignment: Alignment.bottomRight,
                        begin: Offset(0.2, 0.2),
                        end: Offset(1, 1),
                        curve: Curves.fastLinearToSlowEaseIn)
                  ],
                  children: exampleCharacters[pageIndex]
                      .map(
                        (character) => CharacterWidget(
                          constraints: constraint,
                          character: character,
                          index: pageIndex +
                              exampleCharacters[pageIndex].indexOf(character),
                          pageController: _pageController,
                          currentPage: pageIndex,
                        ),
                      )
                      .toList(),
                ),
                ValueListenableBuilder(
                  valueListenable: notifyPageNav,
                  builder: (context, value, child) {
                    if (value != null) {
                      if (value == PageMove.next) {
                        _pageController.nextPage(
                            duration: 600.ms, curve: Curves.linear);
                      } else if (value == PageMove.prev) {
                        _pageController.previousPage(
                            duration: 600.ms, curve: Curves.linear);
                      }
                    }
                    return Container();
                  },
                ),
              ],
            );
          },
          itemCount: exampleCharacters.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class CharacterWidget extends StatefulWidget {
  final BoxConstraints constraints;
  final Character character;
  final int index;
  final double randomValue = 0.3 + (.5 - 0.3) * Random().nextDouble();
  final PageController pageController;
  final int currentPage;

  CharacterWidget({
    required this.constraints,
    required this.character,
    required this.index,
    required this.pageController,
    required this.currentPage,
    super.key,
  });

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget> {
  @override
  void initState() {
    super.initState();
  }

  bool _showMovieName = false;
  final backgroundHorizontalSpacing = .05;
  final backgroundVerticalSpacing = .08;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.constraints.maxWidth / 4,
      height: widget.constraints.maxHeight,
      child: InkWell(
        onTap: () {
          _showMovieDetails(widget.character);
        },
        hoverColor: Theme.of(context).canvasColor,
        splashColor: Theme.of(context).canvasColor,
        onHover: (bool) {
          setState(() {
            _showMovieName = bool;
          });
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: widget.constraints.maxHeight * widget.randomValue,
              left: widget.constraints.maxHeight * backgroundHorizontalSpacing,
              bottom: widget.constraints.maxHeight * backgroundVerticalSpacing,
              right: widget.constraints.maxHeight * backgroundHorizontalSpacing,
              child: Hero(
                tag: "${widget.character.name}_bg",
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(widget.character.color),
                      Color(widget.character.color).withOpacity(.5),
                    ], begin: Alignment.centerLeft, end: Alignment.topRight),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 24,
                        spreadRadius: 1,
                        offset: const Offset(0.0, 10.0),
                        color: Color(widget.character.color).withOpacity(.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: widget.constraints.maxHeight * .25,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: widget.pageController,
                builder: (context, child) {
                  double value = 1;
                  if (widget.pageController.position.haveDimensions) {
                    value = widget.pageController.page! - widget.currentPage;
                    value = (1 - (value.abs() * 0.6)).clamp(0.0, 1.0);
                    value = Curves.easeOut.transform(value);
                  } else if (widget.pageController.initialPage !=
                      widget.currentPage) {
                    value = 0.6;
                  }
                  return Hero(
                    tag: "${widget.character.name}_img",
                    child: Image.asset(
                      widget.character.image,
                      fit: BoxFit.scaleDown,
                      height: widget.constraints.maxHeight * .7 * value,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: widget.constraints.maxHeight * .15,
              left: widget.constraints.maxHeight * backgroundHorizontalSpacing +
                  40,
              right:
                  widget.constraints.maxHeight * backgroundHorizontalSpacing +
                      40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Hero(
                    tag: "${widget.character.name}_character",
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        widget.character.name,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(.6),
                                ),
                      ),
                    ),
                  ),
                  Hero(
                    tag: "${widget.character.name}_movie",
                    child: Material(
                      color: Colors.transparent,
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
                                    color: Colors.white.withOpacity(.8),
                                  ),
                            ),
                            TextSpan(
                                text: widget.character.movieName,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(.8),
                                    ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    duration: 1.seconds,
                    firstChild: Container(),
                    secondChild: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'READ MORE > ',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                      ),
                    ),
                    crossFadeState: _showMovieName
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    alignment: Alignment.bottomLeft,
                    sizeCurve: Curves.fastLinearToSlowEaseIn,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showMovieDetails(Character character) {
    Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => FadeTransition(
                opacity: animation1,
                child: CharacterDetailsPage(character: widget.character),
              ),
          transitionDuration: navDuration,
          reverseTransitionDuration: navDuration),
    );
  }
}
