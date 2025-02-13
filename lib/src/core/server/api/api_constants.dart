final class ApiConst {
  const ApiConst._();

  static const Duration connectionTimeout = Duration(minutes: 2);
  static const Duration sendTimeout = Duration(minutes: 2);
  static const Duration receiveTimeout = Duration(minutes: 2);

  static const String baseUrl = "http://rickandmortyapi.com";

  static String apiGetCharacterWithId(int id) => '/api/character/$id';

  static const String apiCharacter = "/api/character/";
  static const String apiLocation = "/api/location/";
  static const String apiEpisode = "/api/episode/";
}

final class ApiParams {
  const ApiParams._();

  static Map<String, dynamic> pageParams({required int page}) => <String, dynamic>{
        "page": page,
      };

  static Map<String, dynamic> emptyParams() => <String, dynamic>{};
}
