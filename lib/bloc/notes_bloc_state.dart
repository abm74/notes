part of 'notes_bloc_bloc.dart';

enum NotesStatus { initial, loading,loadingError, error, success }

extension NotesStatusX on NotesStatus {
  bool get isInitial => this == NotesStatus.initial;
  bool get isloading => this == NotesStatus.loading;
  bool get isloadingError => this == NotesStatus.loadingError;
  bool get isError => this == NotesStatus.error;
  bool get isSuccess => this == NotesStatus.success;
}

// @immutable
// sealed
class NotesState {
  const NotesState({this.status = NotesStatus.initial, List<Note>? notes})
      : notes = notes ?? const [];
  final List<Note> notes;
  final NotesStatus status;

  NotesState copyWith({NotesStatus? status, List<Note>? notes}) =>
      NotesState(status: status ?? this.status, notes: notes ?? this.notes);
}

// final class NotesBlocInitial extends NotesBlocState {}
