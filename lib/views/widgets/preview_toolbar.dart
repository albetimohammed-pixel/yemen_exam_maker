import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PreviewToolbar extends StatelessWidget {
  final VoidCallback onZoomToggle;
  final VoidCallback onTemplateTap;
  final VoidCallback onPrintTap;

  const PreviewToolbar({
    Key? key,
    required this.onZoomToggle,
    required this.onTemplateTap,
    required this.onPrintTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppColors.darkPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.zoom_in, 'تكبير', onZoomToggle),
          _buildActionButton(Icons.style, 'نماذج', onTemplateTap),
          _buildActionButton(Icons.print, 'طباعة', onPrintTap),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
