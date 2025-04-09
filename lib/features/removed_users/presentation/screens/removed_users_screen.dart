import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';

import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_popup.dart';

import 'package:zawaj/features/removed_users/presentation/cubit/removed_user_cubit.dart';
import 'package:zawaj/features/removed_users/presentation/widgets/removed_user_widget.dart';

class RemovedUsersListScreen extends StatefulWidget {
  const RemovedUsersListScreen({super.key});

  @override
  State<RemovedUsersListScreen> createState() => _RemovedUsersListScreenState();
}

class _RemovedUsersListScreenState extends State<RemovedUsersListScreen> {
  late final UserCubit userCubit;

  @override
  void initState() {
    super.initState();
    userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CustomAppBar(
              isSettingIcon: false,
              isBack: true,
              isMenuIcon: false,
              isHeartTitle: true,
            ),
          ),
          BlocBuilder<UserCubit, RemovedUsersState>(
            builder: (context, state) {
              if (state is RemovedUsersLoading && userCubit.users.isEmpty) {
                return const LoadingPopUp();
              } else if (state is RemovedUsersLoaded) {
                final uniqueUsers = state.users.toSet().toList();

                return uniqueUsers.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: CustomText(
                            text: Strings.listIsEmpty,
                          ),
                        ),
                      )
                    : Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (userCubit.state is! RemovedUsersLoading &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent) {
                              userCubit.fetchUsers(loadMore: true);
                            }
                            return true;
                          },
                          child: ListView.builder(
                            itemCount: uniqueUsers.length + 1,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == uniqueUsers.length) {
                                return userCubit.isLoadingMore
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: LinearProgressIndicator(
                                          color: ColorManager.primaryColor,
                                        ),
                                      )
                                    : Container();
                              }
                              final users = uniqueUsers[index];
                              return RemovedUserWidget(
                                removedUsersEntity: users,
                                onRemoveUser: (removedUser) {
                                  setState(() {
                                    state.users.removeWhere((user) =>
                                        user.userId.toString() ==
                                        removedUser.userId);
                                    // uniqueUsers.removeWhere((user) =>
                                    //user.userId == removedUser.userId);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      );
              } else if (state is RemovedUsersError) {
                log(state.message);
                return const Center(
                  child: Text('خطأ لقد حدث'),
                );
              } else {
                return const Center(
                  child: Text('خطأ لقد حدث'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
