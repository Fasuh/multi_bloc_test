import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';
import 'package:meta/meta.dart';

abstract class AnyBloc extends Bloc<AnyEvent, AnyState> {
  AnyBloc({@required AnyState initialState})
      : assert(initialState != null),
        super(initialState);

  @override
  @mustCallSuper
  Stream<AnyState> mapEventToState(
    AnyEvent event,
  ) async* {
    throw UnimplementedError();
  }

  @mustCallSuper
  Map<Type, AnyDetailState> get states {
    return {};
  }

  @mustCallSuper
  Stream<AnyState> dispatchState() async* {
    yield AnySummaryState(states: Map.unmodifiable(states));
  }
}
