import 'package:flutter/material.dart';

class DeliveryOption extends StatelessWidget {
  final VoidCallback onTap;
  
  const DeliveryOption({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.delivery_dining),
        title: Text('Entrega ao domicílio'),
      ),
    );
  }
}