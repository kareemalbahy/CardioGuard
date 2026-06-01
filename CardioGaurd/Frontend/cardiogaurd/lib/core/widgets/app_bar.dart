import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:cardiogaurd/core/utils/image_utils.dart';
import 'package:flutter/material.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String profilePictureUrl;
  const BuildAppBar({super.key, required this.profilePictureUrl});

  @override
  Widget build(BuildContext context) {
    final imageProvider = CardioImageUtils.getImageProvider(profilePictureUrl);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Image.asset('images/heart.png'),
      ),
      title: const Text(
        'CardioGuard',
        style: TextStyle(
          color: MyColors.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: CircleAvatar(
              backgroundImage: imageProvider,
              radius: 18,
              onBackgroundImageError: (error, stackTrace) {
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}