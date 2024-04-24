import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../db/movies_databases.dart';
import '../model/movie.dart';
import '../widget/movie_form_widget.dart';
// import '../widget/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Movie? note;

  const AddEditNotePage({
    super.key,
    this.note,
  });

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String imageURL;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    imageURL = widget.note?.imageURL ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: NoteFormWidget(
        title: title,
        description: description,
        imageURL: imageURL,
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
        onChangedImageURL: (imageURL) => setState(()=>this.imageURL = imageURL),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: const Text('Save', style: TextStyle(color: Colors.black),),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;
      print(isUpdating);

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      title: title,
      description: description,
      imageURL: imageURL,
    );

    if (kDebugMode) {
      print(note.title);
      print(note.description);
      print(note.imageURL);
    }

    var res = await MoviesDatabase.instance.update(note);
    print("final update: $res");
  }

  Future addNote() async {
    final note = Movie(
      title: title,
      description: description,
      createdTime: DateTime.now(),
      imageURL: imageURL,
    );

    if (kDebugMode) {
      print(note);
      print(description);
      print(imageURL);
    }

    await MoviesDatabase.instance.create(note);
  }
}