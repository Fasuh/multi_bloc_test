import 'package:equatable/equatable.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_bloc.dart';
import 'package:meta/meta.dart';

abstract class AnyState extends Equatable {
  Map<Type, AnyDetailState> get states;

  AnyDetailState ofType<T extends AnyBloc>() {
    return states.entries.lastWhere((element) => element.key == T).value;
  }

  @override
  List<Object> get props => [states];
}

class AnySummaryState extends AnyState {
  final Map<Type, AnyDetailState> states;

  AnySummaryState({@required this.states}) : assert(states != null);
}

abstract class AnyDetailState extends Equatable {
  @override
  List<Object> get props => [];
}
