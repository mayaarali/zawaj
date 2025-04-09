import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/profile/data/models/partner_model.dart';
import 'package:zawaj/features/profile/data/models/profile_model.dart';
import '../../data/repository/profile_repository.dart';
import 'events.dart';
import 'states.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileStates> {
  ProfileRepositoryImp profileRepositoryImp;

  static ProfileBloc get(context) => BlocProvider.of(context);

  ProfileBloc({required this.profileRepositoryImp}) : super(InitStates());

  ProfileData? profileData;
  getMyProfile() async {
    emit(LoadingProfile());
    var response = await profileRepositoryImp.getProfile();
    response.fold((failure) {
      emit(FailedProfile(message: failure));
    }, (message) {
      profileData = message;
      emit(SuccessProfile(message));
    });
  }

  PartnerData? partnerData;
  getMyPartner() async {
    emit(LoadingPartner());
    var response = await profileRepositoryImp.getPartnerProfile();
    response.fold((failure) {
      emit(FailedPartner(message: failure));
    }, (message) {
      partnerData = message;

      emit(SuccessPartner(message));
    });
  }

  deleteMyProfile() async {
    emit(DeleteProfileLoading());
    var response = await profileRepositoryImp.deleteProfile();
    response.fold((failure) {
      emit(DeleteProfileFailed(message: failure));
    }, (message) {
      emit(DeleteProfileSuccess(message: message));
    });
  }
}
