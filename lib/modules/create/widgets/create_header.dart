import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';

class CreateHeader extends StatelessWidget {
  const CreateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAssets.logo);
  }
}
