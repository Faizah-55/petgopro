import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

enum SectionRowType {
  titleWithPriceAndIcon,    // نص و سعر 
  headerText,               // فقط عنوان بتنسيق خاص
  titleWithIconAndTime,     // نص + وقت + أيقونة
  mapWithTitleAndButton,    // خريطة + صف تحته
  titleWithButton,          // نص يمين + زر يسار
  titleWithTextAndIcon,     // نص يمين + نص يسار + أيقونة (جديد)
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
  final bool showTopDivider;
  final String? trailingText;

  const SectionRowWidge({
    super.key,
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
    this.showTopDivider = false,
    this.trailingText,
  });

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
            style: textStyle ?? AppTheme.font18SemiBold.copyWith(color: AppTheme.primaryColor),
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
              child: mapWidget ?? const Center(child: Text('الخريطة هنا')),
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

      case SectionRowType.titleWithTextAndIcon:
        content = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textStyle ?? AppTheme.font16SemiBold.copyWith(color: AppTheme.primaryColor),
              textDirection: TextDirection.rtl,
            ),
            Row(
              children: [
                if (icon != null)
                  Icon(icon, size: 20, color: AppTheme.yellowColor),
                const SizedBox(width: 4),
                Text(
                  trailingText ?? '',
                  style: AppTheme.font14Medium.copyWith(color: AppTheme.primaryColor),
                ),
              ],
            ),
          ],
        );
        break;
    }

    return Column(
      children: [
        if (showTopDivider)
          Container(
            height: 1,
            width: double.infinity,
            color: AppTheme.borderColor,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: content,
        ),
        if (showDivider)
          Container(
            height: 1,
            width: double.infinity,
            color: AppTheme.borderColor,
          ),
      ],
    );
  }
}