import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_ground/common/app/colors.dart';
import 'package:testing_ground/common/app/dimens.dart';
import 'package:testing_ground/common/app/duration.dart';
import 'package:testing_ground/common/presentation/bloc/any_bloc/any_state.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_bloc.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_event.dart';
import 'package:testing_ground/common/presentation/bloc/any_changeable_button_bloc/any_changeable_button_state.dart';
import 'package:testing_ground/common/presentation/widget/notification.dart';

import 'changeable_button.dart';

enum AnyChangeableButtonResult { success, error }

class AnyChangeableButton<T> extends StatefulWidget {
  final Widget button;
  final AnyChangeableButtonBloc<T> bloc;
  final Function onTap;
  final Color defaultColor;
  final Function(AnyChangeableButtonResult, T data) onAnimFinish;
  final Widget progress;
  final Widget error;
  final Widget success;
  final double height;
  final bool isActive;

  const AnyChangeableButton({
    Key key,
    @required this.button,
    @required this.bloc,
    this.onTap,
    this.defaultColor = primaryColor,
    this.height = buttonHeight,
    this.onAnimFinish,
    this.progress,
    this.isActive = true,
    this.error,
    this.success,
  })  : assert(button != null),
        assert(bloc != null),
        assert(isActive != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _AnyChangeableButtonState<T>();
}

class _AnyChangeableButtonState<T> extends State<AnyChangeableButton<T>> {
  @override
  Widget build(BuildContext context) => BlocConsumer(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is ErrorAnyChangeableButtonState) {
          notification(description: state.failure.errorMessage);
        }
      },
      builder: (context, state) {
        return ChangeAbleButton(
          button: widget.button,
          defaultColor: widget.defaultColor,
          success: widget.success,
          error: widget.error,
          progress: widget.progress,
          onTap: widget.isActive ? widget.onTap ?? () => widget.bloc.add(DefaultAnyChangeableButtonEvent()) : null,
          onAnimFinish: () {
            widget.bloc.add(ResetChangeableButtonEvent());
            widget.onAnimFinish?.call(getResultForState(state), getDataIfSuccess(state));
          },
          duration: ms300Duration,
          state: anyChangeableButtonState(state),
          height: widget.height,
        );
      });

  AnyChangeableButtonResult getResultForState(AnyState state) {
    final buttonState = state.ofType<AnyChangeableButtonBloc>();
    if (buttonState is SuccessAnyChangeableButtonState) {
      return AnyChangeableButtonResult.success;
    } else {
      return AnyChangeableButtonResult.error;
    }
  }

  T getDataIfSuccess(AnyState state) {
    final buttonState = state.ofType<AnyChangeableButtonBloc>();
    if (buttonState is SuccessAnyChangeableButtonState) {
      return buttonState.value;
    } else {
      return null;
    }
  }
}

AnimatedButtonStates anyChangeableButtonState(AnyState state) {
  final buttonState = state.ofType<AnyChangeableButtonBloc>();
  if (buttonState is SuccessAnyChangeableButtonState) {
    return AnimatedButtonStates.success;
  } else if (buttonState is InitialAnyChangeableButtonState) {
    return AnimatedButtonStates.button;
  } else if (buttonState is ProgressAnyChangeableButtonState) {
    return AnimatedButtonStates.progress;
  } else if (buttonState is ErrorAnyChangeableButtonState) {
    return AnimatedButtonStates.error;
  } else {
    return AnimatedButtonStates.button;
  }
}

class ErrorChangeableButton extends StatelessWidget {
  final double size;

  const ErrorChangeableButton({Key key, this.size = 68}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: Icon(
        Icons.close,
        color: Colors.white,
        size: size / 2,
      ),
    );
  }
}

class ProgressChangeableButton extends StatelessWidget {
  final double size;

  const ProgressChangeableButton({Key key, this.size = 68}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.all(12.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 3.0,
      ),
    );
  }
}

class SuccessChangeableButton extends StatelessWidget {
  final double size;

  const SuccessChangeableButton({Key key, this.size = 68}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 30.0,
      ),
    );
  }
}
