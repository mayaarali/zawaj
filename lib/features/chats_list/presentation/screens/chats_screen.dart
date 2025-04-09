import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/helper/profile_helper.dart';

import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text_field.dart';

import 'package:zawaj/features/chats_list/data/repository/repository_impl.dart';
import 'package:zawaj/features/chats_list/domain/reposiory/repository.dart';
import 'package:zawaj/features/chats_list/presentation/cubit/get_chats_cubit.dart';
import 'package:zawaj/features/chats_list/presentation/widgets/chats_list_widget.dart';
import 'package:zawaj/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String _searchQuery = '';
  late ChatsCubit _chatsCubit;

  @override
  void initState() {
    super.initState();
    HomeBloc.get(context).fetchAllHomeData();
    ProfileBloc.get(context).getMyProfile();
    ChatsCubit(GetChats(ChatRepository(Dio()))).onChat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProfileHelper.checkVerificationAndSubscription(context);
    });
    _chatsCubit = ChatsCubit(GetChats(ChatRepository(Dio())))..fetchChats();
  }

  @override
  void dispose() {
    ChatsCubit(GetChats(ChatRepository(Dio()))).close();
    ChatsCubit(GetChats(ChatRepository(Dio()))).outChat();

    _chatsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        isFullScreen: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'أبحث...',
                      height: 60,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: BlocProvider.value(
                  value: _chatsCubit,
                  child: ChatsListWidget(
                    searchQuery: _searchQuery,
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
