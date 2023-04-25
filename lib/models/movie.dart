class Movie {
  int id;
  String backdropPath;
  String title;
  String overview;
  String language;
  List<String> genres;
  List<String> productionCountries;
  bool belongsTocollection;
  DateTime releaseDate;
  int budget;
  int revenue;
  int runtime;
  String status;
  String tagline;
  double voteAverage;
  int voteCount;

  Movie({
    required this.id,
    required this.backdropPath,
    required this.title,
    required this.overview,
    required this.language,
    required this.genres,
    required this.productionCountries,
    required this.belongsTocollection,
    required this.releaseDate,
    required this.budget,
    required this.revenue,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.voteAverage,
    required this.voteCount,
  });
}
