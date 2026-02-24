import 'package:flutter/material.dart';

class AppTheme {
  static const _brand = Color(0xFF6C63FF);
  static const _accent = Color(0xFF00D4FF);

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _brand,
      brightness: Brightness.light,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF3F5FF),
      appBarTheme: const AppBarTheme(centerTitle: false),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white.withOpacity(0.7),
      ),
      extensions: const [
        GradientPalette(
          primary: LinearGradient(colors: [_brand, _accent]),
        ),
      ],
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _brand,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
    );
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0B1020),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white10,
      ),
      extensions: const [
        GradientPalette(
          primary: LinearGradient(colors: [_brand, _accent]),
        ),
      ],
    );
  }
}

@immutable
class GradientPalette extends ThemeExtension<GradientPalette> {
  const GradientPalette({required this.primary});

  final LinearGradient primary;

  @override
  ThemeExtension<GradientPalette> copyWith({LinearGradient? primary}) {
    return GradientPalette(primary: primary ?? this.primary);
  }

  @override
  ThemeExtension<GradientPalette> lerp(covariant ThemeExtension<GradientPalette>? other, double t) {
    if (other is! GradientPalette) return this;
    return t < 0.5 ? this : other;
  }
}
