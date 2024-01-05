import 'package:echo_note/models/note_model.dart';
import 'dart:math';

List<NoteModel> noteList = List.generate(
  10, // Change this value to the number of NoteModel objects you want
  (index) => NoteModel(
    title: 'Title ${index + 1}',
    description: 'Description ${index + 1}',
    dateTime: DateTime.now().add(Duration(days: index)),
    isFavourite: false,
  ),
);
