import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

class StoreCardWidget extends StatelessWidget {
  final String storeName;
  final String description;
  final String logoUrl;
  final double rating;
  final double distanceKm;
  final double deliveryPrice;
  final VoidCallback onLikePressed;
  final bool isLiked;

  const StoreCardWidget({
    super.key,
    required this.storeName,
    required this.description,
    required this.logoUrl,
    required this.rating,
    required this.distanceKm,
    required this.deliveryPrice,
    required this.onLikePressed,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 379,
      height: 120,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              logoUrl,
              width: 111,
              height: 111,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),

          /// النصوص + زر اللايك
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      storeName,
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 32 / 15,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildInfoBox(context, Icons.star, '$rating'),
                        buildInfoBox(context, Icons.directions_car_outlined, '$deliveryPrice ريال'),
                        buildInfoBox(context, Icons.location_on_outlined, '$distanceKm كم'),
                      ],
                    ),
                  ],
                ),

                /// زر اللايك
                Positioned(
                  top: 2,
                  left: 1.1,
                  child: GestureDetector(
                    onTap: onLikePressed,
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? AppTheme.redColor : AppTheme.borderColor,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ويدجت المعلومات تحت اسم المتجر
  Widget buildInfoBox(BuildContext context, IconData icon, String label) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Icon(icon, color: AppTheme.yellowColor, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 32 / 12,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
