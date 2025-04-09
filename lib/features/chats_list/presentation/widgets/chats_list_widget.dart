import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/chats_list/data/model/chats_model.dart';
import 'package:zawaj/features/chats_list/presentation/cubit/get_chats_cubit.dart';
import 'package:zawaj/features/chats_list/presentation/widgets/chat_item_widget.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/home/presentation/blocs/home_bloc/home_bloc.dart';

class ChatsListWidget extends StatelessWidget {
  final String searchQuery;

  const ChatsListWidget({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Chat>>(
      stream: context.read<ChatsCubit>().chatsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 150,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text(' ! خطا حدث'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا يوجد محادثات'));
        } else {
          final List<Chat> filteredChats = snapshot.data!.where((chat) {
            return chat.userName
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomText(text: 'مراسلات'),
                  const SizedBox(width: 10),
                  Container(
                    height: 25,
                    width: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.secondaryPinkColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Center(
                        child: CustomText(
                          text: '${filteredChats.length}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = filteredChats[index];
                    final homeModel =
                        HomeBloc.get(context).homeModelList.firstWhere(
                              (model) => model.userId == chat.userId,
                              orElse: () => HomeModel.empty(),
                            );

                    final imageUrl = chat.userImages.isNotEmpty
                        ? '${EndPoints.BASE_URL_image}${chat.userImages[0]}'
                        : '';
                    return ChatItemWidget(
                      name: chat.userName,
                      lastMessage: chat.lastMessage,
                      imageUrl: imageUrl,
                      userId: chat.userId,
                      homeModel: homeModel,
                      chat: chat,
                      lastMessageTime: chat.lastMessageTime,
                      unseenMessages: chat.unseenMessages,
                      lastMessageState: chat.lastMessageState,
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
