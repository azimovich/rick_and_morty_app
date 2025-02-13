import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import '../../../data/model/character_list_model.dart';
import '../../../data/repository/app_repository_impl.dart';

class SearchCharacterPageVm extends ChangeNotifier {
  bool isLoading = false;
  bool canLoadNext = true;
  bool isFetchingMore = false;

  int currentPage = 1;
  String? errorMessage;

  final List<CharacterModel> charactersModels = [];
  TextEditingController nameC = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final AppRepositoryImpl _appRepositoryImpl = AppRepositoryImpl();

  SearchCharacterPageVm() {
    scrollController.addListener(_scrollListener);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setFetchingMore(bool value) {
    isFetchingMore = value;
    notifyListeners();
  }

  Future<void> searchCharacterListModel({bool isLoadMore = false}) async {
    if (isLoadMore && !canLoadNext) return;
    if (isLoadMore && isFetchingMore) return;

    if (!isLoadMore) {
      currentPage = 1;
      canLoadNext = true;
      charactersModels.clear();
      _setLoading(true);
    } else {
      _setFetchingMore(true);
    }

    try {
      final data = await _appRepositoryImpl.searchCharacterListModel(
        page: currentPage,
        name: nameC.text.trim(),
      );

      if (data != null) {
        final jsonData = jsonDecode(data);

        if (jsonData.containsKey("error")) {
          errorMessage = "Character not found!";
        } else {
          final model = characterListModelFromJson(data);
          charactersModels.addAll(model.results ?? []);
          currentPage++;
          canLoadNext = model.info?.next != null;
        }
      } else {
        errorMessage = "Information not available. Please try again later.";
      }
    } on TimeoutException {
      errorMessage = "Connection timed out. Please check your internet connection and try again.";
    } on SocketException {
      errorMessage = "No internet connection. Please connect to the network and try again.";
    } catch (e) {
      errorMessage = "An error occurred. Error : $e";
    } finally {
      if (isLoadMore) {
        _setFetchingMore(false);
      } else {
        _setLoading(false);
      }
    }
  }

  void loadMoreCharacters() {
    searchCharacterListModel(isLoadMore: true);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      loadMoreCharacters();
    }
  }
}
