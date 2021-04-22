import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:testing_ground/common/error/failures.dart';
import 'package:testing_ground/common/usecases/usecase.dart';

class FetchPageUseCase extends UseCase<String, ListParam> {
  FetchPageUseCase({@required this.repository}) : assert(repository != null);

  final  repository;

  @override
  Future<Either<Failure, String>> call(ListParam params) {
    return Future.value(Right(''));
  }
}