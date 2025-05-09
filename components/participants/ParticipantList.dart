import 'package:flutter/material.dart';
import '../ui/Card.dart' as custom;

class ParticipantList extends StatelessWidget {
  final List<String> participants;

  const ParticipantList({Key? key, required this.participants})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return custom.Card(
          child: ListTile(
            title: Text(participants[index]),
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
