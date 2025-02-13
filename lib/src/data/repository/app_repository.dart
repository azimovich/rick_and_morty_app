abstract class AppRepo {
  Future<String?> getCharacterListModel({int? page});
  Future<String?> searchCharacterListModel({int? page, String? name});
}
