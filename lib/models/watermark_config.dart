enum WatermarkSizeMode { px, dp, auto }

class WatermarkConfig {
  bool isEnabled;
  String? imagePath;
  WatermarkSizeMode sizeMode;
  double sizePercentage; // نسبة الحجم من الضلع القصير
  double minDp;
  double maxDp;
  double opacity; // القيمة بين 0.0 و 1.0
  double rotationDegree; // درجة الدوران من 0 إلى 360

  WatermarkConfig({
    this.isEnabled = true,
    this.imagePath,
    this.sizeMode = WatermarkSizeMode.auto,
    this.sizePercentage = 0.38,
    this.minDp = 420.0,
    this.maxDp = 600.0,
    this.opacity = 0.04,
    this.rotationDegree = 0.0,
  });
}
