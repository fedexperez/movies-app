import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies/providers/movies_provider.dart';
import 'package:movies/models/models.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return FutureBuilder(
        future: moviesProvider.getCreditsResponse(movieId),
        builder: ((_, AsyncSnapshot<List<Cast>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.white,
              height: 180,
              child: Image.asset('assets/images/circle-loader.gif'),
            );
          }

          final cast = snapshot.data;

          return Container(
            margin: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: 190,
            child: ListView.builder(
              itemCount: cast?.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return _CastCard(
                  actor: cast![index],
                );
              },
            ),
          );
        }));
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.actor});

  final Cast actor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/circle-loader.gif'),
              image: NetworkImage(actor.fullProfilePath),
              height: 150,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
