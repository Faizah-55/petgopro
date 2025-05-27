import 'package:flutter/material.dart';
import 'package:petgo_clone/models/store_model.dart';
import 'package:petgo_clone/services/get_all_stores.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/user%20views/address_view.dart';
import 'package:petgo_clone/views/user%20views/search_view.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_filter_bar_widget.dart';
import 'package:petgo_clone/widgets/custom_search_bar.dart';
import 'package:petgo_clone/widgets/store_card_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Store> allStores = [];
  List<Store> filteredStores = [];
  bool isLoading = true;

  String? selectedDelivery = 'الكل';
  String? selectedLocation = 'الكل';
  String? selectedRating = 'الكل';
  String? locationName;

  @override
  void initState() {
    super.initState();
    readAllStores();
    fetchUserLocationName();
  }

  Future<void> fetchUserLocationName() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await Supabase.instance.client
        .from('users')
        .select('location_name')
        .eq('user_id', userId)
        .single();

    setState(() {
      locationName = response['location_name'] ?? 'حدد موقعك';
    });
  }

  Future<void> readAllStores() async {
    final response = await getAllStores();
    setState(() {
      allStores = response;
      filteredStores = response;
      isLoading = false;
    });
  }

  void handleFilterSelection(String type, String value) {
    setState(() {
      if (type == 'delivery') {
        selectedDelivery = value;
      } else if (type == 'location') {
        selectedLocation = value;
      } else if (type == 'rating') {
        selectedRating = value;
      }

      applyFilters();
    });
  }

  void applyFilters() {
    List<Store> temp = List.from(allStores);

    if (selectedDelivery != null && selectedDelivery != 'الكل') {
      if (selectedDelivery == 'توصيل مجاني') {
        temp = temp.where((s) => s.deliveryPrice == 0).toList();
      } else if (selectedDelivery == 'يبدأ من 5 ريال') {
        temp = temp.where((s) => s.deliveryPrice >= 5).toList();
      }
    }

    if (selectedLocation == 'الأقرب لك') {
      temp.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }

    if (selectedRating != null && selectedRating != 'الكل') {
      if (selectedRating == '٤ نجوم وأكثر') {
        temp = temp.where((s) => s.rating >= 4).toList();
      } else if (selectedRating == '٣ نجوم وأكثر') {
        temp = temp.where((s) => s.rating >= 3).toList();
      }
    }

    setState(() {
      filteredStores = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(
            showShadow: true,
            rightLogo: Image.asset(
              'assets/logo/logo_petgo.png',
              width: 111,
              height: 31,
            ),
            locationName: locationName ?? 'موقعك',
            onLocationTap: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddressView(isEditing: true),
                ),
              );

              if (updated == true) {
                fetchUserLocationName();
              }
            },
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomSearchBar(
              hintText: 'ابحث عن متجر',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchView(searchType: 'store'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 379,
            height: 187,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
              image: const DecorationImage(
                image: AssetImage('assets/app_img/poster.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilterBarWidget(
              selectedDelivery: selectedDelivery,
              selectedLocation: selectedLocation,
              selectedRating: selectedRating,
              onFilterSelected: handleFilterSelection,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredStores.isEmpty
                    ? const Center(child: Text('لا يوجد متاجر حالياً'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredStores.length,
                        itemBuilder: (context, index) {
                          final store = filteredStores[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: StoreCardWidget(
                              storeName: store.name,
                              description: store.description,
                              logoUrl: store.logoUrl,
                              rating: store.rating,
                              distanceKm: store.distanceKm,
                              deliveryPrice: store.deliveryPrice,
                              isLiked: false,
                              onLikePressed: () {},
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}