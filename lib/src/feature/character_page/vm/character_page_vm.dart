import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/model/character_list_model.dart';
import '../../../data/repository/app_repository_impl.dart';

class CharacterPageVm extends ChangeNotifier {
  bool isLoading = true;
  bool canLoadNext = true;
  bool isFetchingMore = false;

  int currentPage = 1;
  String? errorMessage;
  String? deletMessage;

  final List<CharacterModel> charactersModels = [];

  final AppRepositoryImpl _appRepositoryImpl = AppRepositoryImpl();
  final ScrollController scrollController = ScrollController();

  CharacterPageVm() {
    getCharacterListModel();
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

  Future<void> getCharacterListModel({bool isLoadMore = false}) async {
    if (!canLoadNext && isLoadMore) return;
    if (isLoadMore && isFetchingMore) return;

    errorMessage = null;
    if (!isLoadMore) {
      currentPage = 1;
      canLoadNext = true;
      charactersModels.clear();
      _setLoading(true);
    } else {
      _setFetchingMore(true);
    }

    try {
      final data = await _appRepositoryImpl.getCharacterListModel(page: currentPage);
      if (data != null) {
        final model = characterListModelFromJson(data);
        charactersModels.addAll(model.results ?? []);
        currentPage++;
        canLoadNext = model.info?.next != null;
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
        Future.delayed(const Duration(seconds: 1), () {
          _setFetchingMore(false);
        });
      } else {
        _setLoading(false);
      }
    }
  }

  void loadMoreCharacters() {
    getCharacterListModel(isLoadMore: true);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      loadMoreCharacters();
    }
  }
}
