import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midterm/model/movie.dart';

import '../db/movies_databases.dart';
import 'editadd_movie.dart';

class DetailMoviePage extends StatefulWidget {
  final Movie movie;

  const DetailMoviePage({
    super.key,
    required this.movie,
  });

  @override
  State<DetailMoviePage> createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  late Movie note;
  bool isLoading = false;
  String imageURL = '';
  String title = '';
  DateTime createdTime = DateTime.now();
  String description = '';

  @override
  void initState() {
    super.initState();

    refreshNote();
  }


  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await MoviesDatabase.instance.readMovie(widget.movie.id as int);
    setState(() {
      imageURL = note.imageURL;
      title = note.title;
      createdTime = note.createdTime;
      description = note.description;
    });

    if (kDebugMode) {
      print("refresh note called");
      print(note.toJson());
    }
    setState(() => isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
    ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image(
                  image: NetworkImage(
                      widget.movie.imageURL),
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.movie.title,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                    DateFormat.yMMMd().format(widget.movie.createdTime),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.movie.description,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined, color: Colors.white,),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete, color: Colors.white,),
    onPressed: () async {
      await MoviesDatabase.instance.delete(widget.movie.id!);
      Navigator.of(context).pop();
    },
  );
}
