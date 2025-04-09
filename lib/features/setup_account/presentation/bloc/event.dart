import '../../data/models/setup_required_body.dart';

abstract class SetUpEvent {}

class ParamsEvent extends SetUpEvent {}

class PostSetUpEvent extends SetUpEvent {}

class UpdateSetUpEvent extends SetUpEvent {}

class PostSetUpRequiredEvent extends SetUpEvent {
  SetupRequiredBody setupRequiredBody;

  PostSetUpRequiredEvent(this.setupRequiredBody);
}

class UpdatePertnerEvent extends SetUpEvent {
  SetupRequiredBody setupRequiredBody;
  UpdatePertnerEvent({required this.setupRequiredBody});
}

class PostRequiredSetUpEvent extends SetUpEvent {}

class CityEvent extends SetUpEvent {}

class AreaEvent extends SetUpEvent {
  int cityId;
  AreaEvent({required this.cityId});
}
