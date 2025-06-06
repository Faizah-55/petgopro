

import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';


// تصميم صف مع حد 
// يعرض نص و سعر
// استخدم في صفحة السلة و الدفع 

enum SectionRowType {
  titleWithPriceAndIcon,   // نص و سعر 
  headerText,              // فقط عنوان بتنسيق خاص
  titleWithIconAndTime,    // نص + وقت + أيقونة
  mapWithTitleAndButton,   //  خريطة + صف تحته
  titleWithButton,         // نص يمين + زر يسار
}


class SectionRowWidge extends StatelessWidget {
  final SectionRowType type;

  final String title;
  final double? price;
  final IconData? icon;
  final bool showDivider;
  final TextStyle? textStyle;
  final bool showPrice;
  final bool showIcon;
  final String? timeText;

  final Widget? mapWidget;
  final Widget? customButton;

  const SectionRowWidge({
    Key? key,
    required this.type,
    required this.title,
    this.price,
    this.icon,
    this.showDivider = true,
    this.textStyle,
    this.showPrice = true,
    this.showIcon = true,
    this.timeText,
    this.mapWidget,
    this.customButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (type) {
      case SectionRowType.titleWithPriceAndIcon:
        content = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textStyle ?? AppTheme.font16SemiBold.copyWith(color: AppTheme.primaryColor),
               textDirection: TextDirection.rtl,

            ),
            if (showPrice && price != null)
              Row(
                children: [
                  if (showIcon && icon != null)
                    Icon(icon, size: 20, color: AppTheme.yellowColor),
                  const SizedBox(width: 4),
                  Text(
                    '${price!.toStringAsFixed(2)} ريال',
                    style: AppTheme.font12Medium.copyWith(color: AppTheme.primaryColor),
                  ),
                ],
              ),
          ],
        );
        break;

      case SectionRowType.headerText:
        content = Align(
          alignment: Alignment.centerRight,
          child: Text(
            title,
            style: textStyle?? AppTheme.font18SemiBold.copyWith(color: AppTheme.primaryColor),
          ),
        );
        break;

      case SectionRowType.titleWithIconAndTime:
        content = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textStyle ?? AppTheme.font16SemiBold.copyWith(color: AppTheme.primaryColor),
            ),
            Row(
              children: [
                if (icon != null)
                  Icon(icon, size: 20, color: AppTheme.yellowColor),
                const SizedBox(width: 4),
                Text(
                  timeText ?? '',
                  style: AppTheme.font16SemiBold.copyWith(color: AppTheme.primaryColor),
                ),
              ],
            ),
          ],
        );
        break;

      case SectionRowType.mapWithTitleAndButton:
        content = Column(
          children: [
            Container(
              height: 140,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: mapWidget ?? Center(child: Text('الخريطة هنا')),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: textStyle ?? AppTheme.font16SemiBold.copyWith(color: AppTheme.primaryColor),
                ),
                if (customButton != null) customButton!,
              ],
            ),
          ],
        );
        break;

      case SectionRowType.titleWithButton:
        content = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textStyle ?? AppTheme.font16SemiBold.copyWith(color: AppTheme.primaryColor),
            ),
            if (customButton != null) customButton!,
          ],
        );
        break;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: content,
        ),
        if (showDivider)
          Container(
            height: 1,
            width: double.infinity,color: AppTheme.borderColor,
          ),
      ],
    );
  }
}