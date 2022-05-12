import 'dart:convert';

class BiometricUser {
  // id to x
  final String? id;
  final String? accessToken;
  final String? refreshToken;
  final String? image;

  BiometricUser({
    this.id,
    this.accessToken,
    this.refreshToken,
    this.image,
  });

  Map toJson() => {
        'id': id,
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'image': image,
      };

  BiometricUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        accessToken = json['access_token'],
        refreshToken = json['refresh_token'],
        image = json['image'];
}