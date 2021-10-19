
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';


class AppConfirmDialog extends StatelessWidget {
  final String description;
  final Function positiveAction, negativeAction;
  final Color positiveColor;
  const AppConfirmDialog(
      {Key key,
      @required this.description,
      this.positiveColor =kPrimaryColor ,
      @required this.positiveAction,
      @required this.negativeAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1.0,
      backgroundColor: backGroundColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 28),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 36, horizontal: 24),
          width: MediaQuery.of(context).size.width,
          child: dialogContent(context)),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
         "Close App?",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black),
        ),
        SizedBox(
          height: 60,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: negativeAction,
                style: ElevatedButton.styleFrom(
                    primary: ksecondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 24,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: positiveAction,
                style: ElevatedButton.styleFrom(
                    primary: positiveColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
                child: Text(
                  "confirm",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                ),
              ),
            ),

            )],
        )
      ],
    );
  }
}
