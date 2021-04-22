
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_state.dart';

mixin AnyChangeableButtonManager<T> {
  Map<T, AnyChangeableButtonBloc> _blocTypes = {};

  bool get _isNotWorkingAlready => !_blocTypes.values.any((bloc) => bloc.state is! InitialAnyChangeableButtonState);

  void addEventForBloc(AnyChangeableButtonEvent event, T type) async {
    if (_isNotWorkingAlready) {
      // ignore: close_sinks
      final bloc = getBlocForMethod(type);
      bloc.add(event);
    }
  }

  void resetAnyChangeableButton(T type) {
    // ignore: close_sinks
    final bloc = getBlocForMethod(type);
    bloc.add(ResetChangeableButtonEvent());
  }

  AnyChangeableButtonBloc getBlocForMethod(T type) => _blocTypes.putIfAbsent(type, () => _addBloc(type));

  AnyChangeableButtonBloc blocGenerator(T type);

  AnyChangeableButtonBloc _addBloc(T type) {
    final bloc = blocGenerator(type);
    if (bloc != null) {
      return bloc;
    } else {
      throw Exception('Unrecognized method.');
    }
  }
}
