import 'package:flutter/material.dart';
import 'package:petgo_clone/models/animal_type.dart';
import 'package:petgo_clone/models/product_model.dart';
import 'package:petgo_clone/models/store_model.dart';
import 'package:petgo_clone/models/sub_category.dart';
import 'package:petgo_clone/provider/cart_provider.dart';
import 'package:petgo_clone/provider/favorit_provider.dart';
import 'package:petgo_clone/services/get_all_stores.dart';
import 'package:petgo_clone/views/user%20views/cart_view.dart';
import 'package:petgo_clone/views/user%20views/search_view.dart';
import 'package:petgo_clone/widgets/cart_button_type.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_bottom_section%20.dart';
import 'package:petgo_clone/widgets/custom_search_bar.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:petgo_clone/widgets/store_card_widget.dart';
import 'package:petgo_clone/widgets/animal_taps_widget.dart';
import 'package:petgo_clone/widgets/sub_category_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreView extends StatefulWidget {
  final Store store;

  const StoreView({super.key, required this.store});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  late String storeId;
  List<AnimalType> animalTypes = [];
  String? selectedAnimalId;

  List<SubCategory> subCategories = [];
  List<Product> allProducts = [];

  Map<String, List<Product>> productsBySubCategory = {};
  Store? _store;

  @override
  void initState() {
    super.initState();
    storeId = widget.store.id;
    fetchAnimalTypes();
    fetchStoreData();
  }

  Future<void> fetchAnimalTypes() async {
    try {
      final data = await Supabase.instance.client
          .from('animal_types')
          .select()
          .order('name');

      final loadedAnimals =
          (data as List).map((json) => AnimalType.fromJson(json)).toList();

      setState(() {
        animalTypes = loadedAnimals;
        if (animalTypes.isNotEmpty) {
          selectedAnimalId = animalTypes.first.id;
          fetchSubCategories(selectedAnimalId!);
          fetchProducts(storeId);
        }
      });
    } catch (error) {
      debugPrint('Error fetching animal types: $error');
    }
  }

  Future<void> fetchSubCategories(String animalId) async {
    try {
      final data = await Supabase.instance.client
          .from('sub_categories')
          .select()
          .eq('animal_type_id', animalId)
          .order('name');

      final loadedSubs =
          (data as List).map((json) => SubCategory.fromJson(json)).toList();

      setState(() {
        subCategories = loadedSubs;
        groupProducts();
      });
    } catch (e) {
      debugPrint('Exception fetching sub categories: $e');
    }
  }

  void fetchStoreData() async {
    final store = await getStoreById(storeId);
    if (store != null) {
      setState(() {
        _store = store;
      });

      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.setDeliveryPrice(store.deliveryPrice);

      // 🟡 هنا نحفظ بيانات المتجر عند أول مرة فقط
      if (cartProvider.storeName == null && cartProvider.storeUrl == null) {
        cartProvider.setStoreInfo(
          name: store.name,
          url: store.logoUrl,
          id: store.id,
        );
      }
    }
  }

  Future<void> fetchProducts(String storeId) async {
    final data = await Supabase.instance.client
        .from('products')
        .select()
        .eq('store_id', storeId);

    final loadedProducts =
        (data as List).map((json) => Product.fromJson(json)).toList();

    final Map<String, List<Product>> map = {};
    for (var product in loadedProducts) {
      final key = product.subCategoryId ?? '';
      if (key.isNotEmpty) {
        map.putIfAbsent(key, () => []).add(product);
      }
    }

    setState(() {
      productsBySubCategory = map;
      allProducts = loadedProducts;
    });
  }

  void groupProducts() {
    if (subCategories.isEmpty || allProducts.isEmpty) {
      setState(() {
        productsBySubCategory = {};
      });
      return;
    }

    Map<String, List<Product>> map = {};

    for (var subCat in subCategories) {
      map[subCat.id] = [];
    }

    for (var product in allProducts) {
      if (map.containsKey(product.subCategoryId)) {
        map[product.subCategoryId]!.add(product);
      }
    }

    setState(() {
      productsBySubCategory = map;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        showShadow: true,
        rightLogo: Image.asset(
          'assets/logo/logo_petgo.png',
          width: 111,
          height: 31,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 40,
                    child: CustomSearchBar(
                      hintText: 'ابحث عن منتج',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const SearchView(searchType: 'product'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 46,
                  height: 40,
                  child: Material(
                    child: SquareIconButton(
                      icon: Icons.arrow_forward,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StoreCardWidget(
              storeName: widget.store.name,
              description: widget.store.description,
              logoUrl: widget.store.logoUrl,
              rating: widget.store.rating,
              distanceKm: widget.store.distanceKm,
              deliveryPrice: widget.store.deliveryPrice,
              isLiked: favoriteProvider.isFavorite(widget.store.id),
              onLikePressed: () {
                favoriteProvider.toggleFavorite(widget.store.id);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: animalTypes.length,
                  itemBuilder: (context, index) {
                    final animal = animalTypes[index];
                    return AnimalTabWidget(
                      title: animal.name,
                      isSelected: animal.id == selectedAnimalId,
                      onTap: () {
                        setState(() {
                          selectedAnimalId = animal.id;
                          fetchSubCategories(selectedAnimalId!);
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SubCategoryWidget(
                  subCategories: subCategories,
                  allProducts: allProducts,
                  storeName: widget.store.name, // ✅ نمرر اسم المتجر
                  storeUrl: widget.store.logoUrl, // ✅ نمرر رابط صورة المتجر
                  storeId: storeId, // ✅ نمرر رابط صورة المتجر
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          cartProvider.totalItems > 0
              ? CustomBottomSection(
                child: CartSummaryButtonWidget(
                  type: CartButtonType.large,
                  itemCount: cartProvider.totalItems,
                  totalPrice: cartProvider.itemTotal,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartView()),
                    );
                  },
                ),
              )
              : null,
    );
  }
}
