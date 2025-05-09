import 'package:flutter/material.dart';
import '../ui/Card.dart' as custom;

class FormationList extends StatelessWidget {
  final List<String> formations;

  const FormationList({Key? key, required this.formations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: formations.length,
      itemBuilder: (context, index) {
        return custom.Card(
          child: ListTile(
            title: Text(formations[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                IconButton(icon: Icon(Icons.delete), onPressed: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}
