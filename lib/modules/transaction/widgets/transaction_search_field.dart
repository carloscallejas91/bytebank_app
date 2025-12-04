import 'package:flutter/material.dart';

class TransactionSearchField extends StatelessWidget {
  final TextEditingController searchController;
  final bool isSearchActive;
  final VoidCallback onClearSearch;

  const TransactionSearchField({
    super.key,
    required this.searchController,
    required this.isSearchActive,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        labelText: 'Pesquisar por descrição',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: isSearchActive
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClearSearch,
              )
            : const SizedBox.shrink(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(width: 1.0),
        ),
      ),
    );
  }
}
