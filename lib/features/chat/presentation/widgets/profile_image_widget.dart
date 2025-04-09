import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/home/presentation/pages/partner_details_screen.dart'; // Replace with your actual import

class ProfileImageWidget extends StatelessWidget {
  final String imageUrl;
  final HomeModel homeModel;

  const ProfileImageWidget({
    Key? key,
    required this.imageUrl,
    required this.homeModel,
  }) : super(key: key);

  void _onErrorTap(BuildContext context) {
    if (homeModel.age != null) {
      MagicRouter.navigateTo(
        PartnerDetailsScreen(
          homeModel: homeModel,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 40,
        width: 40,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => GestureDetector(
          onTap: () => _onErrorTap(context),
          child: ClipOval(
            child: Image.asset(
              ImageManager.profileError,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
