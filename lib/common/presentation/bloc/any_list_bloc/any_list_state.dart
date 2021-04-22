import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';

abstract class AnyListState extends AnyDetailState {
  final bool hasData;

  AnyListState(this.hasData);

  @override
  List<Object> get props => [];
}

class StartState extends AnyListState {
  StartState() : super(false);

  @override
  String toString() => 'StartState';
}

class AnyListLoading extends AnyListState {
  AnyListLoading(bool hasData) : super(hasData);

  @override
  String toString() => 'AnyListLoading';
}

class AnyListError extends AnyListState {
  final Failure error;

  AnyListError(this.error, bool hasData) : super(hasData);

  @override
  String toString() => 'AnyListError';
}

class AnyListDataFetched<Data, Search> extends AnyListState {
  final List<Data> data;
  final bool hasSingleData;
  final Data singleData;
  final bool isRetry;
  final Search search;

  AnyListDataFetched(this.data, this.hasSingleData, this.singleData, bool hasData, this.search, {this.isRetry = false})
      : super(hasData);

  @override
  String toString() => 'AnyListDataFetched with data: ${data.length}';

  @override
  List<Object> get props => [data, data.length, isRetry];
}

class AnyListEmpty extends AnyListState {
  AnyListEmpty() : super(false);

  @override
  String toString() => 'AnyListEmpty';
}
