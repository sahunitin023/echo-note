part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<NoteModel> notes;

  HomeSuccessState({required this.notes});
}

class HomeErrorState extends HomeState {}
