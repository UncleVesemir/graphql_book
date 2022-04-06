part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class CreateNoteEvent extends NotesEvent {}

class UpdateNoteEvent extends NotesEvent {}

class DeleteNoteEvent extends NotesEvent {}
