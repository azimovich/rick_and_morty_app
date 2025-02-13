import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route_names.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/widgets/custom_app_bar_widget.dart';
import '../../vm/character_page_vm.dart';
import '../widgets/character_page_body_widget.dart';

final characterPageVM = ChangeNotifierProvider.autoDispose<CharacterPageVm>((ref) {
  final vm = CharacterPageVm();
  return vm;
});

class CharacterPage extends ConsumerStatefulWidget {
  const CharacterPage({super.key});

  @override
  ConsumerState<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends ConsumerState<CharacterPage> {
  // late ScrollController _scrollController;

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController = ScrollController();

  //   _scrollController.addListener(() {
  //     final vm = ref.read(characterPageVM);
  //     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !vm.isFetchingMore) {
  //       vm.getCharacterListModel(isLoadMore: true);
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(characterPageVM);

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Characters',
        canPop: false,
        actions: [
          IconButton(
            onPressed: () {
              context.go('/${AppRouteNames.searchCharacterPage}');
            },
            icon: Icon(CupertinoIcons.search, color: Colors.white),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          vm.getCharacterListModel();
        },
        color: AppColors.white,
        backgroundColor: AppColors.c3C3E44,
        child: CharacterPageBodyWidget(vm: vm),
      ),
    );
  }
}
