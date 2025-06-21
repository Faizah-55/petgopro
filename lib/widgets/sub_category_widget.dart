
import 'package:flutter/material.dart';
import 'package:petgo_clone/models/product_model.dart';
import 'package:petgo_clone/models/sub_category.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/product_list_widget.dart';

class SubCategoryWidget extends StatelessWidget {
  final List<SubCategory> subCategories;
  final List<Product> allProducts;

  // ✅ نضيف بيانات المتجر
  final String storeName;
  final String storeUrl;
  final String storeId;
  final double paddingRight;
  final double paddingLeft;

  const SubCategoryWidget({
    super.key,
    required this.subCategories,
    required this.allProducts,
    required this.storeName,
    required this.storeUrl,
    required this.storeId,
    this.paddingRight = 16.0,
    this.paddingLeft = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
            borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),   
                  topRight: Radius.circular(0),   
                  bottomLeft: Radius.circular(6),  
                  bottomRight: Radius.circular(6), 
    ),       
     
        border: Border.all(
            color:  AppTheme.borderColor
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
                storeName: storeName,   // ✅ نمرر اسم المتجر
                storeUrl: storeUrl,     // ✅ نمرر رابط صورة المتجر
                storeId: storeId,     // ✅ نمرر رابط صورة المتجر
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
