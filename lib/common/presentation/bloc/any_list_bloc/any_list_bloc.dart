import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fimber/fimber.dart';
import 'package:meta/meta.dart';
import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_list_bloc/any_list_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_list_bloc/any_list_state.dart';
import 'package:testing_ground/common/usecases/usecase.dart';

mixin AnyListBloc<Data, Search> on AnyBloc {
  List<Data> loadedItems = [];
  Search search;
  List appendedItems = [];
  int firstPageNum = 1;
  int numberOfLoadedPages = 0;
  bool hasMoreItems = true;
  Object error;
  bool isFetching = false;
  int pageSize = 20;
  bool isRetrying = false;
  Timer _debounce;

  UseCase<List<Data>, ListParam<Search>> get getListUseCase;

  bool get noItemsFound => this.loadedItems.length == 0 && this.hasMoreItems == false;
  final Duration searchDebounceTime = Duration(milliseconds: 500);

  Future<Either<Failure, List<Data>>> fetchForPage(int page, Search search) {
    return getListUseCase(ListParam<Search>(page: page, search: search));
  }

  Stream<AnyState> _setOwnState(AnyDetailState state) async* {
    _ownState = state;
    yield* dispatchState();
  }

  AnyDetailState _ownState;

  @mustCallSuper
  Map<Type, AnyDetailState> get states {
    return super.states..putIfAbsent(AnyListBloc, () => _ownState ??= StartState());
  }

  @override
  Stream<AnyState> mapEventToState(AnyEvent event) async* {
    if (event is AnyListRefreshEvent) {
      final emptyList = loadedItems.isNotEmpty;
      reset();
      _ownState = AnyListLoading(emptyList);
      yield* dispatchState();
      yield* _mapShopsFetchNextPageState(false);
    } else if (event is AnyListFetchNewPageEvent) {
      yield* _mapShopsFetchNextPageState(false);
    } else if (event is AnyListRetryEvent) {
      yield* _mapShopsFetchNextPageState(true);
    } else if (event is AnyListSearchEvent) {
      mapAnyListSearchEvent(event);
    } else if (event is CleanAnyListEvent) {
      reset();
      _ownState = AnyListEmpty();
      yield* dispatchState();
    } else {
      yield* super.mapEventToState(event);
    }
  }

  Stream<AnyState> _mapShopsFetchNextPageState(bool isRetry) async* {
    numberOfLoadedPages ??= firstPageNum;
    if (!this.isFetching && this.hasMoreItems) {
      this.isFetching = true;
      isRetrying = isRetry;
      if (isRetrying) {
        error = null;
        hasMoreItems = true;
        yield* _setOwnState(AnyListDataFetched(this.loadedItems, false, null, loadedItems.isNotEmpty, search, isRetry: isRetry));
        isRetrying = !isRetry;
      }
      List<Data> page;
      final result = await fetchForPage(numberOfLoadedPages, search);
      yield* result.fold((error) async* {
        this.error = error;
        this.isFetching = false;
        yield* _setOwnState(AnyListError(error, loadedItems.isNotEmpty));
      }, (data) async* {
        Fimber.d('PREFETCH !@!@!');
        page = data;
        Fimber.d("ANY LIST LOGIC: page size = ${page.length}");
        this.numberOfLoadedPages++;
      });

      // Get length accounting for possible null Future return. We'l treat a null Future as an empty return
      final int length = (page?.length ?? 0);

      if (length > this.pageSize) {
        this.isFetching = false;
        throw ('Page length ($length) is greater than the maximum size (${this.pageSize})');
      }

      if (length > 0 && length < this.pageSize) {
        // This should only happen when loading the last page.
        // In that case, we append the last page with a few items to make its size
        // similar to normal pages. This is useful especially with GridView,
        // because we want the loading to show on a new line on its own
        this.appendedItems = List.generate(this.pageSize - length, (_) => {});
      }

      if (length == 0) {
        this.hasMoreItems = false;
      } else {
        if (length < pageSize) {
          this.hasMoreItems = false;
        }
        this.loadedItems.addAll(page);
        Fimber.d("ANY LIST LOGIC: loaded data size - ${this.loadedItems.length}");
      }
      this.isFetching = false;
      if (this.loadedItems.isNotEmpty) {
        _ownState = AnyListDataFetched(
            List.from(this.loadedItems, growable: false), false, null, loadedItems.isNotEmpty, search);
        yield* dispatchState();
      } else {
        if (error == null) {
          _ownState = AnyListEmpty();
          yield* dispatchState();
        }
      }
    }
  }

  @mustCallSuper
  void mapAnyListSearchEvent(AnyListSearchEvent event) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(searchDebounceTime, () {
      this.search = event.search;
      add(AnyListRefreshEvent());
    });
  }

  @mustCallSuper
  @override
  close() {
    _debounce?.cancel();
    return super.close();
  }

  void reset() {
    this.appendedItems = [];
    this.loadedItems = [];
    this.numberOfLoadedPages = firstPageNum;
    this.hasMoreItems = true;
    this.error = null;
    this.isFetching = false;
  }
}
