import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';
import 'package:meta/meta.dart';

class AnyFetchLoadingState extends AnyDetailState {}

class AnyFetchDataState<T> extends AnyDetailState {
  final T data;

  AnyFetchDataState({@required this.data}) : assert(data != null);

  @override
  List<Object> get props => [data];
}

class AnyFetchErrorState extends AnyDetailState {
  final Failure error;

  AnyFetchErrorState({@required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}
