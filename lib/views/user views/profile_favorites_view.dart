import 'package:flutter/material.dart';
import 'package:petgo_clone/models/store_model.dart';
import 'package:petgo_clone/services/favorite_service.dart';
import 'package:petgo_clone/services/get_all_stores.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/user%20views/store_view.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:petgo_clone/widgets/store_card_widget.dart';

class MyProfileFavoritesView extends StatefulWidget {
  const MyProfileFavoritesView({super.key});

  @override
  State<MyProfileFavoritesView> createState() => _MyProfileFavoritesViewState();
}

class _MyProfileFavoritesViewState extends State<MyProfileFavoritesView> {
  List<Store> favoriteStores = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteStores();
  }

  Future<void> fetchFavoriteStores() async {
    final favoriteIds = await FavoriteService.getFavoritesIds();
    final allStores = await getAllStores();

    setState(() {
      favoriteStores =
          allStores.where((store) => favoriteIds.contains(store.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showShadow: true,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, color: AppTheme.yellowColor),
            SizedBox(width: 6),
            Text("المفضلة", style: AppTheme.font20SemiBold),
          ],
        ),
        rightButton: SquareIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          favoriteStores.isEmpty
              ? const Center(child: Text("لا يوجد متاجر مفضلة حالياً"))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                itemCount: favoriteStores.length,
                itemBuilder: (context, index) {
                  final store = favoriteStores[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreView(store: store),
                          ),
                        );
                      },
                      child: StoreCardWidget(
                        storeName: store.name,
                        description: store.description,
                        logoUrl: store.logoUrl,
                        rating: store.rating,
                        distanceKm: store.distanceKm,
                        deliveryPrice: store.deliveryPrice,
                        isLiked: true,
                        onLikePressed: () async {
                          await FavoriteService.removeFromFavorites(store.id);
                          fetchFavoriteStores();
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
