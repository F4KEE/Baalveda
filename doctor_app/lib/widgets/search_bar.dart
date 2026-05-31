import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class ModernSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const ModernSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: AppTheme.premiumShadow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: AppTheme.primaryNavy,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textDark),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.search_rounded, size: 22, color: AppTheme.textLight),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
        ),
      ),
    );
  }
}