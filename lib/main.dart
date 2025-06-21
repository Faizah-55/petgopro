import 'package:flutter/material.dart';
import 'package:petgo_clone/provider/cart_provider.dart';
import 'package:petgo_clone/provider/favorit_provider.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/splash_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://remppmohbnwuotdwggiv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJlbXBwbW9oYm53dW90ZHdnZ2l2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5OTk2MTEsImV4cCI6MjA2MTU3NTYxMX0.Hrgk6vZQ4QXJXPOW60vhjwSdTKeXCqGw9JSJgEVFrHw',
  );
  runApp(const PetGoApp());
}

class PetGoApp extends StatelessWidget {
  const PetGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()) // ✅ تمت الإضافة
      ],
      child: MaterialApp(
        locale: const Locale('ar'),
        title: 'PetGo',
        home: const SplashView(),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}