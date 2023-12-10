import 'package:flutter/material.dart';
// Providers
import 'package:peliculas/src/provider/peliculas_provider.dart';
// Models
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(slivers: [
        _crearAppBar(movie),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(height: 10),
          _posterTitulo(context, movie),
          _descripcion(movie),
          _crearCasting(movie)
        ]))
      ]),
    );
  }

  Widget _crearCasting(Pelicula movie) {
    final movieProvider = new PeliculasProvider();

    return FutureBuilder(
        future: movieProvider.getCast(movie.id.toString()),
        builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
          if (snapshot.hasData) {
            return _crearActoresPageView(snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearActoresPageView(List<Actor> actors) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
          pageSnapping: false,
          controller: PageController(initialPage: 1, viewportFraction: 0.3),
          itemCount: actors.length,
          itemBuilder: (context, index) {
            return _tarjetaActor(actors[index]);
          }),
    );
  }

  Widget _tarjetaActor(Actor actor) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(actor.getPhotoImg()),
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }

  Widget _crearAppBar(Pelicula movie) {
    return SliverAppBar(
      elevation: 2,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 230,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(movie.title,
            style: TextStyle(color: Colors.white, fontSize: 16)),
        background: FadeInImage(
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/img/loading.gif'),
          image: NetworkImage(movie.getBackgroundImg()),
          fadeInDuration: Duration(milliseconds: 150),
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150,
              ),
            ),
          ),
          SizedBox(width: 20),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                movie.originalTitle,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Icon(Icons.star_border),
                  Text(movie.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Text(movie.overview),
    );
  }
}
