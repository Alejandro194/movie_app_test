class Movie {
  int id;
  String backdropPath;
  String posterPath;
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
    required this.posterPath,
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

  factory Movie.fromJsonPopularMovies(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      backdropPath: json['backdrop_path'] ?? "",
      posterPath: json['poster_path'] ?? "" ,
      title: json['title']  ?? "",
      overview: json['overview'] ?? "",
      language: json['original_language']?? "",
      genres: [],
      productionCountries: [],
      belongsTocollection: false,
      releaseDate: parseReleaseDate(json['release_date']?? ""),
      budget: -1,
      revenue: -1,
      runtime: -1,
      status: "",
      tagline: "",
      voteAverage: parseVoteAverage(json['vote_average'] ?? ""),
      voteCount: json['vote_count'] ?? "",
    );
  }

  static DateTime parseReleaseDate(String jsonDate) {
    final dateComponents = jsonDate.split('-');
    return DateTime(int.parse(dateComponents.first));
  }

  static double parseVoteAverage(dynamic voteAverageJson) {
    final numberString = voteAverageJson.toString();
    return double.parse(numberString);
  }
}
