import 'package:testing_ground/common/presentation/bloc/any_bloc/any_event.dart';

abstract class AnyChangeableButtonEvent extends AnyEvent {
  @override
  List<Object> get props => [];
}

class DefaultAnyChangeableButtonEvent extends AnyChangeableButtonEvent {}

class CustomAnyChangeableEvent extends AnyChangeableButtonEvent {}

class ResetChangeableButtonEvent extends AnyChangeableButtonEvent {}
