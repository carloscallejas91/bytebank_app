import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceiptPicker extends StatelessWidget {
  final VoidCallback? _onPickReceipt;
  final VoidCallback? _onViewReceipt;
  final VoidCallback? _onRemoveReceipt;
  final String? _fileName;

  const ReceiptPicker.attach({super.key, required VoidCallback onPickReceipt})
    : _onPickReceipt = onPickReceipt,
      _onViewReceipt = null,
      _onRemoveReceipt = null,
      _fileName = null;

  const ReceiptPicker.localFile({
    super.key,
    required String fileName,
    required VoidCallback onRemoveReceipt,
  }) : _onPickReceipt = null,
       _onViewReceipt = null,
       _onRemoveReceipt = onRemoveReceipt,
       _fileName = fileName;

  const ReceiptPicker.existingReceipt({
    super.key,
    required VoidCallback onViewReceipt,
    required VoidCallback onRemoveReceipt,
  }) : _onPickReceipt = null,
       _onViewReceipt = onViewReceipt,
       _onRemoveReceipt = onRemoveReceipt,
       _fileName = null;

  @override
  Widget build(BuildContext context) {
    if (_onPickReceipt != null) {
      return _buildAttachButton(onPick: _onPickReceipt);
    }

    if (_fileName != null) {
      return _buildLocalFileDisplay(
        fileName: _fileName,
        onRemove: _onRemoveReceipt!,
      );
    }

    return _buildExistingReceiptDisplay(
      onView: _onViewReceipt!,
      onRemove: _onRemoveReceipt!,
    );
  }
}

OutlinedButton _buildAttachButton({required VoidCallback onPick}) {
  return OutlinedButton.icon(
    icon: Icon(Icons.attach_file, color: Get.theme.colorScheme.onSurface),
    label: Text(
      'Anexar comprovante',
      style: TextStyle(color: Get.theme.colorScheme.onSurface),
    ),
    onPressed: onPick,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
    ),
  );
}

Widget _buildLocalFileDisplay({
  required String fileName,
  required VoidCallback onRemove,
}) {
  return _buildReceiptInfoRow(
    icon: Icons.check_circle,
    iconColor: Colors.green,
    text: fileName,
    action: IconButton(
      icon: const Icon(Icons.close),
      onPressed: onRemove,
      tooltip: 'Remover anexo',
    ),
  );
}

Widget _buildExistingReceiptDisplay({
  required VoidCallback onView,
  required VoidCallback onRemove,
}) {
  return _buildReceiptInfoRow(
    icon: Icons.cloud_done,
    iconColor: Colors.blue,
    text: 'Comprovante salvo',
    action: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(onPressed: onView, child: const Text('Ver')),
        IconButton(
          icon: Icon(Icons.close, color: Get.theme.colorScheme.error),
          onPressed: onRemove,
          tooltip: 'Remover comprovante',
        ),
      ],
    ),
  );
}

Container _buildReceiptInfoRow({
  required IconData icon,
  required Color iconColor,
  required String text,
  required Widget action,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 12),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
        action,
      ],
    ),
  );
}
