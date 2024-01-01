class NoteModel {
  final String title;
  final String description;
  final DateTime dateTime;
  final bool isFavourite;

  NoteModel(
      {required this.title,
      required this.description,
      required this.dateTime,
      this.isFavourite = false});
}
