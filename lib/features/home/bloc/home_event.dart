part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeNoteFavouritedEvent extends HomeEvent {}

class HomeSearchEvent extends HomeEvent {}
