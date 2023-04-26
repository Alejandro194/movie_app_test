import 'package:movie_app_test/models/Production_coutry.dart';
import 'package:movie_app_test/models/genre.dart';
import 'package:movie_app_test/models/production_company.dart';

class Movie {
  int id;
  String backdropPath;
  String posterPath;
  String title;
  String overview;
  String language;
  List<String> genres;
  List<String> productionCountries;
  List<ProductionCompany> productionCompanies;
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
    required this.productionCompanies,
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
      posterPath: json['poster_path'] ?? "",
      title: json['title'] ?? "",
      overview: json['overview'] ?? "",
      language: json['original_language'] ?? "",
      genres: [],
      productionCountries: [],
      productionCompanies: [],
      belongsTocollection: false,
      releaseDate: parseReleaseDate(json['release_date'] ?? ""),
      budget: -1,
      revenue: -1,
      runtime: -1,
      status: "",
      tagline: "",
      voteAverage: parseVoteAverage(json['vote_average'] ?? ""),
      voteCount: json['vote_count'] ?? "",
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      backdropPath: json['backdrop_path'] ?? "",
      posterPath: json['poster_path'] ?? "",
      title: json['title'] ?? "",
      overview: json['overview'] ?? "",
      language: json['original_language'] ?? "",
      genres: parseGenreList(json['genres'] ?? []),
      productionCountries:
          parseProductionCountries(json['production_countries'] ?? []),
      productionCompanies:
          parseProductionCompanies(json['production_companies'] ?? []),
      belongsTocollection: false,
      releaseDate: parseReleaseDate(json['release_date'] ?? ""),
      budget: json["budget"] ?? "",
      revenue: json['revenue'] ?? -1,
      runtime: json["runtime"] ?? -1,
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

  static List<String> parseGenreList(List<dynamic> jsonGenre) {
    final genreList = jsonGenre
        .map((e) => Genre.fromJson(e))
        .map((genre) => genre.name)
        .toList();
    return genreList;
  }

  static List<String> parseProductionCountries(List<dynamic> jsonCountries) {
    final countryList = jsonCountries
        .map((country) => ProductionCountries.fromJson(country))
        .map((e) => e.code)
        .toList();
    return countryList;
  }

  static List<ProductionCompany> parseProductionCompanies(
      List<dynamic> jsonCompanies) {
    final productionCompanies = jsonCompanies
        .map((company) => ProductionCompany.fromJson(company))
        .toList();
    return productionCompanies;
  }

  static Movie emptyMovie() {
    return Movie(
        id: -1,
        backdropPath: "",
        posterPath: "",
        title: "",
        overview: "",
        language: "",
        genres: [],
        productionCountries: [],
        productionCompanies: [],
        belongsTocollection: false,
        releaseDate: DateTime(0),
        budget: -1,
        revenue: -1,
        runtime: -1,
        status: "",
        tagline: "",
        voteAverage: -1,
        voteCount: -1);
  }
}
