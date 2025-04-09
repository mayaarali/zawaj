import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/single_child_widget.dart';
import 'package:zawaj/core/blocs/language/language_cubit.dart';
import 'package:zawaj/core/camera/bloc/camera_bloc.dart';
import 'package:zawaj/core/camera/utlis/camera_utils.dart';
import 'package:zawaj/core/camera/utlis/permission_utils.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/chat/data/data_source/chat_messages_dataSource.dart';
import 'package:zawaj/features/chat/data/repos/chat_message_repository.dart';
import 'package:zawaj/features/chat/domain/get_chat_messages_usecase.dart';
import 'package:zawaj/features/chat/presentation/chat_message_cubit/chat_messages_cubit.dart';
import 'package:zawaj/features/chats_list/data/repository/repository_impl.dart';
import 'package:zawaj/features/chats_list/domain/reposiory/repository.dart';
import 'package:zawaj/features/chats_list/presentation/cubit/get_chats_cubit.dart';
import 'package:zawaj/features/chats_list/presentation/widgets/chats_list_widget.dart';
import 'package:zawaj/features/dashboard/cubit.dart';
import 'package:zawaj/features/notification/presentation/allNotificationBloc/all_notification_bloc.dart';
import 'package:zawaj/features/notification/presentation/whoLikedMe_bloc/who_like_me_bloc.dart';
import 'package:zawaj/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/presentation/bloc/app_report_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/presentation/bloc/consultant_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/settings/presentation/cubit/cubit.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/presentation/bloc/verify_bloc.dart';
import 'package:zawaj/features/removed_users/data/datasSource/removed_users_reomte_datasource.dart';
import 'package:zawaj/features/removed_users/data/repositories/removed_users_repository_impl.dart';
import 'package:zawaj/features/removed_users/domain/useCases/fetch_removed_users_usecase.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/area_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/city_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/params_bloc.dart';
import 'package:zawaj/features/favorites/presentation/bloc/favorites_post_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_report/presentation/bloc/send_report_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';
import 'package:zawaj/injection_controller.dart' as di;

import '../../features/home/presentation/blocs/home_bloc/home_bloc.dart';
import '../../features/home/presentation/blocs/likedPost_bloc/liked_post_bloc.dart';
import '../../features/removed_users/presentation/cubit/removed_user_cubit.dart';

class AppProviders {
  static List<SingleChildWidget> get(context) {
    return [
      // BlocProvider(
      //     create: (context) => UserCubit(FetchUsersUseCase(
      //         UserRepositoryImpl(RemovedUsersRemoteDataSource(Dio()))))),

      // BlocProvider(
      //     create: (context) =>
      //         ChatsCubit(GetChats(ChatRepository(Dio())))..fetchChats()),
      BlocProvider(
          create: (context) => ChatMessagesCubit(GetChatMessagesDataUseCase(
              ChatMessagesRepositoryImpl(ChatDataProvider())))),
      BlocProvider(create: (_) => LanguageCubit()),
      BlocProvider(create: (_) => DashBoardCubit()),
      BlocProvider(create: (_) => di.sl<AuthBloc>()),
      BlocProvider(create: (_) => di.sl<SetUpBloc>()),
      BlocProvider(
          create: (context) => di.sl<ParamsBloc>()..getParams(context)),
      BlocProvider(create: (_) => di.sl<CityBloc>()..getCity()),
      BlocProvider(create: (_) => di.sl<AreaBloc>()),
      BlocProvider(
          create: (_) => di.sl<ProfileBloc>()
            ..getMyProfile()
            ..getMyPartner()),
      BlocProvider(
          create: (_) => di.sl<ProfileBloc>()
            ..getMyProfile()
            ..getMyPartner()),
      BlocProvider(create: (_) => di.sl<SendReportBloc>()),
      BlocProvider(create: (_) => di.sl<PaymentBloc>()),
      BlocProvider(create: (_) => di.sl<AppReportBloc>()),
      BlocProvider(create: (_) => di.sl<HomeBloc>()),
      BlocProvider(create: (_) => di.sl<LikedPostBloc>()),
      BlocProvider(create: (_) => di.sl<LikedPartnersBloc>()),
      BlocProvider(create: (_) => di.sl<WhoLikeMeBloc>()),
      BlocProvider(create: (_) => di.sl<VerifyBloc>()),
      BlocProvider(create: (_) => di.sl<ConsultantBloc>()),
      BlocProvider(create: (_) => di.sl<AllNotificationBloc>()),

      BlocProvider(create: (_) => di.sl<NotificationsToggleCubit>()),
      BlocProvider(
          create: (_) => CameraBloc(
              cameraUtils: CameraUtils(), permissionUtils: PermissionUtils())
            ..add(const CameraInitialize(recordingLimit: 15))),
    ];
  }
}
