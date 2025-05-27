import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/Square_icon_button.dart';
import 'package:petgo_clone/widgets/custom_search_bar.dart';
import 'package:petgo_clone/widgets/store_card_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchView extends StatefulWidget {
  final String searchType; // 'store' أو 'product'

  const SearchView({super.key, required this.searchType});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> results = [];

  /// ✅ دالة البحث تتحدث مع كل تغيير في الحقل
  void performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        results = [];
      });
      return;
    }

    final table = widget.searchType == 'product' ? 'products' : 'stores';
    final response = await Supabase.instance.client
        .from(table)
        .select()
        .ilike('name', '%$query%');

    setState(() {
      results = response;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: results.isEmpty
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
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];

                        if (widget.searchType == 'store') {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: StoreCardWidget(
                              storeName: item['name'],
                              description: item['description'],
                              logoUrl: item['logo_url'],
                              rating: (item['rating'] ?? 0).toDouble(),
                              distanceKm:
                                  (item['distance_km'] ?? 0).toDouble(),
                              deliveryPrice:
                                  (item['delivery_price'] ?? 0).toDouble(),
                              isLiked: false,
                              onLikePressed: () {},
                            ),
                          );
                        }

                        // ✅ لاحقًا: لو كان النوع 'product'، اعرض ويدجت المنتج هنا
                        return const SizedBox(); // مؤقتًا
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}