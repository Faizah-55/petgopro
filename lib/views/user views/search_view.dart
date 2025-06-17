import 'package:flutter/material.dart';
import 'package:petgo_clone/models/store_model.dart';
import 'package:petgo_clone/provider/favorit_provider.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/Square_icon_button.dart';
import 'package:petgo_clone/widgets/custom_search_bar.dart';
import 'package:petgo_clone/widgets/store_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchView extends StatefulWidget {
  final String searchType; // 'store' أو 'product'

  const SearchView({super.key, required this.searchType});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  List<Store> storeResults = [];

  @override
  void initState() {
    super.initState();
    if (widget.searchType == 'store') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FavoriteProvider>().fetchFavorites();
      });
    }
  }

  void performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        storeResults = [];
      });
      return;
    }

    if (widget.searchType == 'store') {
      final response = await Supabase.instance.client
          .from('stores')
          .select()
          .ilike('name', '%$query%');

      final stores = (response as List)
          .map((json) => Store.fromJson(json))
          .toList();

      setState(() {
        storeResults = stores;
      });
    }

    // لاحقاً: تفعيل البحث في المنتجات
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// ✅ شريط الرجوع والبحث
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    SquareIconButton(
                      icon: Icons.arrow_back_ios_new,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomSearchBar(
                        controller: _controller,
                        hintText: widget.searchType == 'product'
                            ? 'ابحث عن منتج'
                            : 'ابحث عن متجر',
                        onChanged: performSearch,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ✅ عرض النتائج
            Expanded(
              child: storeResults.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد نتائج',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: storeResults.length,
                      itemBuilder: (context, index) {
                        final store = storeResults[index];
                        final isLiked =
                            favoriteProvider.isFavorite(store.id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: StoreCardWidget(
                            storeName: store.name,
                            description: store.description,
                            logoUrl: store.logoUrl,
                            rating: store.rating,
                            distanceKm: store.distanceKm,
                            deliveryPrice: store.deliveryPrice,
                            isLiked: isLiked,
                            onLikePressed: () =>
                                favoriteProvider.toggleFavorite(store.id),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}