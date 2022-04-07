part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitialState extends NotesState {}

class NotesLoadingState extends NotesState {}

class NotesLoadedState extends NotesState {
  final List<List<DraggableList>> data;
  NotesLoadedState({required this.data});
}

class NotesEditState extends NotesState {}
