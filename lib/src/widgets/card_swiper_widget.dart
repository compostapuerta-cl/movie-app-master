// IMPORTS
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
// MODELS
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> movies;

  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    // Hacerlo adaptable al dispositivo
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Swiper(
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.6,
        layout: SwiperLayout.STACK,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          movies[index].uniqueId = '${movies[index].id}-tarjeta';

          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GestureDetector(
                  onTap: () {
                    print('Hiciste click');
                    Navigator.pushNamed(context, 'detalle',
                        arguments: movies[index]);
                  },
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(movies[index].getPosterImg()),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
