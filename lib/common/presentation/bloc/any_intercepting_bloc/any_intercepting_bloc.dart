import 'package:testing_ground/common/presentation/bloc/any_bloc/any_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_intercepting_bloc/any_intercepting_state.dart';
import 'package:meta/meta.dart';

mixin AnyInterceptingBloc<T> on AnyBloc {
  int get upperLimit;
  int get lowerLimit;

  AnyDetailState stateIfDisallow(AnyEvent event);

  AnyDetailState _ownState;

  Stream<AnyState> _setOwnState(AnyDetailState state) async* {
    _ownState = state;
    yield* dispatchState();
  }

  @mustCallSuper
  Map<Type, AnyDetailState> get states {
    return super.states..putIfAbsent(AnyInterceptingBloc, () => _ownState ??= AnyInterceptingDefaultState());
  }

  @override
  Stream<AnyState> mapEventToState(AnyEvent event) async* {
    final state = stateIfDisallow(event);
    if(state == null) {
      yield* _setOwnState(AnyInterceptingDefaultState());
      yield* super.mapEventToState(event);
    } else {
      yield* _setOwnState(state);
    }
  }
}