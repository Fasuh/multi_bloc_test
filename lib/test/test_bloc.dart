import 'package:dartz/dartz.dart';
import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_fetch_bloc/any_fetch_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_fetch_bloc/any_fetch_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_fetch_bloc/any_fetch_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_intercepting_bloc/any_intercepting_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_intercepting_bloc/any_intercepting_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_list_bloc/any_list_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_list_bloc/any_list_event.dart';
import 'package:testing_ground/common/usecases/usecase.dart';

class TestBloc extends AnyBloc with
    AnyChangeableButtonBloc<String>,
    AnyListBloc<String, int>,
    AnyFetchBloc<int>,
    AnyInterceptingBloc {
  int pageSize = 1;

  @override
  UseCase<List<String>, ListParam<int>> get getListUseCase => throw UnimplementedError();
  @override
  UseCase<int, NoParams> get anyFetchUseCase => throw UnimplementedError();

  int get lowerLimit => 1;

  int get upperLimit {
    final fetchState = state.ofType<AnyFetchBloc>();
    if(fetchState is AnyFetchDataState) {
      return fetchState.data as int;
    } else {
      return 1;
    }
  }

  Future<Either<Failure, String>> asyncAction(AnyChangeableButtonEvent event) async {
    await Future.delayed(Duration(seconds: 1));
    add(AnyListFetchNewPageEvent());
  }

  @override
  Future<Either<Failure, int>> fetchData(AnyFetchEvent event) {
    return anyFetchUseCase(NoParams());
  }

  @override
  AnyDetailState stateIfDisallow(AnyEvent event) {
    if(state is AnyListFetchNewPageEvent) {
      if(upperLimit < numberOfLoadedPages+1) {
        return AnyInterceptingTooMuchState();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}