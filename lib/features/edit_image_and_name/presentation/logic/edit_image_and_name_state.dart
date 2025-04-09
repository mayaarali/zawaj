part of 'edit_image_and_name_cubit.dart';

abstract class EditImageAndNameState extends Equatable {
  const EditImageAndNameState();

  @override
  List<Object> get props => [];
}

class EditImageAndNameInitial extends EditImageAndNameState {}

class EditImageAndNameLoading extends EditImageAndNameState {}

class EditImageAndNameUpdated extends EditImageAndNameState {}

class EditImageAndNameError extends EditImageAndNameState {
  final String message;

  const EditImageAndNameError(this.message);

  @override
  List<Object> get props => [message];
}

class EditImageAndNameImageAdded extends EditImageAndNameState {
  final XFile image;

  const EditImageAndNameImageAdded(this.image);

  @override
  List<Object> get props => [image];
}

class EditImageAndNameImageReplaced extends EditImageAndNameState {
  final int index;
  final XFile image;

  const EditImageAndNameImageReplaced(this.index, this.image);

  @override
  List<Object> get props => [index, image];
}
