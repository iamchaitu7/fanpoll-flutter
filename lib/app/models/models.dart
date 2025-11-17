// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals, non_constant_identifier_names

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? bio;
  final String profilePicture;
  final String memberSince;
  int followersCount;
  int followingCount;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.bio,
    required this.profilePicture,
    required this.memberSince,
    required this.followersCount,
    required this.followingCount,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'],
      profilePicture: json['profile_picture'] ?? '',
      memberSince: json['member_since'] ?? '',
      followersCount: int.tryParse(json['followers_count'].toString()) ?? 0,
      followingCount: int.tryParse(json['following_count'].toString()) ?? 0,
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'bio': bio,
      'profile_picture': profilePicture,
      'member_since': memberSince,
      'followers_count': followersCount,
      'following_count': followingCount,
      'updated_at': updatedAt,
    };
  }
}

class PollModel {
  int? id;
  String? uuid;
  String? title;
  String? description;
  String? url;
  String? imageUrl;
  String? hashtags;
  int? totalVotes;
  int? likesCount;
  bool? isLiked;
  int? commentsCount;
  String? expiresAt;
  bool? isExpired;
  bool? canVote;
  bool? hasVoted;
  String? createdAt;
  Creator? creator;
  List<Options>? options;
  bool? isOwnPoll;

  PollModel(
      {this.id,
      this.uuid,
      this.title,
      this.description,
      this.url,
      this.imageUrl,
      this.hashtags,
      this.totalVotes,
      this.likesCount,
      this.isLiked,
      this.commentsCount,
      this.expiresAt,
      this.isExpired,
      this.canVote,
      this.hasVoted,
      this.createdAt,
      this.creator,
      this.options,
      this.isOwnPoll});

  PollModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    imageUrl = json['image_url'];
    hashtags = json['hashtags'];
    totalVotes = json['total_votes'];
    likesCount = json['likes_count'];
    isLiked = json["is_liked"];
    commentsCount = json['comments_count'];
    expiresAt = json['expires_at'];
    isExpired = json['is_expired'];
    canVote = json['can_vote'];
    hasVoted = json['has_voted'];
    createdAt = json['created_at'];
    creator = json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    isOwnPoll = json['is_own_poll'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['image_url'] = this.imageUrl;
    data['hashtags'] = this.hashtags;
    data['total_votes'] = this.totalVotes;
    data['comments_count'] = this.commentsCount;
    data['expires_at'] = this.expiresAt;
    data['is_expired'] = this.isExpired;
    data['can_vote'] = this.canVote;
    data['has_voted'] = this.hasVoted;
    data['created_at'] = this.createdAt;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['is_own_poll'] = this.isOwnPoll;
    return data;
  }
}

class Creator {
  int? id;
  String? name;
  String? avatar;
  bool? isFollowing;

  Creator({this.id, this.name, this.avatar, this.isFollowing});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    isFollowing = json['is_following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['is_following'] = this.isFollowing;
    return data;
  }
}

class Options {
  int? id;
  String? text;
  int? order;
  int? voteCount;
  num? percentage;
  bool? isVoted;

  Options({this.id, this.text, this.order, this.voteCount, this.percentage, this.isVoted});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    order = json['order'];
    voteCount = json['vote_count'];
    percentage = json['percentage'];
    isVoted = json['is_voted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['order'] = this.order;
    data['vote_count'] = this.voteCount;
    data['percentage'] = this.percentage;
    data['is_voted'] = this.isVoted;
    return data;
  }
}

class CommentModel {
  final int id;
  final String userName;
  final String userAvatar;
  final String comment;
  final String createdAt;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      userName: json['user_name'],
      userAvatar: json['user_avatar'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }
}

// follower_model.dart

class FollowerModel {
  final String id;
  final String uuid;
  final String fullName;
  final String profilePicture;
  final String? bio;
  final String followedSince;

  FollowerModel({
    required this.id,
    required this.uuid,
    required this.fullName,
    required this.profilePicture,
    this.bio,
    required this.followedSince,
  });

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
      id: json['id'],
      uuid: json['uuid'],
      fullName: json['full_name'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      followedSince: json['followed_since'],
    );
  }
}

class UserFollowModel {
  final String id;
  final String fullName;
  final String profilePicture;
  final String? bio;
  RxBool isFollowing;

  UserFollowModel({
    required this.id,
    required this.fullName,
    required this.profilePicture,
    this.bio,
    required bool isFollowing,
  }) : isFollowing = isFollowing.obs;

  factory UserFollowModel.fromJson(Map<String, dynamic> json) {
    return UserFollowModel(
      id: json['id'],
      fullName: json['full_name'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      isFollowing: true, // Default: all users in following list are followed
    );
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String createdAt;
  final String type;
  final Sender sender;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.type,
    required this.sender,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
      type: json['type'] ?? '',
      sender: Sender.fromJson(json['sender']),
    );
  }
}

class Sender {
  final int id;
  final String name;
  final String avatar;

  Sender({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class MyPollModel {
  final String id;
  final String uuid;
  final String title;
  final String description;
  final DateTime createdAt;
  final String status;

  MyPollModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  factory MyPollModel.fromJson(Map<String, dynamic> json) {
    return MyPollModel(
      id: json['id'],
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'],
    );
  }
}
