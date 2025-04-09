import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:zawaj/features/favorites/data/data_source/favorites_datasource.dart';
import 'package:zawaj/features/favorites/data/repository/favorites_repo.dart';
import 'package:zawaj/features/favorites/presentation/bloc/favorites_post_bloc.dart';
import 'package:zawaj/features/home/data/data_source/home_datascource.dart';
import 'package:zawaj/features/home/data/repository/home_repo.dart';
import 'package:zawaj/features/notification/data/data_source/whoLikedMe_datasource.dart';
import 'package:zawaj/features/notification/data/repository/whoLike_repo.dart';
import 'package:zawaj/features/notification/presentation/allNotificationBloc/all_notification_bloc.dart';
import 'package:zawaj/features/notification/presentation/whoLikedMe_bloc/who_like_me_bloc.dart';
import 'package:zawaj/features/payment/data/dataScource/payment_datascource.dart';
import 'package:zawaj/features/payment/data/repos/payment_repository.dart';
import 'package:zawaj/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/data/dataSorce/appReprt_dataSorce.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/data/repos/appReport_repository.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/presentation/bloc/app_report_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/data/data%20source/consultant_dataSource.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/data/repo/consultant_repository.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/presentation/bloc/consultant_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_report/data/data_source/send_report_datascource.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_report/data/repos/send_report_repo.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_report/presentation/bloc/send_report_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/data/repos/verify_repositiry.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/data/verify_data_source/veify_data_source.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/presentation/bloc/verify_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/area_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/city_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/params_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';

import 'core/helper/cache_helper.dart';
import 'core/helper/dio_helper.dart';
import 'core/network/network_info.dart';
import 'core/network/network_info_imp.dart';
import 'features/authentication/data/data_source/auth_datasource_imp.dart';
import 'features/authentication/data/repository/auth_repository_imp.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'features/home/presentation/blocs/likedPost_bloc/liked_post_bloc.dart';
import 'features/profile/data/data_source/profile_datasource.dart';
import 'features/profile/data/repository/profile_repository.dart';
import 'features/profile/presentation/pages/popup_pages/settings/presentation/cubit/cubit.dart';
import 'features/setup_account/data/data_source/setup_datasource.dart';
import 'features/setup_account/data/repository/setup_repository.dart';

final sl = GetIt.instance;

init() {
  ///===============================[ Blocs ]===============================\\\

  sl.registerFactory(() => NotificationsToggleCubit());
  sl.registerFactory(() => AuthBloc(authRepositoryImp: sl()));
  sl.registerFactory(() => SetUpBloc(setupRepositoryImp: sl()));
  sl.registerFactory(() => ParamsBloc(setupRepositoryImp: sl()));
  sl.registerFactory(() => CityBloc(setupRepositoryImp: sl()));
  sl.registerFactory(() => AreaBloc(setupRepositoryImp: sl()));
  sl.registerFactory(() => ProfileBloc(profileRepositoryImp: sl()));

  sl.registerFactory(() => SendReportBloc(sendReportRepositortyImp: sl()));
  sl.registerFactory(() => AppReportBloc(appReportRepositortyImp: sl()));
  sl.registerFactory(() => HomeBloc(homeRepositoryImp: sl()));
  sl.registerFactory(() => LikedPostBloc(homeRepositoryImp: sl()));
  sl.registerFactory(() => LikedPartnersBloc(likedPartnersRepositoryImp: sl()));
  sl.registerFactory(() => WhoLikeMeBloc(whoLikedMeRepositoryImp: sl()));
  sl.registerFactory(() => AllNotificationBloc(whoLikedMeRepositoryImp: sl()));

  sl.registerFactory(() => VerifyBloc(verifyRepositortyImp: sl()));
  sl.registerFactory(() => PaymentBloc(paymentRepositoryImp: sl()));
  sl.registerFactory(() => ConsultantBloc(consultantRepositoryImp: sl()));

  ///===============================[ Repositories ]===============================\\\
  sl.registerLazySingleton(
      () => AuthRepositoryImp(authDataSourceImp: sl(), networkInfo: sl()));
  sl.registerLazySingleton(
      () => SetUpRepositoryImp(setupDataSourceImp: sl(), networkInfo: sl()));

  sl.registerLazySingleton(() =>
      ProfileRepositoryImp(profileDataSourceImp: sl(), networkInfo: sl()));
  sl.registerLazySingleton(() => SendReportRepositortyImp(
      sendRerportDataSourceImp: sl(), networkInfo: sl()));
  sl.registerLazySingleton(
      () => HomeRepositoryImp(homeDataSourceImp: sl(), networkInfo: sl()));
  sl.registerLazySingleton(() => LikedPartnersRepositoryImp(
      likedPartnersDataSourceImp: sl(), networkInfo: sl()));

  sl.registerLazySingleton(() => AppReportRepositortyImp(
      appRerportDataSourceImp: sl(), networkInfo: sl()));
  sl.registerLazySingleton(() => WhoLikedMeRepositoryImp(
      whoLikedMeDataSourceImp: sl(), networkInfo: sl()));
  sl.registerLazySingleton(
      () => VerifyRepositortyImp(verifyDataSourceImp: sl(), networkInfo: sl()));
  sl.registerLazySingleton(() =>
      PaymentRepositoryImp(paymentDataScourceImp: sl(), networkInfo: sl()));
  sl.registerLazySingleton(() =>
      ConsultantRepositoryImp(consultantDatasource: sl(), networkInfo: sl()));

  ///===============================[ DataSource ]===============================\\\
  sl.registerLazySingleton(() => AuthDataSourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(() => SetupDataSourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(() => ProfileDataSourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(
      () => SendRerportDataSourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(
      () => AppRerportDataSourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(() => HomeDataSourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(
      () => LikedPartnersDataSourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(
      () => WhoLikedMeDataSourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(() => VerifyDataSourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(() => PaymentDataScourceImp(apiClientHelper: sl()));
  sl.registerLazySingleton(() => ConsultantDatasource(apiClientHelper: sl()));

  ///===============================[ Global Usage ]===============================\\\
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => DioHelper());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImp(internetConnectionChecker: sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
