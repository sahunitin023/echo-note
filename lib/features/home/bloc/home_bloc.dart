import 'package:bloc/bloc.dart';
import 'package:echo_note/models/note_model.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    //Opens the Hive Box
    var box = Hive.box('notesBox');
    //Returns All notes
    on<HomeInitialEvent>((event, emit) {
      try {
        var notes = box.get('notes', defaultValue: []);
        emit(HomeSuccessState(notes: notes.cast<NoteModel>()));
      } catch (e) {
        emit(HomeErrorState());
      }
      // box.close();
    });

    //Returns only the notes queried by the User
    on<HomeSearchEvent>((event, emit) {
      try {
        var notes = box.get('notes', defaultValue: []);
        var loadedNotes = notes
            .where((note) => note.title.toString().toLowerCase().contains(
                  event.title.toLowerCase(),
                ))
            .toList();
        emit(HomeSuccessState(notes: loadedNotes.cast<NoteModel>()));
      } catch (e) {
        print(e);
        emit(HomeErrorState());
      }
      // box.close();
    });

    //Added or removed as Favourite Note
    on<HomeNoteFavouritedEvent>((event, emit) {
      try {
        var notes = box.get('notes', defaultValue: []);
        for (NoteModel note in notes) {
          if (note == event.note) {
            event.note.isFavourite = !event.note.isFavourite;
          }
        }
        box.put('notes', notes);
        emit(HomeSuccessState(notes: notes.cast<NoteModel>()));
      } catch (e) {
        emit(HomeErrorState());
      }
      // box.close();
    });

    on<HomeAddNoteSavedEvent>((event, emit) {
      try {
        var notes = box.get('notes', defaultValue: []);
        // notes.cast<NoteModel>();
        notes.add(event.note);
        box.put('notes', notes);
        emit(HomeSuccessState(notes: notes.cast<NoteModel>()));
      } catch (e) {
        emit(HomeErrorState());
      }
      // box.close();
    });
  }
}
