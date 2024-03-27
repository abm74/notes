import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repository/notes_repository.dart';

part 'notes_bloc_event.dart';
part 'notes_bloc_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({required this.notesRepository}) : super(const NotesState()) {
    on<LoadNotes>(_loadNotes);
    on<AddNote>(_addNote);
    on<UpdateNote>(_updateNote);
    on<DeleteNote>(_deleteNote);
    on<UndoDelete>(_undoDelete);
  }

  final NotesRepository notesRepository;
  Note? lastDeleted;

  void _loadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.loading));
    // try {
    await emit.forEach(
      notesRepository.loadNotes(),
      onData: (data) {
        return state.copyWith(status: NotesStatus.success, notes: data);
      },
      onError: (error, stackTrace) {
        return state.copyWith(status: NotesStatus.loadingError);
      },
    );

    //   final notes = await notesRepository.loadNotes();
    //   emit(state.copyWith(status: NotesStatus.success, notes: notes));
    // } catch (e) {
    //   debugPrint('Error: $e');
    //   emit(state.copyWith(status: NotesStatus.loadingError));
    // }
    // emit.forEach(notesRepository.loadNotes(),
    //     onData: (notes) =>
    //         state.copyWith(status: NotesStatus.success, notes: notes));
  }

  void _undoDelete(UndoDelete event, Emitter<NotesState> emit) {
    if (lastDeleted == null) {
      emit(state.copyWith(status: NotesStatus.error));
    } else {
      add(AddNote(lastDeleted!));
    }
  }

  void _addNote(AddNote event, Emitter<NotesState> emit) async {
    // emit(state.copyWith(status: NotesStatus.loading));
    try {
      final newId = await notesRepository.addNote(event.note);
      // if (newId != null) {
      //   final newList = [...state.notes, event.note.copyWith(id: newId)];
      //   emit(state.copyWith(status: NotesStatus.success, notes: newList));
      // } else {
      //   emit(state.copyWith(status: NotesStatus.error));
      // }
    } catch (e) {
      debugPrint('Error: $e');
      emit(state.copyWith(status: NotesStatus.error));
    }
  }

  void _deleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.deleting));
    try {
      final success = await notesRepository.deleteNote(event.note);
      lastDeleted = event.note;

      // if (success) {
      //   final newList = [
      //     for (final note in state.notes)
      //       if (note != event.note) note
      //   ];
      //   emit(state.copyWith(status: NotesStatus.success, notes: newList));
      // } else {
      //   emit(state.copyWith(status: NotesStatus.error));
      // }
    } catch (e) {
      debugPrint('Error: $e');
      emit(state.copyWith(status: NotesStatus.error));
    }
  }

  void _updateNote(UpdateNote event, Emitter<NotesState> emit) async {
    // emit(state.copyWith(status: NotesStatus.loading));
    debugPrint('Update id: ${event.note.id}');
    try {
      final success = await notesRepository.updateNote(event.note);
      // if (success) {
      //   final List<Note> newList = List.from(state.notes);
      //   newList
      //     ..remove(event.note)
      //     ..add(event.note);
      //   emit(state.copyWith(status: NotesStatus.success, notes: newList));
      // } else {
      //   emit(state.copyWith(status: NotesStatus.error));
      // }
    } catch (e) {
      debugPrint('Error: $e');
      emit(state.copyWith(status: NotesStatus.error));
    }
  }
}
