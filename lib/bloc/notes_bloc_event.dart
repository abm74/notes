part of 'notes_bloc_bloc.dart';

@immutable
sealed class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AddNote extends NotesEvent {
  AddNote(this.note);
  final Note note;
  @override
  List<Object?> get props => [note];
}

final class DeleteNote extends NotesEvent {
  DeleteNote(this.note, {this.inMass = false});
  final Note note;
  final bool inMass;
  @override
  List<Object?> get props => [note];
}

final class UpdateNote extends NotesEvent {
  UpdateNote(this.note);
  final Note note;
  @override
  List<Object?> get props => [note];
}

final class LoadNotes extends NotesEvent {}

final class UndoDelete extends NotesEvent {}
