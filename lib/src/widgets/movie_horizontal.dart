// IMPORTACIONES
import 'package:flutter/material.dart';
// MODELOS
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> movies;
  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);
  final Function nextPage;

  MovieHorizontal({@required this.movies, @required this.nextPage});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return _tarjeta(context, movies[index]);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula movie) {
    movie.uniqueId = '${movie.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(movie.getPosterImg()),
                fit: BoxFit.cover,
                height: 160,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: movie);
      },
    );
  }

  // En caso fueran pocas tarjetas
  List<Widget> _tarjetas(BuildContext context) {
    return movies.map((movie) {
      return Container(
        margin: EdgeInsets.only(right: 15),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(movie.getPosterImg()),
                fit: BoxFit.cover,
                height: 160,
              ),
            ),
            SizedBox(height: 5),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
