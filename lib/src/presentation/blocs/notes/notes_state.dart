part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitialState extends NotesState {}

class NotesLoadingState extends NotesState {}

class NotesLoadedState extends NotesState {}

class NotesEditState extends NotesState {}
