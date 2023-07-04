import '../constants.dart';

class SimilarTitlesParams {
  final int mediaId;

  final MediaType mediaType;

  /// Unique pairs of genre ids separated by comma ','
  final Set<String> genrePairs;

  /// primary_release_date.gte
  final String dateGte;

  /// primary_release_date.lte
  final String dateLte;

  /// Keyword ids separated by pipe '|'
  final String keywordsString;

  SimilarTitlesParams({
    required this.mediaId,
    required this.mediaType,
    required this.genrePairs,
    required this.dateGte,
    required this.dateLte,
    required this.keywordsString,
  }) : assert(
          mediaType == MediaType.movie || mediaType == MediaType.tv,
          'Only movie and tv media titles are allowed!',
        );
}
