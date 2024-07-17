import 'package:animated_flutter_widgets/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../constants/constants.dart';

class SingleCourseScreen extends StatefulWidget {
  const SingleCourseScreen({super.key, required this.courses});

  final String courses;

  @override
  State<SingleCourseScreen> createState() => _SingleCourseScreenState();
}

class _SingleCourseScreenState extends State<SingleCourseScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  late VideoPlayerController _vcontroller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _vcontroller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _vcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      _controller.repeat(reverse: true);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          toolbarHeight: 70.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.black,
              ),
            ),
          ),
          title: Text(
            "Course Details",
            style: Constants.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0.0, _animation.value),
                  child: IconButton(
                    onPressed: () {
                      // Handle heart icon tap if needed
                    },
                    icon: const Icon(
                      CupertinoIcons.heart,
                    ),
                  ),
                );
              },
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  color: Constants.white,
                  border: Border.all(
                    color: Constants.primaryColor.withOpacity(0.1),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Stack(
                      children: [
                        // Video Player
                        Center(
                          child: _vcontroller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _vcontroller.value.aspectRatio,
                                  child: VideoPlayer(_vcontroller),
                                )
                              : Container(),
                        ),
                        // Button
                        Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (_vcontroller.value.isPlaying) {
                                  _vcontroller.pause();
                                } else {
                                  _vcontroller.play();
                                }
                              });
                            },
                            icon: Container(
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constants.primaryColor.withOpacity(0.3),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                _vcontroller.value.isPlaying
                                    ? CupertinoIcons.pause_fill
                                    : CupertinoIcons.play_fill,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
              child: Text(
                widget.courses,
                style: Constants.body.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.star_fill,
                            size: 20,
                            color: Colors.orangeAccent,
                          ),
                          Text(
                            " 4.5",
                            style: Constants.body.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Quiz
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.question_circle_fill,
                            size: 20,
                            color: Colors.deepPurpleAccent,
                          ),
                          Text(
                            " Quiz",
                            style: Constants.body.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Time
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.clock_fill,
                            size: 20,
                            color: Colors.blueAccent,
                          ),
                          Text(
                            " 72 hours",
                            style: Constants.body.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Price
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle download tap if needed
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        // Download IconButton
                        const Icon(
                          Icons.download,
                          color: Constants.primaryColor,
                          size: 18,
                        ),
                        Text(
                          " Resources",
                          style: Constants.body.copyWith(
                            fontSize: 16,
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Playlist/Quiz Selector
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.grey[100],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = 0;
                        });
                      },
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: currentIndex == 0
                              ? Constants.primaryColor
                              : Colors.grey[100],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.play_circle_fill,
                                size: 24,
                                color: currentIndex == 0
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Text(
                                " Playlist (22)",
                                style: Constants.body.copyWith(
                                  fontSize: 16,
                                  color: currentIndex == 0
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: currentIndex == 1
                              ? Constants.primaryColor
                              : Colors.grey[100],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.question_circle_fill,
                                size: 24,
                                color: currentIndex == 1
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Text(
                                " Quiz",
                                style: Constants.body.copyWith(
                                  fontSize: 16,
                                  color: currentIndex == 1
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Playlist/Quiz Content
            Visibility(
              visible: currentIndex == 0,
              child: Expanded(
                child: AnimatedListViewBuilder(
                  animationType: ScrollWidgetAnimationType.scaleOut,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Handle playlist item tap if needed when data is available
                          // _vcontroller =
                          //     VideoPlayerController.network(videoUrls[index])
                          //       ..initialize().then((_) {
                          //         setState(() {
                          //           _vcontroller.play();
                          //         });
                          //       });

                          // Check if the user has watched the video

                          // _vcontroller.value.position == _vcontroller.value.duration
                          //     ? _vcontroller.play()
                          //     : _vcontroller.pause();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.play_circle_fill,
                                  size: 24,
                                  color: Constants.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Playlist Title",
                                  style: Constants.body.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Duration
                                Row(
                                  children: [
                                    Text(
                                      "11 mins 30 secs",
                                      style: Constants.body.copyWith(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                CupertinoIcons.check_mark_circled,
                                size: 24,
                                color: Constants.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Visibility(
              visible: currentIndex == 1,
              child: Expanded(
                child: AnimatedListViewBuilder(
                  animationType: ScrollWidgetAnimationType.scaleOut,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.question_circle_fill,
                                size: 24,
                                color: Constants.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Quiz Title",
                                style: Constants.body.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Duration
                              Row(
                                children: [
                                  Text(
                                    "25 MCQs",
                                    style: Constants.body.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              CupertinoIcons.check_mark_circled,
                              size: 24,
                              color: Constants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
