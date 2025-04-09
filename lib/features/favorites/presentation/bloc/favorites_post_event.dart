part of 'favorites_post_bloc.dart';

abstract class LikedPartnersEvent {}

class LikedPartners extends LikedPartnersEvent {}

class LoadMoreLikedPartners extends LikedPartnersEvent {}

class LoadLikedPartners extends LikedPartnersEvent {}

class LoadLikedPartnersEvent extends LikedPartnersEvent {
  final int page;
  final bool? isReset;

  LoadLikedPartnersEvent(this.page, {this.isReset = false});
}
