import 'package:flutter/material.dart';
import 'package:petgo_clone/models/product_model.dart';
import 'package:petgo_clone/models/sub_category.dart';
import 'package:petgo_clone/provider/cart_provider.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/product_list_widget.dart';
import 'package:provider/provider.dart';
 
//  لعرض تصنيفات المنتجات

class SubCategoryWidget extends StatelessWidget {
  final List<SubCategory> subCategories;
  final List<Product> allProducts;

  final double paddingRight;
  final double paddingLeft;

  const SubCategoryWidget({
    Key? key,
    required this.subCategories,
    required this.allProducts,
    this.paddingRight = 16.0,
    this.paddingLeft = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final cartProvider = context.watch<CartProvider>();
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1.5,
        ),
      ),
padding: const EdgeInsets.only(top: 14, bottom: 16, left: 7, right: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subCategories.map((subCategory) {
          final products = allProducts
              .where((product) => product.subCategoryId == subCategory.id)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  subCategory.name,
                  style: AppTheme.font13SemiBold.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              ProductListWidget(
                products: products,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}