import 'package:dartz/dartz.dart';
import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_fetch_bloc/any_fetch_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_fetch_bloc/any_fetch_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_fetch_bloc/any_fetch_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_intercepting_bloc/any_intercepting_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_intercepting_bloc/any_intercepting_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_list_bloc/any_list_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_list_bloc/any_list_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_list_bloc/any_list_state.dart';
import 'package:testing_ground/common/usecases/usecase.dart';
import 'package:testing_ground/test/usecases/fetch_num_of_pages_use_case.dart';
import 'package:testing_ground/test/usecases/fetch_page_use_case.dart';
import 'package:meta/meta.dart';

class TestBloc extends AnyBloc
    with AnyChangeableButtonBloc<String>, AnyListBloc<String, int>, AnyFetchBloc<int>, AnyInterceptingBloc  {
  TestBloc({
    @required this.getListUseCase,
    @required this.anyFetchUseCase,
  })  : assert(getListUseCase != null),
        assert(anyFetchUseCase != null),
        super(
            initialState: AnySummaryState(states: {
          AnyChangeableButtonBloc: InitialAnyChangeableButtonState(),
          AnyListBloc: StartState(),
          AnyFetchBloc: AnyFetchLoadingState(),
          AnyInterceptingBloc: AnyInterceptingDefaultState(),
        }));

  final FetchPageUseCase getListUseCase;
  final FetchNumOfPagesUseCase anyFetchUseCase;

  int pageSize = 1;

  int get lowerLimit => 1;

  int get upperLimit {
    final fetchState = state.ofType<AnyFetchBloc>();
    if (fetchState is AnyFetchDataState) {
      return fetchState.data as int;
    } else {
      return 1;
    }
  }

  Future<Either<Failure, String>> asyncAction(AnyChangeableButtonEvent event) async {
    await Future.delayed(Duration(seconds: 1));
    add(AnyListFetchNewPageEvent());
    return Right('');
  }

  @override
  Future<Either<Failure, int>> fetchData(AnyFetchEvent event) {
    return anyFetchUseCase(NoParams());
  }

  @override
  AnyDetailState stateIfDisallow(AnyEvent event) {
    if (event is AnyListFetchNewPageEvent) {
      if (upperLimit < numberOfLoadedPages + 1) {
        return AnyInterceptingTooMuchState();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
