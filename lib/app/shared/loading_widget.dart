import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {

  final String? message;
  const LoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            message != null ? Text(message!) : Container()
          ],
        ),
      ),
    );
  }
}
