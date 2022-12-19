import 'package:flutter/material.dart';
import 'package:movies/models/models.dart';

class MovieSliderScreen extends StatefulWidget {
  const MovieSliderScreen(
      {Key? key,
      required this.movies,
      required this.title,
      required this.onNextPage})
      : super(key: key);

  final List<Movie> movies;
  final String title;
  final Function onNextPage;

  @override
  State<MovieSliderScreen> createState() => _MovieSliderScreenState();
}

class _MovieSliderScreenState extends State<MovieSliderScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels <=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) {
                return _MoviePoster(
                  movie: widget.movies[index],
                  heroId: '${widget.title}-$index-${widget.movies[index].id}',
                );
              },
              itemCount: widget.movies.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster({required this.movie, required this.heroId});

  final Movie movie;
  final String heroId;

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          GestureDetector(
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
                  image: NetworkImage(
                    movie.fullPosterImg,
                  ),
                  fit: BoxFit.cover,
                  width: 130,
                  height: 190,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
