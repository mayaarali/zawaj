import 'package:zawaj/features/profile/data/models/partner_model.dart';
import 'package:zawaj/features/profile/data/models/profile_model.dart';

class ProfileStates {}

class InitStates extends ProfileStates {}

class LoadingProfile extends ProfileStates {}

class LoadingPartner extends ProfileStates {}

class SuccessProfile extends ProfileStates {
  ProfileData profileData;
  SuccessProfile(this.profileData);
}

class SuccessPartner extends ProfileStates {
  PartnerData partnerList;
  SuccessPartner(this.partnerList);
}

class FailedProfile extends ProfileStates {
  String message;
  FailedProfile({required this.message});
}

class FailedPartner extends ProfileStates {
  String message;
  FailedPartner({required this.message});
}

class DeleteProfileLoading extends ProfileStates {}

class DeleteProfileSuccess extends ProfileStates {
  String message;
  DeleteProfileSuccess({required this.message});
}

class DeleteProfileFailed extends ProfileStates {
  String message;
  DeleteProfileFailed({required this.message});
}
