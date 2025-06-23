import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  
  const CustomSearchBar({
    super.key,
    required this.searchController,
  });

  Widget _buildSearchBar() {
    return TextFormField(
      controller: searchController,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: 'Pesquisa ...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: _buildSearchBar(),
    );
  }
}
