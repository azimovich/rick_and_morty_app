import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../data/model/character_list_model.dart';
import '../../vm/search_character_page_vm.dart';
import 'character_page_card_widget.dart';

class SearchCharacterPageBodyWidget extends StatelessWidget {
  final SearchCharacterPageVm vm;
  const SearchCharacterPageBodyWidget({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          TextField(
            controller: vm.nameC,
            style: TextStyle(color: AppColors.white),
            cursorColor: const Color.fromRGBO(255, 255, 255, 0.3),
            decoration: InputDecoration(
              filled: true,
              hintText: 'Character name',
              fillColor: AppColors.c3C3E44,
              hintStyle: TextStyle(color: const Color.fromRGBO(255, 255, 255, 0.3)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(26.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(26.r),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: vm.searchCharacterListModel,
              ),
            ),
          ),
          10.verticalSpace,
          Expanded(
            child: vm.isLoading
                ? Center(child: CircularProgressIndicator(color: AppColors.white))
                : vm.errorMessage != null
                    ? Center(child: Text(vm.errorMessage!, style: TextStyle(color: AppColors.white)))
                    : vm.charactersModels.isEmpty
                        ? Center(child: Text("Character list is empty", style: TextStyle(color: AppColors.white)))
                        : GridView.builder(
                            controller: vm.scrollController,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: vm.charactersModels.length + (vm.isFetchingMore ? 1 : 0),
                            itemBuilder: (_, i) {
                              if (i == vm.charactersModels.length) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              CharacterModel model = vm.charactersModels[i];
                              return CharacterPageCardWidget(model: model, onTap: () {});
                            },
                          ),
          ),
          // Text("Load More")
        ],
      ),
    );
  }
}
