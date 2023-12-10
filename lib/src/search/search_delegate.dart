import 'package:flutter/material.dart';
// Model
import 'package:peliculas/src/models/pelicula_model.dart';
//Providers
import 'package:peliculas/src/provider/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String movieSelected = '';
  final peliculasProvider = new PeliculasProvider();
  final movies = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitan America'
  ];
  final recentMovies = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar (limpiar/cancelar)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {},
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          query = '';
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultadosque vamos a mostrar
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.blueAccent,
        child: Text(movieSelected),
      ),
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aparecen cuando la persona escribe

  //   final suggestedList = (query.isEmpty)
  //       ? recentMovies
  //       : movies
  //           .where(
  //               (movie) => movie.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //       itemCount: suggestedList.length,
  //       itemBuilder: (BuildContext context, int i) {
  //         return ListTile(
  //           leading: Icon(Icons.movie),
  //           title: Text(suggestedList[i]),
  //           onTap: () {
  //             movieSelected = suggestedList[i];
  //             showResults(context);
  //           },
  //         );
  //       });
  // }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          final movies = snapshot.data;
          if (snapshot.hasData) {
            return ListView(
              children: movies.map((movie) {
                return ListTile(
                  leading: FadeInImage(
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      image: NetworkImage(movie.getPosterImg()),
                      width: 50,
                      fit: BoxFit.contain),
                  title: Text(movie.title),
                  subtitle: Text(movie.originalTitle),
                  onTap: () {
                    close(context, null);
                    movie.uniqueId = '';
                    Navigator.pushNamed(context, 'detalle', arguments: movie);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
