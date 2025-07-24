
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';


class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            final bool isSelected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                selected: isSelected,
                selectedColor: PaletaCores.corPrimaria,
                backgroundColor: Colors.white,
                onSelected: (selected) {
                  if (selected) {
                    onSelected(index);
                  }
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
