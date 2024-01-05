import 'package:bloc/bloc.dart';
import 'package:echo_note/data.dart';
import 'package:echo_note/models/note_model.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    //Opens the Hive Box
    var box = Hive.box<List<NoteModel>>('notesBox');

    //Returns All notes
    on<HomeInitialEvent>((event, emit) {
      try {
        List<NoteModel> notes = box.get('notes', defaultValue: []) ?? [];
        emit(HomeSuccessState(notes: notes));
      } catch (e) {
        emit(HomeErrorState());
      }
    });

    //Returns only the notes queried by the User
    on<HomeSearchEvent>((event, emit) {
      try {
        List<NoteModel> notes = box.get('notes', defaultValue: []) ?? [];
        List<NoteModel> loadedNotes = notes
            .where((note) => note.title.toLowerCase().contains(
                  event.title.toLowerCase(),
                ))
            .toList();
        emit(HomeSuccessState(notes: loadedNotes));
      } catch (e) {
        emit(HomeErrorState());
      }
    });

    //Added or removed as Favourite Note
    on<HomeNoteFavouritedEvent>((event, emit) {
      event.note.isFavourite = !event.note.isFavourite;
      //Save Method from HiveObject Class which is inherited/extended by NoteModel
      event.note.save();
      try {
        List<NoteModel> notes = box.get('notes', defaultValue: []) ?? [];
        emit(HomeSuccessState(notes: notes));
      } catch (e) {
        emit(HomeErrorState());
      }
    });
  }
}
