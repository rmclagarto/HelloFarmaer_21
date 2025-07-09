
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';


class BottomPanel extends StatelessWidget {
  final List<String> ads;
  final void Function(String ad)? onAdTap;

  const BottomPanel({super.key, required this.ads, this.onAdTap});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final bool showContent = height > 120;

            return Container(
              decoration: _buildDecoration(),
              child: Column(
                children: [
                  _buildHandleBar(),
                  _buildContent(showContent, scrollController),
                ],
              ),
            );
          },
        );
      },
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    );
  }

  Widget _buildHandleBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }

  Widget _buildContent(bool visible, ScrollController scrollController) {
    return Expanded(
      child: Opacity(
        opacity: visible ? 1.0 : 0.0,
        child: ListView.builder(
          controller: scrollController,
          itemCount: ads.length,
          itemBuilder: (context, index) {
            final ad = ads[index];
            return GestureDetector(
              onTap: () => onAdTap?.call(ad),
              child: _buildAdCard(ad),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdCard(String adText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 3,
        color: Constants.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.campaign, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  adText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
