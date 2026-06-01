import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BuildToggleCard extends StatefulWidget {
  final String imgpath;
  final String title;
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  const BuildToggleCard({
    super.key,
    required this.imgpath,
    required this.title,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<BuildToggleCard> createState() => _BuildToggleCardState();
}

class _BuildToggleCardState extends State<BuildToggleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 238, 243, 247),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(widget.imgpath, width: 28, height: 28),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.grey[300]!.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: List.generate(widget.options.length, (index) {
                bool isSelected = widget.selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onChanged(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? MyColors.primaryBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)] : [],
                      ),
                      child: Center(
                        child: Text(
                          widget.options[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
