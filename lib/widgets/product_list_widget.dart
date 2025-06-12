import 'package:flutter/material.dart';
import 'package:petgo_clone/models/product_model.dart';
import 'package:petgo_clone/provider/cart_provider.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/user%20views/product_details_view.dart';
import 'package:petgo_clone/widgets/product_card_widget.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatelessWidget {
  final List<Product> products;
  final String storeName;
  final String storeUrl;
  final String storeId;

  const ProductListWidget({
    super.key,
    required this.products,
    required this.storeName,
    required this.storeUrl,
    required this.storeId,

  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    if (products.isEmpty) {
      return const Center(child: Text('لا يوجد منتجات'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = products[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          child: ProductCardWidget(
            productId: product.id,
            imageUrl: product.imageUrl ?? '',
            name: product.name,
            shortDescription: product.shortDescription,
            price: product.price,
            storeName: storeName,     // ✅ تمرير البيانات للمنتج
            storeUrl: storeUrl,
            storeId: storeId,          
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => DraggableScrollableSheet(
                  initialChildSize: 0.80,
                  maxChildSize: 0.80,
                  minChildSize: 0.80,
                  builder: (_, scrollController) => Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ProductDetailsView(product: product, storeName: '', storeUrl: '',storeId: '', ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}