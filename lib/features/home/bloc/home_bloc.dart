import 'package:bloc/bloc.dart';
import 'package:echo_note/models/note_model.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    var box = Hive.box<List<NoteModel>>('notesBox');
    on<HomeInitialEvent>((event, emit) {
      emit(HomeLoadingState());
      try {
        List<NoteModel> notes = box.get('notes', defaultValue: []) ?? [];
        emit(HomeSuccessState(notes: notes));
      } catch (e) {
        emit(HomeErrorState());
      }
    });
  }
}
