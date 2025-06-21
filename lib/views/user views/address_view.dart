import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/auth%20views/login_view.dart';
import 'package:petgo_clone/views/user%20views/bottom_nav_user.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_bottom_section%20.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
import 'package:petgo_clone/widgets/custom_textfelid_widget.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddressView extends StatefulWidget {
  final bool isEditing;
  final Function(LatLng, String)? onLocationSaved;
  final bool? fromPayment;

  const AddressView({
    super.key,
    this.isEditing = false,
    this.onLocationSaved,
    this.fromPayment,
  });

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  final TextEditingController nameController = TextEditingController();
  final MapController mapController = MapController();
  LatLng selectedLatLng = LatLng(21.3555, 39.9840); // مكة مبدئياً

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'حدد موقع التوصيل',
        rightButton: SquareIconButton(
          icon: widget.isEditing ? Icons.arrow_back : Icons.close,
          onPressed: () {
            if (widget.fromPayment == true) {
              Navigator.pop(context); // يرجع لصفحة الدفع
            } else if (widget.isEditing) {
              Navigator.pop(context); // يرجع للمحرر
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          // ✅ الخريطة
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: selectedLatLng,
                initialZoom: 15.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    selectedLatLng = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.petgo',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 60,
                      height: 60,
                      point: selectedLatLng,
                      child: Image.asset(
                        'assets/icons/pin.png',
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ حقل اسم الموقع
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: CustomTextfeildWidget(
              title: 'اسم الموقع',
              controller: nameController,
              secureText: false,
              textAlign: TextAlign.right,
              hintText: 'أعطِ هذا الموقع اسم',
            ),
          ),

          // ✅ زر التأكيد
          CustomBottomSection(
            child: CustomButton(
              title: 'تأكيد الموقع',
              pressed: () async {
                final name = nameController.text.trim();
                final lat = selectedLatLng.latitude;
                final lng = selectedLatLng.longitude;

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('أعط هذا الموقع اسم')),
                  );
                  return;
                }

                if (widget.isEditing && widget.onLocationSaved != null) {
                  widget.onLocationSaved!(selectedLatLng, name);
                  Navigator.pop(context, true);
                } else {
                  await Supabase.instance.client
                      .from('users')
                      .update({
                        'location_name': name,
                        'latitude': lat,
                        'longitude': lng,
                      })
                      .eq(
                        'user_id',
                        Supabase.instance.client.auth.currentUser!.id,
                      );

                  if (widget.fromPayment == true) {
                    Navigator.pop(context); // نرجع لصفحة الدفع فقط
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const BottomNavUser()),
                      (route) => false,
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
