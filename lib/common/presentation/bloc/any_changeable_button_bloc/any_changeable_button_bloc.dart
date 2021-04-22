import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_state.dart';

mixin AnyChangeableButtonBloc<T> on AnyBloc {
  ProgressAnyChangeableButtonState progress() => ProgressAnyChangeableButtonState();

  SuccessAnyChangeableButtonState success(T data) => SuccessAnyChangeableButtonState<T>(value: data);

  ErrorAnyChangeableButtonState failure(Failure error) => ErrorAnyChangeableButtonState(error);

  InitialAnyChangeableButtonState initial() => InitialAnyChangeableButtonState();

  Stream<AnyState> _progress() async* {
    _ownState = progress();
    yield* dispatchState();
  }

  Stream<AnyState> _success(T data) async* {
    _ownState = success(data);
    yield* dispatchState();
  }

  Stream<AnyState> _failure(Failure error) async* {
    _ownState = failure(error);
    yield* dispatchState();
  }

  Stream<AnyState> _initial() async* {
    _ownState = initial();
    yield* dispatchState();
  }

  AnyDetailState _ownState;

  @mustCallSuper
  Map<Type, AnyDetailState> get states {
    return super.states..putIfAbsent(AnyChangeableButtonBloc, () => _ownState ??= initial());
  }

  @override
  Stream<AnyState> mapEventToState(
    AnyEvent event,
  ) async* {
    if (event is DefaultAnyChangeableButtonEvent) {
      yield* _mapAsyncAction(event);
    } else if (event is CustomAnyChangeableEvent) {
      yield* customEventHandler(event);
    } else if (event is ResetChangeableButtonEvent) {
      yield* _initial();
    } else {
      yield* super.mapEventToState(event);
    }
  }

  Stream<AnyState> _mapAsyncAction(DefaultAnyChangeableButtonEvent event) async* {
    yield* _progress();
    final result = await asyncAction(event);
    yield* result.fold((error) async* {
      yield* _failure(error);
    }, (r) async* {
      yield* _success(r);
    });
  }

  @mustCallSuper
  Stream<AnyState> customEventHandler(CustomAnyChangeableEvent event) {
    throw UnimplementedError('this event is not implemented');
  }

  Future<Either<Failure, T>> asyncAction(AnyChangeableButtonEvent event) {
    throw UnimplementedError();
  }
}
