import 'package:flutter/material.dart';

class LoadinContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        buildContainer(deviceSize),
        buildContainer(deviceSize),
        Divider(
          color: Colors.grey,
          height: 8,
        ),
      ],
    );
  }

  Widget buildContainer(Size deviceSize) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 24,
      color: Colors.grey[200],
      width: deviceSize.width - 40,
    );
  }
}
