import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/usecases/usecase.dart';

class FetchPageUseCase extends UseCase<List<String>, ListParam<int>> {
  FetchPageUseCase({@required this.repository}) : assert(repository != null);

  final List<String> repository;

  @override
  Future<Either<Failure, List<String>>> call(ListParam params) {
    return Future.value(Right(repository));
  }
}