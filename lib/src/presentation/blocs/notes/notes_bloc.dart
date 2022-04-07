import 'package:bloc/bloc.dart';
import 'package:graphql_book/src/presentation/screens/text_edit/model.dart';
import 'package:meta/meta.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitialState()) {
    on<CreateNoteEvent>((event, emit) {});
    on<UpdateNoteEvent>((event, emit) {});
    on<DeleteNoteEvent>((event, emit) {});
  }
}
