import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:midterm/db/movies_databases.dart';
import 'package:midterm/model/movie.dart';

import '../widget/movie_card.dart';
import 'detail_movie.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late List<Movie> movies;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMovies();
  }

  @override
  void dispose() {
    MoviesDatabase.instance.close();
    super.dispose();
  }

  Future refreshMovies() async {
    // setState(() => isLoading = truinstancee);

    // if (kDebugMode) {
    //   print(await MoviesDatabase.instance.readAllMovies());
    // }

    // movies = await MoviesDatabase.instance.readAllMovies();

    // if (kDebugMode) {
    //   print(movies);
    // }

    movies = [
      Movie(
          id: 1,
          title: "title 1",
          imageURL:
          "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//catalog-image/102/MTA-134790635/no-brand_no-brand_full01.jpg",
          description: "its a description",
          createdTime: DateTime.now()),
      Movie(
          id: 2,
          title: "title 2",
          imageURL:
          "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//catalog-image/102/MTA-134790635/no-brand_no-brand_full01.jpg",
          description: "its a description",
          createdTime: DateTime.now()),
    ];

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Movies',
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : movies.isEmpty
                  ? const Text(
                      'No Notes',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
          onPressed: () async {
            // await Navigator.of(context).push(
            // MaterialPageRoute(builder: (context) => const AddEditNotePage()),
            // );

            refreshMovies();
          },
        ),
      );

  Widget buildNotes() => StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
        movies.length,
        (index) {
          final movie = movies[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailMoviePage(movie: movie!),
                ));

                refreshMovies();
              },
              child: NoteCardWidget(note: movie, index: index),
            ),
          );
        },
      ));
}
