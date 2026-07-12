import 'package:flutter/material.dart';

class FocusStreakCard extends StatelessWidget {
  const FocusStreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.local_fire_department_outlined),
          title: Text('Racha actual'),
          subtitle: Text('0 días'),
        ),
      ),
    );
  }
}
