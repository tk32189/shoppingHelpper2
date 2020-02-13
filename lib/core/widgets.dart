import 'package:flutter/material.dart';

import 'coreLibrary.dart';

class SimpleOutlineButton extends StatelessWidget {
  const SimpleOutlineButton({
    Key key,
    this.onPressed,
    @required this.buttonText,
    @required this.isTokenIconVisible,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String buttonText;
  //final Widget icon;
  final bool isTokenIconVisible;

  bool isIconExists() {
    if (isTokenIconVisible == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
        highlightedBorderColor: Colors.red,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        borderSide: BorderSide(color: HexColor("#442C2E"), width: 2),
        //splashColor: Colors.green[300],
        onPressed: onPressed,
        child: Row(
          children: <Widget>[
            Visibility(
              visible: isTokenIconVisible,
              child: Icon(Icons.confirmation_number, color: Colors.orange[600],),
            ),
            Visibility(
              visible: isTokenIconVisible,
              child: SizedBox(
                width: 10,
              ),
            ),
            Text(
              buttonText,
              style: TextStyle(color: HexColor("#442C2E")),
            ),
          ],
        ));
  }
}



class CommonDisplayText extends StatelessWidget {
  const CommonDisplayText({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          margin: EdgeInsets.only(left: 5, bottom: 5),
          alignment: Alignment.centerLeft,
          child: RaisedButton(
            onPressed: () {},
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  color: Colors.orange.shade800,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 250,
                    //margin: EdgeInsets.only(left: 10, bottom: 5),
                    child: Text(value)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SimpleTitleLevel1 extends StatelessWidget {
  const SimpleTitleLevel1({
    Key key,
    @required this.title
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(

      children: <Widget>[
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.check_circle,
          color: HexColor("#442C2E"),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: TextStyle(
            color: HexColor("#442C2E"),
            fontWeight: FontWeight.bold,
            fontSize: 18.0
          ),
        ),
      ],
    );
  }
}