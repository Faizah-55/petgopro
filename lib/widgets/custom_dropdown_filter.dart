import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

class CustomDropdownFilter extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final Function(String) onSelected;

  const CustomDropdownFilter({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF33A490)),
      ),
      itemBuilder: (context) {
        return options.map((option) {
          return PopupMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: AppTheme.font14Regular.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryColor,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          border: Border.all(color: const Color(0xFF33A490)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D0A0D12),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.keyboard_arrow_down, color: AppTheme.yellowColor, size: 16),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTheme.font14Regular.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
