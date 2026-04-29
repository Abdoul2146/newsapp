import 'package:flutter/material.dart';

class RelatedSaveItem extends StatelessWidget {
  final String title;

  const RelatedSaveItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(width: 50, color: Colors.grey[300]),
        title: Text(title),
        trailing: const Icon(Icons.bookmark_border),
      ),
    );
  }
}
