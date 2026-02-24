enum ImageFormat { png, jpg, webp }

enum WatermarkPosition { topLeft, topRight, center, bottomLeft, bottomRight }

class ConversionSettings {
  const ConversionSettings({
    required this.convertAll,
    required this.pageRanges,
    required this.imageFormat,
    required this.dpi,
    required this.quality,
    required this.grayscale,
    required this.optimizeCompression,
    required this.watermark,
    required this.watermarkOpacity,
    required this.watermarkPosition,
    required this.presetName,
  });

  final bool convertAll;
  final String pageRanges;
  final ImageFormat imageFormat;
  final int dpi;
  final int quality;
  final bool grayscale;
  final bool optimizeCompression;
  final String watermark;
  final double watermarkOpacity;
  final WatermarkPosition watermarkPosition;
  final String? presetName;

  ConversionSettings copyWith({
    bool? convertAll,
    String? pageRanges,
    ImageFormat? imageFormat,
    int? dpi,
    int? quality,
    bool? grayscale,
    bool? optimizeCompression,
    String? watermark,
    double? watermarkOpacity,
    WatermarkPosition? watermarkPosition,
    String? presetName,
  }) {
    return ConversionSettings(
      convertAll: convertAll ?? this.convertAll,
      pageRanges: pageRanges ?? this.pageRanges,
      imageFormat: imageFormat ?? this.imageFormat,
      dpi: dpi ?? this.dpi,
      quality: quality ?? this.quality,
      grayscale: grayscale ?? this.grayscale,
      optimizeCompression: optimizeCompression ?? this.optimizeCompression,
      watermark: watermark ?? this.watermark,
      watermarkOpacity: watermarkOpacity ?? this.watermarkOpacity,
      watermarkPosition: watermarkPosition ?? this.watermarkPosition,
      presetName: presetName ?? this.presetName,
    );
  }

  static const defaults = ConversionSettings(
    convertAll: true,
    pageRanges: '',
    imageFormat: ImageFormat.png,
    dpi: 150,
    quality: 90,
    grayscale: false,
    optimizeCompression: true,
    watermark: '',
    watermarkOpacity: 0.4,
    watermarkPosition: WatermarkPosition.bottomRight,
    presetName: null,
  );
}
