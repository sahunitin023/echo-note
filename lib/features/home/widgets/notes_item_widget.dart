import 'package:echo_note/features/home/bloc/home_bloc.dart';
import 'package:echo_note/models/note_model.dart';
import 'package:echo_note/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesItemWidget extends StatefulWidget {
  final NoteModel note;
  final HomeBloc homeBloc;
  const NotesItemWidget(
      {super.key, required this.note, required this.homeBloc});

  @override
  State<NotesItemWidget> createState() => _NotesItemWidgetState();
}

class _NotesItemWidgetState extends State<NotesItemWidget> {
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
          widget.note.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          DateFormat.MMMMd().format(widget.note.dateTime),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: IconButton(
          onPressed: () {
            widget.homeBloc.add(HomeNoteFavouritedEvent(note: widget.note));
          },
          icon: Icon(
            widget.note.isFavourite ? Icons.favorite : Icons.favorite_border,
          ),
          color: Colors.redAccent,
        ),
        onTap: () {},
      ),
    );
  }
}
