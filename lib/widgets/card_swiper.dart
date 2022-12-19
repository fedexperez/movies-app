import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:movies/models/models.dart';

class CardSwipper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwipper({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.45,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final movie = movies[index];

          movie.heroId = 'swiper-${movie.id}';

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'details', arguments: movie);
            },
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage(
                  placeholder:
                      const AssetImage('assets/images/circle-loader.gif'),
                  image: NetworkImage(movie.fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
