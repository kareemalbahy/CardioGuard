import 'package:cardiogaurd/features/doctor/domain/entities/doctor_profile_entity.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/image_utils.dart';
import '../../../../core/theme/app_colors.dart';

class DoctorContactCard extends StatelessWidget {
  final DoctorProfileEntity doctor;
  final VoidCallback onMessagePressed;
  final VoidCallback? onViewProfile;
  final VoidCallback? onRemove;

  const DoctorContactCard({
    super.key,
    required this.doctor,
    required this.onMessagePressed,
    this.onViewProfile,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: CardioImageUtils.getImageProvider(
                          doctor.imagePath,
                          fallback: 'images/doctor_placeholder.png',
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                      border: Border.all(
                        color: const Color(0xFF00458D).withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  if (doctor.isOnline)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        height: 14,
                        width: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9FFFCB),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(
                        color: MyColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          doctor.hospital,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onViewProfile != null || onRemove != null)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'view' && onViewProfile != null) {
                      onViewProfile!();
                    } else if (value == 'remove' && onRemove != null) {
                      onRemove!();
                    }
                  },
                  itemBuilder: (context) => [
                    if (onViewProfile != null)
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, size: 20),
                            SizedBox(width: 8),
                            Text("View Profile"),
                          ],
                        ),
                      ),
                    if (onRemove != null)
                      const PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.person_remove_outlined, size: 20, color: MyColors.alertRed),
                            SizedBox(width: 8),
                            Text("Cancel Assignment", style: TextStyle(color: MyColors.alertRed)),
                          ],
                        ),
                      ),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onMessagePressed,
              icon: const Icon(
                Icons.chat_bubble_outline,
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                "Message Specialist",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
