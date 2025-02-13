import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/custom_app_bar_widget.dart';
import '../../vm/search_character_page_vm.dart';
import '../widgets/search_character_page_body_widget.dart';

final searchCharacterPageVM = ChangeNotifierProvider.autoDispose<SearchCharacterPageVm>((ref) {
  final vm = SearchCharacterPageVm();
  return vm;
});

class SearchCharacterPage extends ConsumerStatefulWidget {
  const SearchCharacterPage({super.key});

  @override
  ConsumerState<SearchCharacterPage> createState() => _SearchCharacterPageState();
}

class _SearchCharacterPageState extends ConsumerState<SearchCharacterPage> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(searchCharacterPageVM);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: 'Search Character',
        canPop: true,
        actions: [],
      ),
      body: SearchCharacterPageBodyWidget(vm: vm),
    );
  }
}
