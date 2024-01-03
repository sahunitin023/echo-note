import 'package:echo_note/models/note_model.dart';
import 'package:echo_note/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesItemWidget extends StatelessWidget {
  final NoteModel note;
  const NotesItemWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: AppColors.secondary,
        title: Text(
          note.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          DateFormat.MMMMd().format(note.dateTime),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_border,
          ),
          color: Colors.redAccent,
        ),
        onTap: () {},
      ),
    );
  }
}
