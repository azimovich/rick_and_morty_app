import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rick_and_morty_app/src/core/server/api/api.dart';
import 'package:rick_and_morty_app/src/core/server/api/api_constants.dart';

import 'app_repository.dart';

class AppRepositoryImpl implements AppRepo {
  const AppRepositoryImpl._();

  static final _inner = AppRepositoryImpl._();

  factory AppRepositoryImpl() => _inner;

  @override
  Future<String?> getCharacterListModel({int? page}) async {
    try {
      final param = ApiParams.pageParams(page: page ?? 1);

      final data = await ApiService.get(ApiConst.apiCharacter, param);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> searchCharacterListModel({int? page, String? name}) async {
    try {
      final param = {
        ...ApiParams.pageParams(page: page ?? 1),
        if (name != null && name.isNotEmpty) 'name': name, // 🔹 Name param qo'shildi
      };

      final data = await ApiService.get(ApiConst.apiCharacter, param);
      return data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        log('404');
        return jsonEncode(e.response?.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
