// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';

import 'package:shorts/controller/video_controller.dart';
import 'package:shorts/view/screens/comments_screen.dart';
import 'package:shorts/view/screens/profile_screen.dart';
import 'package:shorts/view/widgets/video_player_item.dart';

class VideoScreen extends StatelessWidget {
  String? videoId;
  VideoScreen({
    Key? key,
    this.videoId,
  }) : super(key: key);

  final VideoController videoController = Get.put(VideoController());

  buildProfile({
    required String profilePhoto,
    required BuildContext context,
    required String uid,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(uid: uid),
          ),
        );
      },
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Future<void> share(String videoId) async {
    await FlutterShare.share(
        title: "Download Shorts", text: "'Watch interesting short videos");
    videoController.shareVideo(videoId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: PageController(
            initialPage: 0,
            viewportFraction: 1,
          ),
          itemCount: videoController.videoList.length,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return InkWell(
              onDoubleTap: () {
                videoController.likedVideo(data.id);
              },
              child: Stack(
                children: [
                  VideoPlayerItem(
                    videoUrl: data.videoUrl,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.7,
                          child: Text(
                            data.username,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: size.width * 0.7,
                          child: Text(
                            data.caption,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: size.width * 0.7,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.music_note,
                                size: 15,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6),
                              Text(
                                data.songName,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      height: size.height - 300,
                      margin: EdgeInsets.only(
                        top: size.height / 3,
                        right: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              data.dislikes.contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? () {}
                                  : videoController.likedVideo(data.id);
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: data.likes.contains(
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? Colors.white
                                      : Color.fromRGBO(39, 39, 39, 1),
                                  child: Icon(
                                    Icons.thumb_up,
                                    size: 20,
                                    color: data.likes.contains(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  data.likes.length.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              data.likes.contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? () {}
                                  : videoController.dislikedVideo(data.id);
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: data.dislikes.contains(
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? Colors.white
                                      : Color.fromRGBO(39, 39, 39, 1),
                                  child: Icon(
                                    Icons.thumb_down,
                                    size: 20,
                                    color: data.dislikes.contains(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  data.dislikes.length.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentsScreen(
                                    id: data.id,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Color.fromRGBO(
                                    39,
                                    39,
                                    39,
                                    1,
                                  ),
                                  child: Icon(
                                    Icons.comment,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  data.commentsCount.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              share(data.id);
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor:
                                      Color.fromRGBO(39, 39, 39, 1),
                                  child: Image.asset(
                                    "images/send.png",
                                    color: Colors.white,
                                    height: 22,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  data.shareCount.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          buildProfile(
                            profilePhoto: data.profilePic,
                            context: context,
                            uid: data.uid,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
