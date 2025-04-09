import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/chats_list/data/repository/repository_impl.dart';
import 'package:zawaj/features/chats_list/presentation/cubit/get_chats_cubit.dart';
import 'package:zawaj/features/dashboard/states.dart';
import 'package:zawaj/features/home/presentation/pages/home_page.dart';
import 'package:zawaj/features/notification/presentation/screens/blur_notification.dart';

import '../chats_list/domain/reposiory/repository.dart';
import '../chats_list/presentation/screens/chats_screen.dart';
import '../favorites/presentation/matches_screen.dart';
import '../profile/presentation/pages/profile_page.dart';

class DashBoardCubit extends Cubit<DashboardState> {
  DashBoardCubit() : super(InitDashboardState());
  static DashBoardCubit get(context) => BlocProvider.of(context);
  int currentIndex = 2;
  List pages = [
    MatchesScreen(),
    ChatListScreen(),
    HomePage(),
    BlurNotification(),
    ProfilePage()
  ];

  changeIndex(index) {
    currentIndex = index;
    emit(SelectIndex());
  }
}
