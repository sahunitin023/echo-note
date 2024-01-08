import 'package:echo_note/features/home/bloc/home_bloc.dart';
import 'package:echo_note/features/notes_info/screens/notes_info_screen.dart';
import 'package:echo_note/models/note_model.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.note.title,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
              // style: const TextStyle(
              //   color: Colors.black,
              //   fontWeight: FontWeight.w500,
              //   fontSize: 18,
              // ),
            ),
          ),
          subtitle: Text(
            DateFormat.MMMMd().format(widget.note.dateTime),
            style: Theme.of(context).textTheme.labelSmall,
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotesInfoScreen(
                  note: widget.note,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
