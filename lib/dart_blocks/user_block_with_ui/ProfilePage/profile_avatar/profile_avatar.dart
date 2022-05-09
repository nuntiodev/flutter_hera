import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({
    Key? key,
    required this.imageUrl,
    required this.radius,
    this.background,
    this.border,
  }) : super(key: key);

  final String imageUrl;
  final double radius;
  final BoxDecoration? background;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            border: border,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => CupertinoActivityIndicator(),
        errorWidget: (context, url, error) {
          print(error.toString());
          return Container(
            decoration: background?.copyWith(
                  shape: BoxShape.circle,
                ) ??
                BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff686FFF),
                      Color(0xff0512FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
            width: radius * 2,
            height: radius * 2,
            child: Icon(
              CupertinoIcons.person,
              color: CupertinoColors.white,
              size: radius * 1.4,
            ),
          );
        },
      ),
    );
  }
}
