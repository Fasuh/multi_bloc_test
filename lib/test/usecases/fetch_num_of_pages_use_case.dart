import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/usecases/usecase.dart';

class FetchNumOfPagesUseCase extends UseCase<int, NoParams> {
  FetchNumOfPagesUseCase({@required this.repository}) : assert(repository != null);

  final int repository;

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return Future.value(Right(repository));
  }
}