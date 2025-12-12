import 'package:flutter/material.dart';

class TransactionSearchField extends StatelessWidget {
  final String labelText;
  final TextEditingController searchController;
  final bool isSearchActive;
  final VoidCallback onClearSearch;

  const TransactionSearchField({
    super.key,
    required this.labelText,
    required this.searchController,
    required this.isSearchActive,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: isSearchActive
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClearSearch,
              )
            : const SizedBox.shrink(),
        filled: true,
        fillColor: Colors.white,
        border: defaultBorder(),
        enabledBorder: defaultBorder(),
        focusedBorder: defaultBorder(),
      ),
    );
  }

  OutlineInputBorder defaultBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(width: 1.0),
    );
  }
}
