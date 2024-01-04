import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 1)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final DateTime dateTime;
  @HiveField(3)
  final bool isFavourite;

  NoteModel(
      {required this.title,
      required this.description,
      required this.dateTime,
      this.isFavourite = false});
}
