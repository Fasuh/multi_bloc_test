import 'package:flutter/material.dart';
import 'package:testing_ground/common/app/colors.dart';
import 'package:testing_ground/common/app/text_styles.dart';
import 'package:testing_ground/common/presentation/widget/any_changeable_button/full_width_button.dart';

enum AnimatedButtonStates { progress, error, success, button }

class ChangeAbleButton extends StatefulWidget {
  final Function onTap;
  final Function onAnimFinish;
  final Widget progress;
  final Widget error;
  final Widget success;
  final Widget button;
  final Duration duration;
  final AnimatedButtonStates state;
  final Color defaultColor;
  final double height;

  const ChangeAbleButton(
      {Key key,
        @required this.onTap,
        this.progress,
        this.error,
        @required this.height,
        this.success,
        @required this.button,
        @required this.state,
        @required this.duration,
        this.defaultColor,
        @required this.onAnimFinish})
      : super(key: key);

  @override
  _ChangeAbleButtonState createState() => _ChangeAbleButtonState();

  static Widget defaultButton(String text, {TextStyle style}) {
    return Container(
        padding: EdgeInsets.only(left: 6.0),
        child: Text(
          text,
          style: roboto.s18.bold.colorWhite,
        ));
  }

  static Widget buttonWithIcon(Widget icon, String text, {TextStyle style}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(padding: EdgeInsets.only(right: 6.0), child: icon),
        Container(
            padding: EdgeInsets.only(left: 6.0),
            child: Text(
              text,
              style: style ?? roboto.s18.bold.colorWhite,
            ))
      ],
    );
  }
}

class _ChangeAbleButtonState extends State<ChangeAbleButton> with SingleTickerProviderStateMixin {
  Duration _duration;
  Widget _progress;
  Widget _error;
  Widget _success;
  Widget _button;
  AnimatedButtonStates _state;
  AnimationController _animationController;
  Color _defaultColor;

  Animation _buttonSize;
  Animation _buttonColor;
  Animation _textOpacity;
  Animation _progressOpacity;
  Animation _errorIconOpacity;
  Animation _checkIconOpacity;
  double width;
  Tween buttonToCircle;
  Tween buttonToRectangle;
  Tween buttonCircle;
  double measuredButtonWidth;
  double measuredButtonHeight;
  AnimationStatusListener _statusListener;
  GlobalKey _buttonKey = GlobalKey();
  GlobalKey _parentKey = GlobalKey();

  @override
  void initState() {
    _progress = widget.progress ??
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        );

    _error = widget.error ??
        Icon(
          Icons.clear,
          color: Colors.white,
        );
    _success = widget.success ??
        Icon(
          Icons.check,
          color: Colors.white,
        );
    _button = widget.button;
    _defaultColor = widget.defaultColor ?? primaryColor;
    _duration = widget.duration;
    prepareAnimationController();
    _statusListener = (status) => onAnimationStatusChange(status);
    _animationController.addStatusListener(_statusListener);
    _state = widget.state;
    changeAnimAndPlay(_state, null);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    final RenderBox parent = _parentKey.currentContext.findRenderObject();
    measuredButtonWidth = parent.size.width;
    measuredButtonHeight = widget.height;

    buttonToCircle = Tween(begin: measuredButtonWidth, end: measuredButtonHeight);
    buttonToRectangle = Tween(begin: measuredButtonHeight, end: measuredButtonWidth);
    buttonCircle = Tween(begin: measuredButtonHeight, end: measuredButtonHeight);

    _buttonSize = buttonToCircle.animate(_animationController)
      ..addListener(() {
        setState(() {
          width = _buttonSize.value;
        });
      });

    setState(() {
      width = measuredButtonWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _parentKey,
      children: <Widget>[
        Container(
          key: _buttonKey,
          width: width,
          height: measuredButtonHeight,
          child: FullWidthButton(
            backgroundColor: _buttonColor.value,
            padding: EdgeInsets.all(0.0),
            radius: 32.0,
            child: childs(),
            onTap: () => widget.onTap != null ? widget.onTap() : null,
          ),
        ),
      ],
    );
  }

  Widget childs() {
    var progressSize = measuredButtonHeight != null ? measuredButtonHeight - 20.0 : 0.0;
    return Stack(
      children: <Widget>[
        Center(
          child: FadeTransition(
            opacity: _textOpacity,
            child: _button,
          ),
        ),
        Center(
            child: FadeTransition(
              opacity: _progressOpacity,
              child: Container(
                  height: measuredButtonHeight,
                  width: measuredButtonHeight,
                  child: Center(
                    child: Container(width: progressSize, height: progressSize, child: _progress),
                  )),
            )),
        Center(
          child: FadeTransition(
            opacity: _errorIconOpacity,
            child: _error,
          ),
        ),
        Center(
          child: FadeTransition(
            opacity: _checkIconOpacity,
            child: _success,
          ),
        )
      ],
    );
  }

  @override
  void didUpdateWidget(ChangeAbleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error != oldWidget.error && widget.error != null) _error = widget.error;
    if (widget.progress != oldWidget.progress && widget.progress != null) _progress = widget.progress;
    if (widget.success != oldWidget.success && widget.success != null) _success = widget.success;
    if (widget.button != oldWidget.button && widget.button != null) _button = widget.button;
    if (widget.duration != oldWidget.duration) _duration = widget.duration;
    if (widget.defaultColor != oldWidget.defaultColor) _defaultColor = widget.defaultColor;

