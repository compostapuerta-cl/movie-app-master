// IMPORTACIONES
import 'package:flutter/material.dart';
import 'package:peliculas/src/provider/peliculas_provider.dart';
// WIDGETS
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';
// DELEGATE
import 'package:peliculas/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  // Permite poner los widgets en zonas seguras
  // Evitando que choquen por ejm con el notch
  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
                //query: 'Hola'
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [_swiperTarjetas(), _footer(context)],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          return Container(
              height: 400, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(left: 25),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subtitle1)),
          SizedBox(height: 5),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                    movies: snapshot.data,
                    nextPage: peliculasProvider.getPopulares);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }
}
