import 'package:flutter/material.dart';


class NotificationButton extends StatelessWidget {
  final int notificationCount;
  final VoidCallback? onPressed;

  const NotificationButton({
    super.key,
    required this.notificationCount,
    required this.onPressed,
  });


  String _formatCount(int count){
    if(count > 999){
      return '99+';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 36,
      icon: Stack(
        children: [
          const Icon(
            Icons.notifications, 
            color: Colors.white,
            size: 32,
          ),
          if (notificationCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  _formatCount(notificationCount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}