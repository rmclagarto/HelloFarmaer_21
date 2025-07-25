
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/imagens.dart';


class SellerInfo extends StatelessWidget {
  
  final String sellerName;
  final String rating;
  final VoidCallback onTap;
  final String? address;
  final String? phone; 

  const SellerInfo({
    super.key,
    required this.sellerName,
    required this.rating,
    required this.onTap,
    this.address,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(Imagens.agricultor),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sellerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      rating,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (phone != null || address != null) ...[
              const Divider(),
              if (phone != null) _buildInfoRow(Icons.phone, phone!),
              if (address != null) _buildInfoRow(Icons.location_on, address!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}