import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../data/model/character_list_model.dart';
import '../../vm/character_page_vm.dart';
import 'character_page_card_widget.dart';

class CharacterPageBodyWidget extends StatelessWidget {
  final CharacterPageVm vm;
  // final ScrollController scrollController;
  const CharacterPageBodyWidget({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    } else if (vm.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              vm.errorMessage ?? "Xatolik yuz berdi",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => vm.getCharacterListModel(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.c3C3E44,
                foregroundColor: AppColors.white,
              ),
              child: const Text("Try again"),
            ),
          ],
        ),
      );
    } else {
      return vm.charactersModels.isEmpty
          ? Center(child: Text('List is empty'))
          : GridView.builder(
              controller: vm.scrollController,
              padding: REdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
            );
    }
  }
}

Widget statusIndicator(String status) {
  Color color;
  switch (status.toLowerCase()) {
    case "alive":
      color = Colors.green;
      break;
    case "dead":
      color = Colors.red;
      break;
    default:
      color = Colors.grey;
  }
  return CircleAvatar(radius: 5, backgroundColor: color);
}
