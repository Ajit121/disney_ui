
import 'package:disney_ui/app_bar_widget.dart';
import 'package:disney_ui/characters_view_page.dart';
import 'package:flutter/material.dart';

enum PageMove { next, prev }

final ValueNotifier<PageMove?> notifyPageNav = ValueNotifier(null);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBarWidget(),
      ),
      body: Column(
        children: [
          Expanded(
            child: CharactersViewPage(),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              children: [
                Text(
                  'Facebook',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.black38),
                ),
                const SizedBox(
                  width: 32,
                ),
                Text('Twitter',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.black38)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    notifyPageNav.value = PageMove.prev;
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  label: const Text('Prev',
                    style: TextStyle(color: Colors.black),),
                  style: Theme.of(context).textButtonTheme.style,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    notifyPageNav.value = PageMove.next;
                  },
                  label: const Icon(Icons.arrow_forward_ios),
                  icon: const Text('Next',
                    style: TextStyle(color: Colors.black),),
                  style: Theme.of(context).textButtonTheme.style,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
