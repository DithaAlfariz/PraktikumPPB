import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Makanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cookie),
          label: 'Cemilan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_drink),
          label: 'Minuman',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cake),
          label: 'Kue',
        ),
      ],
    );
  }
}