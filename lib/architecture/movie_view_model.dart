import 'package:cinema_scope/architecture/search_view_model.dart';

import '../models/movie.dart';

class MovieViewModel extends ApiViewModel {

  Movie? movie;

  String get synopsis => movie?.overview ?? '';

  MovieViewModel() : super();

  getMovieWithDetail(int id) async {
    movie = await api.getMovieWithDetail(id);
    notifyListeners();
  }

  getMovie(int id) async {
    movie = await api.getMovie(id);
    notifyListeners();
  }

}
