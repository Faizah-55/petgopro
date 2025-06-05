import 'package:flutter/material.dart';
import 'package:petgo_clone/models/cart_item_model.dart';
import 'package:petgo_clone/models/product_model.dart';
import 'package:petgo_clone/provider/cart_provider.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/user%20views/cart_view.dart';
import 'package:petgo_clone/widgets/cart_button_type.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_bottom_section%20.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:provider/provider.dart';

// صفحة تفاصيل المنتج

class ProductDetailsView extends StatefulWidget {
  final Product product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedWeightIndex = 0;

  String? selectedWeight;

  final List<String> weights = ['400غ', '2 كغم', '4 كغم', '10 كغم'];
  final List<double> weightMultipliers = [1.0, 3.0, 6.0, 12.0]; // مضاعفات السعر

  List<String> get productImages {
    List<String> images = [];
    if (widget.product.imageUrl != null) images.add(widget.product.imageUrl!);
    if (widget.product.extraImageUrl != null) images.add(widget.product.extraImageUrl!);
    return images;
  }

  void _goToPrevious() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentPage < productImages.length - 1) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  int _quantity = 1 ;

  double get currentPrice =>
      widget.product.price * weightMultipliers[_selectedWeightIndex];
  

  Widget build(BuildContext context) {


  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
       appBar : CustomAppBar(       
          showShadow: true,
           rightButton: SquareIconButton(
          icon: Icons.close,
          onPressed: () {
              Navigator.pop(context);
            }
           ),
           ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 279,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: productImages.length,
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            itemBuilder: (context, index) {
                              return Image.network(
                                productImages[index],
                                fit: BoxFit.cover,
                                width: 379,
                                height: 279,
                              );
                            },
                          ),
                          Positioned(
                            left: 8,
                            child: SquareIconButton(
                              icon: Icons.arrow_forward_ios,
                              onPressed: _goToPrevious,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            child: SquareIconButton( 
                              icon: Icons.arrow_back_ios,
                              onPressed: _goToNext,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //  محتوى تفاصيل المنتج
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            widget.product.name,
                            style: AppTheme.font24Bold.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.product.description ??
                                widget.product.shortDescription,
                            style: AppTheme.font16Medium.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                             textDirection: TextDirection.rtl,
                              children: [
                                      Icon(
                                        Icons.scale,
                                        size: 20,
                                        color: AppTheme.yellowColor,
                                         ),
                               const SizedBox(width: 4),
                               Text(
                                 'الوزن',
                                 style: AppTheme.font14Medium.copyWith(
                                 color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
    
                      Row(
                            children: [
                                        Icon(
                                          Icons.money,
                                          size: 20,
                                          color: AppTheme.yellowColor,
                                   ),
                                const SizedBox(width: 4),
                               Text(
                                '${currentPrice.toStringAsFixed(2)}',
                                 style: AppTheme.font14Medium.copyWith(
                                 color: AppTheme.primaryColor,
                            ),
                           ),
                                 const SizedBox(width: 4),
                               Text(
                                'ريال',
                                style: AppTheme.font14Medium.copyWith(
                                color: AppTheme.primaryColor,
                           ),
                         ),
                      ],
                   ),
                ],
              ), 

                          const SizedBox(height: 16),

                          //  خيارات الوزن
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(weights.length, (index) {
                              final isSelected = _selectedWeightIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedWeightIndex = index;
                                  });
                                },
                                child: Container(
                                  width: 58,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.yellowColor
                                        : AppTheme.whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppTheme.borderColor,
                                    ),
                                  ),
                                  child: Text(
                                    weights[index],
                                    style: AppTheme.font14Medium.copyWith(
                                      color: isSelected
                                          ? AppTheme.whiteColor
                                          : AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    //  البوتوم سكشن
                    SizedBox(
                      height: 80,
                      child: CustomBottomSection(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //  أزرار الكمية
                            Container(
                              width: 117,
                              height: 55,
                              decoration: BoxDecoration(color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: _quantity > 1
                                        ? () => setState(() => _quantity--)
                                        : null,
                                    child: Icon(
                                      Icons.remove,
                                      color: AppTheme.yellowColor,
                                      size: 24,
                                    ),
                                  ),
                                  Text(
                                    '$_quantity',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.whiteColor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => _quantity++),
                                    child: Icon(
                                      Icons.add,
                                      color: AppTheme.yellowColor,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            //  زر السلة
                            CartSummaryButtonWidget(
                              type: CartButtonType.small,
                              itemCount: 0,
                              totalPrice: currentPrice * _quantity ,
                              onPressed: () {
                            final cartProvider = Provider.of<CartProvider>(context, listen: false);

                               final newItem = CartItemModel(
                                  productId: widget.product.id,
                                   name: widget.product.name,
                                  price: currentPrice,
                                  quantity: _quantity,
                                  selectedWeight: selectedWeight ?? '',
                                 imageUrl: widget.product.imageUrl ?? '',
                            );

                            cartProvider.addItem(newItem);

                            Navigator.pop(context);
                                                  
                              },
                            ),
                          ],
                        ),
                      ),
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