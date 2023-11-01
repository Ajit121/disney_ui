import 'package:disney_ui/animations.dart';
import 'package:disney_ui/character_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CharacterMenu extends StatefulWidget {
  const CharacterMenu(
      {super.key, required this.categories, required this.selectedCategory});

  final String selectedCategory;
  final List<String> categories;

  @override
  State<CharacterMenu> createState() => _CharacterMenuState(
      categories: categories, selectedCategory: selectedCategory);
}

class _CharacterMenuState extends State<CharacterMenu> {
  final List<String> categories;
  String selectedCategory;
  late ScrollController controller;

  _CharacterMenuState(
      {required this.categories, required this.selectedCategory});

  String scrolledCategory = "";
  final _controllers = <AnimationController>[];
  final ValueNotifier<bool> notifyMoveIconVisibility = ValueNotifier(false);

  @override
  void initState() {
    scrolledCategory = selectedCategory;
    Future.delayed(200.ms, () {
      _scrollToCategory();
    });
    super.initState();
  }

  Widget nextMenuOption() {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: IconButton(
        onPressed: () {
          var index = categories.indexOf(scrolledCategory) - 1;
          if (index <= 0) {
            return;
          }
          scrolledCategory = categories.elementAt(index);
          _scrollToCategory();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifierBackButtonClicked,
      child: SizedBox(
        height: MediaQuery.of(context).size.width*.08,
        child: Stack(
          children: [
            ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: AnimateList(
                onComplete: (controller) {
                  notifyMoveIconVisibility.value = true;
                  _controllers.add(controller);
                },
                children: [
                  nextMenuOption(),
                  ...categories
                      .map(
                        (e) => InkWell(
                          key: GlobalObjectKey(e),
                          onTap: () => _selectCategory(e),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Align(
                              alignment: Alignment.center,
                              child: AnimatedDefaultTextStyle(
                                style: selectedCategory == e
                                    ? Theme.of(context).textTheme.titleLarge!
                                    : Theme.of(context).textTheme.titleMedium!,
                                duration: const Duration(milliseconds: 200),
                                child: Text(e),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()
                ],
                interval: animationInterval.ms,
                effects: characterDetailsWidgetLoadEffects,
              ),
            ),
            ValueListenableBuilder(
                valueListenable: notifyMoveIconVisibility,
                builder: (context, value, child) => value
                    ? Positioned(
                        bottom: 0,
                        top: 0,
                        child: Container(
                            alignment: Alignment.center,
                            color: Theme.of(context).canvasColor,
                            child: nextMenuOption()))
                    : const SizedBox(height: 0,width: 0,))
          ],
        ),
      ),
      builder: (context, value, child) {
        if (value) {
          notifyMoveIconVisibility.value = false;
          _startBack();
        }
        return child!;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      scrolledCategory = category;
    });
    _scrollToCategory();
  }

  void _scrollToCategory() {
    Scrollable.ensureVisible(GlobalObjectKey(scrolledCategory).currentContext!,
        duration: const Duration(seconds: 1), // duration for scrolling time
        alignment: .5, // 0 mean, scroll to the top, 0.5 mean, half
        curve: Curves.easeInOutCubic);
  }

  void _startBack() async {
    var c = _controllers.reversed;
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
