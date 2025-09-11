import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String url;

  const AvatarWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(),
      elevation: 2,
      child: CircleAvatar(backgroundImage: NetworkImage(url), radius: 35),
    );
  }
}