    if (widget.state != oldWidget.state && widget.state != null) {
      print('Anim Button ------ next State is ${widget.state}, old state ${oldWidget.state}');
      var play = changeAnimAndPlay(widget.state, oldWidget.state);
      if (play) _playAnimation();
      _state = widget.state;
    }
  }

  bool changeAnimAndPlay(AnimatedButtonStates newState, AnimatedButtonStates oldState) {
    switch (newState) {
      case AnimatedButtonStates.progress:
        prepareNoneToWaiting();
        return true;
        break;
      case AnimatedButtonStates.error:
        prepareWaitingToError();
        return true;
        break;
      case AnimatedButtonStates.success:
        prepareWaitingToSuccessful();
        return true;
        break;
      case AnimatedButtonStates.button:
        if (oldState == AnimatedButtonStates.error) {
          prepareErrorToNone();
          return true;
        } else if (oldState == AnimatedButtonStates.success) {
          prepareSuccessfulToNone();
          return true;
        } else {
          prepareNoneToWaiting();
        }
        break;
    }
    return false;
  }

  Future<Null> _playAnimation() async {
    try {
      await _animationController.forward();
    } on TickerCanceled {}
  }

  void onAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_state == AnimatedButtonStates.error || _state == AnimatedButtonStates.success) {
        Future.delayed(Duration(seconds: 1), () => widget.onAnimFinish());
      }
    }
  }

  void prepareNoneToWaiting() {
    _animationController.reset();
    if (buttonToCircle != null) {
      _buttonSize = buttonToCircle.animate(_animationController);
      width = measuredButtonWidth;
    }
    _textOpacity = fadeOutAnimation().animate(_animationController);
    _progressOpacity = fadeInAnimation().animate(_animationController);
    _buttonColor = colorGreenToGreen().animate(_animationController);
    _errorIconOpacity = hideOpacity().animate(_animationController);
    _checkIconOpacity = hideOpacity().animate(_animationController);
  }

  void prepareWaitingToNone() {
    _animationController.reset();
    if (buttonToCircle != null) {
      _buttonSize = buttonToRectangle.animate(_animationController);
      width = measuredButtonHeight;
    }
    _textOpacity = fadeInAnimation().animate(_animationController);
    _progressOpacity = fadeOutAnimation().animate(_animationController);
    _buttonColor = colorGreenToGreen().animate(_animationController);
    _errorIconOpacity = hideOpacity().animate(_animationController);
    _checkIconOpacity = hideOpacity().animate(_animationController);
  }

  void prepareWaitingToError() {
    _animationController.reset();
    if (buttonCircle != null) {
      _buttonSize = buttonCircle.animate(_animationController);
      width = measuredButtonHeight;
    }
    _textOpacity = hideOpacity().animate(_animationController);
    _buttonColor = colorDefaultToRed().animate(_animationController);
    _progressOpacity = fadeOutAnimation().animate(_animationController);
    _errorIconOpacity = fadeInAnimation().animate(_animationController);
    _checkIconOpacity = hideOpacity().animate(_animationController);
  }

  void prepareErrorToNone() {
    _animationController.reset();
    if (buttonToRectangle != null) {
      _buttonSize = buttonToRectangle.animate(_animationController);
      width = measuredButtonHeight;
    }
    _textOpacity = fadeInAnimation().animate(_animationController);
    _buttonColor = colorRedToGreen().animate(_animationController);
    _progressOpacity = hideOpacity().animate(_animationController);
    _errorIconOpacity = fadeOutAnimation().animate(_animationController);
    _checkIconOpacity = hideOpacity().animate(_animationController);
  }

  void prepareWaitingToSuccessful() {
    _animationController.reset();
    if (buttonCircle != null) {
      _buttonSize = buttonCircle.animate(_animationController);
      width = measuredButtonHeight;
    }
    _textOpacity = hideOpacity().animate(_animationController);
    _buttonColor = colorDefaultToYellow().animate(_animationController);
    _progressOpacity = fadeOutAnimation().animate(_animationController);
    _errorIconOpacity = hideOpacity().animate(_animationController);
    _checkIconOpacity = fadeInAnimation().animate(_animationController);
  }

  void prepareSuccessfulToNone() {
    _animationController.reset();
    if (buttonToRectangle != null) {
      _buttonSize = buttonToRectangle.animate(_animationController);
      width = measuredButtonHeight;
    }
    _textOpacity = fadeInAnimation().animate(_animationController);
    _buttonColor = colorYellowToDefault().animate(_animationController);
    _progressOpacity = hideOpacity().animate(_animationController);
    _errorIconOpacity = hideOpacity().animate(_animationController);
    _checkIconOpacity = fadeOutAnimation().animate(_animationController);
  }

  void prepareAnimationController() {
    _animationController = AnimationController(
      duration: _duration,
      vsync: this,
    );
  }

  Tween<double> fadeInAnimation() => Tween(begin: 0.0, end: 1.0);

  Tween<double> fadeOutAnimation() => Tween(begin: 1.0, end: 0.0);

  Tween<double> hideOpacity() => Tween(begin: 0.0, end: 0.0);

  Tween colorDefaultToRed() => ColorTween(begin: _defaultColor, end: Colors.red);

  Tween colorRedToGreen() => ColorTween(begin: Colors.red, end: _defaultColor);

  Tween colorDefaultToYellow() => ColorTween(begin: _defaultColor, end: successColor);

  Tween colorYellowToDefault() => ColorTween(begin: successColor, end: _defaultColor);

  Tween colorGreenToGreen() => ConstantTween(_defaultColor);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}