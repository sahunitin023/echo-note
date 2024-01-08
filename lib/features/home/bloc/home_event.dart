part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeNoteFavouritedEvent extends HomeEvent {
  final NoteModel note;

  HomeNoteFavouritedEvent({required this.note});
}

class HomeSearchEvent extends HomeEvent {
  final String title;

  HomeSearchEvent({required this.title});
}

class HomeAddNoteSavedEvent extends HomeEvent {
  final NoteModel note;

  HomeAddNoteSavedEvent({required this.note});
}

class HomeNoteDeleteEvent extends HomeEvent {
  final NoteModel note;

  HomeNoteDeleteEvent({required this.note});
}

class HomeNoteUpdateEvent extends HomeEvent {
  final NoteModel oldNote;
  final NoteModel newNote;

  HomeNoteUpdateEvent({required this.oldNote, required this.newNote});
}
