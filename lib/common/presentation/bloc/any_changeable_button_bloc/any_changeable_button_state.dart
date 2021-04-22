import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';

class InitialAnyChangeableButtonState extends AnyDetailState {}

class ProgressAnyChangeableButtonState extends AnyDetailState {}

class SuccessAnyChangeableButtonState<T> extends AnyDetailState {
  final T value;

  SuccessAnyChangeableButtonState({this.value});

  @override
  List<Object> get props => [value];
}

class ErrorAnyChangeableButtonState extends AnyDetailState {
  final Failure failure;

  ErrorAnyChangeableButtonState(this.failure);
}
