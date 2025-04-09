import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:zawaj/features/removed_users/domain/entities/removed_user_entity.dart';
import 'package:zawaj/features/removed_users/presentation/cubit/removed_user_cubit.dart';
import 'package:zawaj/features/removed_users/presentation/cubit/unremove_user_cubit.dart';

import '../../../../core/constants/end_points.dart';

class RemovedUserWidget extends StatelessWidget {
  final RemovedUsersEntity removedUsersEntity;
  final Function(RemovedUsersEntity) onRemoveUser;

  const RemovedUserWidget(
      {super.key,
      required this.removedUsersEntity,
      required this.onRemoveUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnRemoveUserCubit(),
      child: BlocBuilder<UnRemoveUserCubit, UnRemoveUserState>(
        builder: (context, state) {
          return BlocConsumer<UnRemoveUserCubit, UnRemoveUserState>(
            listener: (context, state) {
              if (state == UnRemoveUserState.success) {
                onRemoveUser(removedUsersEntity);
                HomeBloc.get(context).getHomeData();
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: removedUsersEntity.images == null ||
                                removedUsersEntity.images!.isEmpty
                            ? const Icon(Icons.add)
                            : GestureDetector(
                                onTap: () {},
                                child: Image.network(
                                    EndPoints.BASE_URL_image +
                                        removedUsersEntity.images![0],
                                    width: context.width,
                                    height: context.height * 0.5,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                      color: Colors.white,
                                      width: context.width,
                                      height: context.height * 0.5,
                                      child: Image.asset(
                                          ImageManager.profileError));
                                }, frameBuilder: (context, child, frame,
                                        wasSynchronouslyLoaded) {
                                  return child;
                                }, loadingBuilder:
                                        (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: context.width,
                                        height: context.height * 0.5,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Card(
                              color: Colors.white.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<UnRemoveUserCubit>().removeUser(
                                      removedUsersEntity.setupId.toString());
                                },
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.5)),
                                    child: SvgPicture.asset(
                                      ImageManager.closeIcon,
                                      width: 14,
                                      height: 14,
                                      fit: BoxFit.scaleDown,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          align: TextAlign.start,
                          text: removedUsersEntity.name,
                          fontSize: Dimensions.largeFont,
                          textOverFlow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      CustomText(
                        text: removedUsersEntity.city,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
