import 'package:flutter/material.dart';
import 'package:petgo_clone/provider/cart_provider.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/quantity_control_widget.dart';
import 'package:provider/provider.dart';

//  كارد للمنتجات 

class ProductCardWidget extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String name;
  final String shortDescription;
  final double price;
  final VoidCallback? onTap;

  const ProductCardWidget({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.shortDescription,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final quantity = cartProvider.getQuantity(productId); 

    void onQuantityChanged(int newCount) {
      if (newCount > 0) {
        cartProvider.addOrUpdateProduct(
          productId: productId,
          name: name,
          price: price,
          quantity: newCount,
          imageUrl: imageUrl,
          shortDescription: shortDescription,
        );
      } else {
        cartProvider.removeProduct(productId);
      }
    }

    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 374,
          height: 96.42,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.whiteColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.borderColor,
              width: 1,
            ),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.8),
                child: Image.network(
                  imageUrl,
                  width: 88.85,
                  height: 88.85,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.22),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTheme.font12SemiBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        shortDescription,
                        style: AppTheme.font10Regular,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.money,
                            color: AppTheme.yellowColor,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                           textDirection: TextDirection.rtl,
                            '${price.toStringAsFixed(2)} ريال',
                            style: AppTheme.font10Regular,
                          ),
                          const Spacer(),
                          Directionality(
                               textDirection: TextDirection.ltr, 
                               child: QuantityControlWidget(
                               initialCount: quantity,
                               onCountChanged: onQuantityChanged,
                              ),
                            ),

                          
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}