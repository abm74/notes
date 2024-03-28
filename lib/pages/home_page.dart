import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/notes_bloc_bloc.dart';
import 'package:notes/models/note.dart';
import 'package:notes/pages/note_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? body;
  final List<Note> _selectedNotes = [];
  bool _isSelecting = false;
  int _numMassDeleted = 0;

  void _addNote(NotesBloc bloc, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bloc.add(AddNote(
          Note(title: title!, body: body!, timestamp: Timestamp.now())));
      Navigator.of(context).pop();
    }
  }

  void _updateNote(NotesBloc bloc, BuildContext context, Note note) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bloc.add(UpdateNote(Note(
          title: title!, body: body!, timestamp: note.timestamp, id: note.id)));
      Navigator.of(context).pop();
    }
  }

  void _showNoteEditorDialog(BuildContext context, {Note? existingNote}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => AlertDialog(
              content: Form(
                key: _formKey,
                child: Wrap(
                  runSpacing: 10,
                  children: [
                    TextFormField(
                      initialValue: existingNote?.title,
                      decoration: const InputDecoration(hintText: 'Title'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter title';
                        }
                        return null;
                      },
                      onSaved: (newValue) => title = newValue,
                    ),
                    TextFormField(
                      initialValue: existingNote?.body,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Note...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(162, 155, 39, 176),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter note';
                        }
                        return null;
                      },
                      onSaved: (newValue) => body = newValue,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            existingNote == null
                                ? _addNote(context.read<NotesBloc>(), context)
                                : _updateNote(context.read<NotesBloc>(),
                                    context, existingNote);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white),
                          child: existingNote == null
                              ? const Text('Save')
                              : const Text('Update'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesBloc, NotesState>(
      listenWhen: (previous, current) =>
          current.status.isError ||
          (previous.status.isDeleting && current.status.isSuccess),
      listener: (context, state) {
        if (state.status.isError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(
              content: Text(
                state.customError?.message ?? 'Some thing went wrong',
              ),
              action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                  }),
            ));
        } else {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(
              content: _numMassDeleted > 0
                  ? Text('$_numMassDeleted notes deleted')
                  : const Text('Note deleted'),
              action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    context.read<NotesBloc>().add(UndoDelete());
                    ScaffoldMessenger.of(context).clearSnackBars();
                    _numMassDeleted = 0;
                  }),
            ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: const Center(
            child: Text(
              'Notes',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24),
            ),
          ),
          actions: !_isSelecting
              ? []
              : [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedNotes.clear();
                          _isSelecting = false;
                        });
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text(
                                  'Warning',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                    'Delete ${_selectedNotes.length} items?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedNotes.clear();
                                          _isSelecting = false;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No')),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        for (final note in _selectedNotes) {
                                          context.read<NotesBloc>().add(
                                              DeleteNote(note, inMass: true));
                                        }
                                        setState(() {
                                          _numMassDeleted =
                                              _selectedNotes.length;
                                          _selectedNotes.clear();
                                          _isSelecting = false;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes'))
                                ],
                              ));
                    },
                  )
                ],
        ),
        body: BlocBuilder<NotesBloc, NotesState>(
          buildWhen: (previous, current) {
            return !current.status.isError && !current.status.isDeleting;
          },
          builder: (context, state) {
            if (state.status.isSuccess) {
              if (state.notes.isEmpty) {
                return const Center(
                  child: Text(
                    'No added notes.',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: state.notes.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Color.fromARGB(197, 237, 196, 252),
                        leading: const Icon(
                          Icons.note_alt,
                        ),
                        title: Text(
                          state.notes[index].title,
                          style: const TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          if (_isSelecting) {
                            setState(() {
                              if (_selectedNotes.contains(state.notes[index])) {
                                _selectedNotes.remove(state.notes[index]);
                                if (_selectedNotes.isEmpty) {
                                  _isSelecting = false;
                                }
                              } else {
                                if (!_isSelecting) {
                                  _isSelecting = true;
                                }
                                _selectedNotes.add(state.notes[index]);
                              }
                            });
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) =>
                                    NoteDetails(note: state.notes[index]))));
                          }
                        },
                        onLongPress: () {
                          setState(() {
                            if (_selectedNotes.contains(state.notes[index])) {
                              _selectedNotes.remove(state.notes[index]);
                              if (_selectedNotes.isEmpty) {
                                _isSelecting = false;
                              }
                            } else {
                              if (!_isSelecting) {
                                _isSelecting = true;
                              }
                              _selectedNotes.add(state.notes[index]);
                            }
                          });
                        },
                        selected: _selectedNotes.contains(state.notes[index]),
                        selectedTileColor: Color.fromARGB(255, 100, 255, 43),
                        trailing: MenuAnchor(
                          alignmentOffset: const Offset(-90, 10),
                          style: const MenuStyle(alignment: Alignment.topLeft),
                          menuChildren: [
                            MenuItemButton(
                              child: const SizedBox(
                                  width: 100, child: Text('Open')),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => NoteDetails(
                                        note: state.notes[index]))));
                              },
                            ),
                            MenuItemButton(
                              child: const SizedBox(
                                  width: 70, child: Text('Edit')),
                              onPressed: () {
                                _showNoteEditorDialog(context,
                                    existingNote: state.notes[index]);
                              },
                            ),
                            MenuItemButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                context
                                    .read<NotesBloc>()
                                    .add(DeleteNote(state.notes[index]));
                              },
                            ),
                          ],
                          builder: (context, controller, child) => IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              controller.isOpen
                                  ? controller.close()
                                  : controller.open();
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }
            } else if (state.status.isLoading || state.status.isDeleting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text('Something went wrong.Try again later.'),
              );
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: IconButton.filled(
            color: Colors.blue,
            onPressed: () {
              _showNoteEditorDialog(context);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            )),
      ),
    );
  }
}
