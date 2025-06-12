import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// مستطيل يعرض الخريطة و محدد بها الموقع اللذي تم اختياره بعد تسجيل الدخول
// يستخدم في صفحة الدفع
// يستخدم في صفحة التتبع

class MapPreviewWidget extends StatelessWidget {
  final LatLng location;
  final double width;
  final double height;

  const MapPreviewWidget({
    super.key,
    required this.location,
    this.width = 380,
    this.height = 204,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.hardEdge,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: location,
          initialZoom: 15,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none, // يمنع أي تفاعل (بريفيو فقط)
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.petgo',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: location,
                width: 40,
                height: 40,
                child: Image.asset('assets/icons/pin.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
