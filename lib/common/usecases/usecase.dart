import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class ListParam<T> extends Equatable {
  final int page;
  final T search;

  ListParam({
    @required this.page,
    @required this.search,
  })  : assert(page != null);

  @override
  List<Object> get props => [page, search];
}

class IdParam extends Equatable {
  final String id;

  IdParam({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

@immutable
class DateParam extends Equatable {
  final DateTime date;

  DateParam({@required this.date}) : assert(date != null);

  @override
  List<Object> get props => [date];
}

@immutable
class DateRangeParam extends Equatable {
  final DateTime from;
  final DateTime to;

  DateRangeParam({
    @required this.from,
    @required this.to,
  })  : assert(from != null),
        assert(to != null);

  @override
  List<Object> get props => [from, to];
}
