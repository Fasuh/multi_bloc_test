import 'package:flutter/material.dart';
import 'package:testing_ground/common/app/colors.dart';
import 'package:testing_ground/common/app/text_styles.dart';

class FullWidthButton extends StatelessWidget {
  final Color backgroundColor;
  final TextStyle textStyle;
  final String text;
  final Function onTap;
  final double elevation;
  final double radius;
  final Widget child;
  final EdgeInsets padding;

  const FullWidthButton(
      {Key key,
        this.backgroundColor,
        this.textStyle,
        this.text,
        this.onTap,
        this.elevation,
        this.radius,
        this.child,
        this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        disabledColor: primaryColor.withOpacity(0.5),
        elevation: elevation ?? 8.0,
        color: backgroundColor ?? primaryColor,
        onPressed: onTap,
        padding: EdgeInsets.all(0.0),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(vertical: 12.0),
          child: child ??
              Text(
                text ?? "Put name here",
                style: textStyle ?? roboto.s18.bold.colorWhite,
              ),
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(radius ?? 32.0)));
  }
}
