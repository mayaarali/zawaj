import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_impression/data/model/model.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_impression/domin/repository.dart';

class AppFeedbackCubit extends Cubit<FeedbackState> {
  final AppFeedbackRepositoryImpl repository;
  bool isLoading = false;

  AppFeedbackCubit(this.repository) : super(FeedbackInitial());

  void sendFeedback(AppFeedback feedback) async {
    isLoading = true;
    emit(FeedbackLoading());
    try {
      await repository.sendFeedback(feedback);
      isLoading = false;
      emit(FeedbackSent());
    } catch (e) {
      isLoading = false;

      emit(FeedbackError(message: ' فشل ! حاول مرة اخرى '));
    }
  }
}

abstract class FeedbackEvent {}

class SendFeedback extends FeedbackEvent {
  final AppFeedback feedback;

  SendFeedback({required this.feedback});
}

abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackSent extends FeedbackState {}

class FeedbackError extends FeedbackState {
  final String message;

  FeedbackError({required this.message});
}
