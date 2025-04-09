part of 'favorites_post_bloc.dart';

abstract class LikedPartnersStates {}

class LikedPartnersInitial extends LikedPartnersStates {}

class LikedPartnersLoading extends LikedPartnersStates {}
class LikedPartnersNoMoreData extends LikedPartnersStates {}

class LikedPartnersSuccess extends LikedPartnersStates {
  final List<HomeModel> homeModel;

  LikedPartnersSuccess(this.homeModel);
}

class LikedPartnersFailed extends LikedPartnersStates {
  final String message;

  LikedPartnersFailed({required this.message});
}

class LoadMoreLikedPartnersSuccess extends LikedPartnersStates {
  final List<HomeModel> homeModel;

  LoadMoreLikedPartnersSuccess(this.homeModel);
}

class LoadMoreLikedPartnersFailed extends LikedPartnersStates {
  final String message;

  LoadMoreLikedPartnersFailed({required this.message});
}
