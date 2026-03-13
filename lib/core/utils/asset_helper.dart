class AssetHelper {
  static const String _imagePath = 'assets/images';
  static const String _iconPath = 'assets/icons';

  // Images
  static String image(String name) => '$_imagePath/$name';

  // Icons
  static String icon(String name) => '$_iconPath/$name';

  // Common images
  static String get logo => image('logo.jpg');
  static String get placeholder => image('placeholder.jpg');
}
