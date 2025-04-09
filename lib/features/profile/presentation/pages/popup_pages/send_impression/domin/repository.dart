import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_impression/data/model/model.dart';

abstract class AppFeedbackRepositoryImpl {
  Future<void> sendFeedback(AppFeedback feedback);
}
