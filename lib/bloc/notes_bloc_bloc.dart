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
  // Note? lastDeleted;
  List<Note> lastDeleted = [];

  void _loadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.loading));

    await emit.forEach(
      notesRepository.loadNotes(),
      onData: (data) {
        return state.copyWith(status: NotesStatus.success, notes: data);
      },
      onError: (error, stackTrace) {
        return state.copyWith(status: NotesStatus.loadingError);
      },
    );
  }

  void _undoDelete(UndoDelete event, Emitter<NotesState> emit) {
    if (lastDeleted.isEmpty) {
      emit(state.copyWith(status: NotesStatus.error));
    } else {
      for (final note in lastDeleted) {
        add(AddNote(note));
      }
      lastDeleted.clear();
    }
  }

  void _addNote(AddNote event, Emitter<NotesState> emit) async {
    try {
      final newId = await notesRepository.addNote(event.note);
      if (newId == null) {
        emit(state.copyWith(status: NotesStatus.error));
        return;
      }
    } catch (e) {
      debugPrint('Error: $e');
      emit(state.copyWith(status: NotesStatus.error));
    }
  }

  void _deleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.deleting));
    try {
      final success = await notesRepository.deleteNote(event.note);
      if (success) {
        if (event.inMass) {
          lastDeleted.add(event.note);
        } else {
          lastDeleted
            ..clear()
            ..add(event.note);
        }
      } else {
        emit(state.copyWith(status: NotesStatus.error));
        return;
      }
    } catch (e) {
      debugPrint('Error: $e');
      emit(state.copyWith(status: NotesStatus.error));
    }
  }

  void _updateNote(UpdateNote event, Emitter<NotesState> emit) async {
    debugPrint('Update id: ${event.note.id}');
    try {
      final success = await notesRepository.updateNote(event.note);
      if (!success) {
        emit(state.copyWith(status: NotesStatus.error));
        return;
      }
    } catch (e) {
      debugPrint('Error: $e');
      emit(state.copyWith(status: NotesStatus.error));
    }
  }
}
