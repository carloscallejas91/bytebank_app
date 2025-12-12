import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/widgets/custom_button.dart';

class SaveButton extends StatelessWidget {
  final String textButton;
  final bool isLoading;
  final VoidCallback onSave;

  const SaveButton({
    super.key,
    required this.textButton,
    required this.isLoading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: textButton,
        isLoading: isLoading,
        onPressed: onSave,
      ),
    );
  }
}
