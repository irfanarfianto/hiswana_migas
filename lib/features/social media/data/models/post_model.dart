import 'dart:convert';

import 'package:hiswana_migas/features/social%20media/domain/entities/post_entity.dart';

class PostModel extends Post {
  PostModel({
    required super.caption,
    required super.photo,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      caption: json['caption'] ?? '',
      photo: json['photo'] is String
          ? List<String>.from(jsonDecode(json['photo']))
          : List<String>.from(json['photo'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'photo': photo != null ? jsonEncode(photo) : '[]',
    };
  }
}
