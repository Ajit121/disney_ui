import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png'),
          const SizedBox(
            width: 16,
          ),
          Text(
            'Characters',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Search characters',
                  fillColor: Color(0xFFf5f5f6),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Color(0xFFf5f5f6))),
                  enabled: false,
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Color(0xFFf5f5f6))),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Color(0xFFf5f5f6))),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.black26,
                  hintStyle: TextStyle(color: Colors.black26)),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            label: const Icon(Icons.dashboard),
            icon: const Text(
              'Menu',
              style: TextStyle(color: Colors.black),
            ),
            style: Theme.of(context).textButtonTheme.style,
          )
        ],
      ),
    );
  }
}
