part of 'notes_bloc_bloc.dart';

enum NotesStatus { initial, loading, loadingError, deleting, error, success }

extension NotesStatusX on NotesStatus {
  bool get isInitial => this == NotesStatus.initial;
  bool get isLoading => this == NotesStatus.loading;
  bool get isloadingError => this == NotesStatus.loadingError;
  bool get isError => this == NotesStatus.error;
  bool get isSuccess => this == NotesStatus.success;
  bool get isDeleting => this == NotesStatus.deleting;
}

class NotesState {
  const NotesState(
      {this.status = NotesStatus.initial, List<Note>? notes, this.customError})
      : notes = notes ?? const [];
  final List<Note> notes;
  final NotesStatus status;
  final CustomError? customError;

  NotesState copyWith(
          {NotesStatus? status, List<Note>? notes, CustomError? customError}) =>
      NotesState(
          status: status ?? this.status,
          notes: notes ?? this.notes,
          customError: customError);
}
