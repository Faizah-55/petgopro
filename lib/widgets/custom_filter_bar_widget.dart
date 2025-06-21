import 'package:flutter/material.dart';
import 'package:petgo_clone/widgets/custom_dropdown_filter.dart';

class FilterBarWidget extends StatelessWidget {
  final String? selectedDelivery;
  final String? selectedLocation;
  final String? selectedRating;
  final Function(String type, String value) onFilterSelected;

  const FilterBarWidget({
    super.key,
    required this.selectedDelivery,
    required this.selectedLocation,
    required this.selectedRating,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        CustomDropdownFilter(
          label: 'سعر التوصيل',
          selectedValue: selectedDelivery,
          options: ['توصيل مجاني', 'يبدأ من 5 ريال', 'الكل'],
          onSelected: (val) => onFilterSelected('delivery', val),
        ),
        CustomDropdownFilter(
          label: 'حسب الموقع',
          selectedValue: selectedLocation,
          options: ['الأقرب لك', 'الكل'],
          onSelected: (val) => onFilterSelected('location', val),
        ),
        CustomDropdownFilter(
          label: 'حسب التقييم',
          selectedValue: selectedRating,
          options: ['٤ نجوم وأكثر', '٣ نجوم وأكثر', 'الكل'],
          onSelected: (val) => onFilterSelected('rating', val),
        ),
      ],
    );
  }
}
