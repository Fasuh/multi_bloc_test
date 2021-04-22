import 'package:dartz/dartz.dart';
import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_fetch_bloc/any_fetch_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_fetch_bloc/any_fetch_state.dart';
import 'package:testing_ground/common/usecases/usecase.dart';
import 'package:meta/meta.dart';

mixin AnyFetchBloc<Data> on AnyBloc {
  UseCase<Data, dynamic> get anyFetchUseCase;

  AnyDetailState _ownState;

  Stream<AnyState> _setOwnState(AnyDetailState state) async* {
    _ownState = state;
    yield* dispatchState();
  }

  @mustCallSuper
  Map<Type, AnyDetailState> get states {
    return super.states..putIfAbsent(AnyFetchBloc, () => _ownState ??= AnyFetchLoadingState());
  }

  @override
  Stream<AnyState> mapEventToState(AnyEvent event) async* {
    if (event is AnyFetchEvent) {
      yield* _mapAnyFetchEvent(event);
    } else {
      yield* super.mapEventToState(event);
    }
  }

  Stream<AnyState> _mapAnyFetchEvent(AnyFetchEvent event) async* {
    yield* _setOwnState(AnyFetchLoadingState());
    final result = await fetchData(event);
    yield* result.fold((error) async* {
      yield* _setOwnState(AnyFetchErrorState(error: error));
    }, (data) async* {
      yield* _setOwnState(AnyFetchDataState(data: data));
    });
  }

  Future<Either<Failure, Data>> fetchData(AnyFetchEvent event);
}