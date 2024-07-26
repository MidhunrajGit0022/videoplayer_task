import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/controller/user_controller.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/authentication_controller.dart';
import 'package:videoplayer/model/user_model.dart';
import 'package:videoplayer/themes/theme_controller.dart';
import 'package:videoplayer/views/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final authcontroller = Get.put(AuthenticationController());
  final usercontroller = Get.put(Profilecontroller());
  final RxList<Usermodel> _userData = RxList<Usermodel>();
  final theme = Get.put(ThemeController());

  String selectedPage = '';
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isFullScreen = false;
  int _currentIndex = 0;
  double _volume = 1.0;
  final bool _isVideoEnabled = true;
  Timer? _timer;
  bool _showControls = true;
  final List<String> _videoUrls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
  ];

  @override
  void initState() {
    super.initState();
    usercontroller.getuserdata().listen((user) {
      _userData.add(user);
    });
    _controller = VideoPlayerController.network(
      _videoUrls[_currentIndex],
    )..initialize().then((_) {
        setState(() {});
        _controller.addListener(() {
          if (_controller.value.hasError) {
            print('Error playing video');
          }
        });

        // if (_isVideoEnabled) {
        //   _controller.play();
        // }
      });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  void downloadVideo() async {
    final Dio dio = Dio();
    final String url = _videoUrls[_currentIndex];
    final String filename = url.split('/').last;

    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$filename';

    final progressNotifier = ValueNotifier(0.0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ValueListenableBuilder(
          valueListenable: progressNotifier,
          builder: (context, value, child) {
            return Text('Downloading $filename... ${value.toInt()}%');
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await dio.download(url, filePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        print('Downloading: ${received / total * 100}%');
      }
    }).then((_) async {
      final result = await ImageGallerySaver.saveFile(filePath);
      if (result != null) {
        print('Video saved to gallery: $result');

        Get.defaultDialog(
          title: 'Download Complete',
          content: const Text('Video has been saved to your gallery'),
          confirm: ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        );
      } else {
        print('Failed to save video to gallery');
        Get.snackbar('Failed', 'Download Failed', backgroundColor: Colors.red);
      }
    });
  }

  void _playNextVideo() {
    log("Next");
    if (_currentIndex < _videoUrls.length - 1) {
      _currentIndex++;
      _controller.dispose();
      _controller = VideoPlayerController.network(
        _videoUrls[_currentIndex],
      )..initialize().then((_) {
          setState(() {});
          _controller.play();
          _controller.addListener(() {
            if (_controller.value.hasError) {
              print(
                  'Error playing video: ${_controller.value.errorDescription}');
            }
          });
        });
    }
  }

  void _playPreviousVideo() {
    log("Prev");
    if (_currentIndex > 0) {
      _currentIndex--;
      _controller.dispose();
      _controller = VideoPlayerController.network(
        _videoUrls[_currentIndex],
      )..initialize().then((_) {
          setState(() {});
          _controller.play();
          _controller.addListener(() {
            if (_controller.value.hasError) {
              print(
                  'Error playing video: ${_controller.value.errorDescription}');
            }
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: !_isFullScreen
          ? AppBar(
              title: const Text("data"),
              actions: [
                IconButton(
                    onPressed: () {
                      authcontroller.logout();
                    },
                    icon: const Icon(Icons.logout))
              ],
            )
          : null,
      drawer: Drawer(
        child: Column(
          children: [
            Obx(
              () {
                if (_userData.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _userData.length,
                  itemBuilder: (context, index) {
                    return DrawerHeader(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Video Player',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: _userData[index].photo != null
                                ? NetworkImage(_userData[index].photo!)
                                : null,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _userData[index].name != null
                                        ? _userData[index].name!
                                        : 'Name',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    _userData[index].email != null
                                        ? _userData[index].email!
                                        : 'Email',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                setState(() {
                  selectedPage = 'Profile';
                });
                Get.to(const Profile_page(), preventDuplicates: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mode),
              title: Obx(() =>
                  Text(theme.isDarkMode.value ? 'Dark Mode' : 'Light Mode')),
              trailing: Obx(() => Switch(
                    value: theme.isDarkMode.value,
                    onChanged: (value) {
                      theme.toggleTheme();
                    },
                  )),
              onTap: null,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  authcontroller.logout();
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _controller.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _showControls = !_showControls;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _isFullScreen
                            ? SafeArea(
                                top: false,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: VideoPlayer(_controller),
                                ),
                              )
                            : AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                        _showControls
                            ? Positioned(
                                bottom: 0,
                                left: 0,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_controller.value.isPlaying) {
                                                _controller.pause();
                                                setState(() {
                                                  _showControls = true;
                                                });
                                              } else {
                                                _controller.play();
                                                setState(() {
                                                  _showControls = false;
                                                });
                                              }
                                              _isPlaying =
                                                  _controller.value.isPlaying;
                                            });
                                          },
                                          icon: Icon(
                                            _isPlaying
                                                ? Icons.pause_circle
                                                : Icons.play_circle,
                                            size: 50,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.80,
                                          child: VideoProgressIndicator(
                                            _controller,
                                            allowScrubbing: true,
                                            padding: const EdgeInsets.all(10.0),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    _playPreviousVideo();
                                                    log("prev");
                                                  },
                                                  child: const Icon(
                                                    Icons.skip_previous,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _playNextVideo();
                                                    log("Nextdddddddd");
                                                  },
                                                  child: const Icon(
                                                    Icons.skip_next,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Slider(
                                                value: _volume,
                                                min: 0.0,
                                                max: 1.0,
                                                divisions: 10,
                                                label:
                                                    'Volume: ${(_volume * 100).round()}%',
                                                onChanged: (value) {
                                                  setState(() {
                                                    _volume = value;
                                                    _controller
                                                        .setVolume(_volume);
                                                  });
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isFullScreen =
                                                      !_isFullScreen;
                                                  if (_isFullScreen) {
                                                    SystemChrome
                                                        .setPreferredOrientations([
                                                      DeviceOrientation
                                                          .landscapeLeft,
                                                      DeviceOrientation
                                                          .landscapeRight,
                                                    ]);
                                                  } else {
                                                    SystemChrome
                                                        .setPreferredOrientations([
                                                      DeviceOrientation
                                                          .portraitUp,
                                                      DeviceOrientation
                                                          .portraitDown,
                                                    ]);
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                _isFullScreen
                                                    ? Icons.fullscreen_exit
                                                    : Icons.fullscreen,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : SizedBox(
                    height: screenSize.height * 0.2,
                    child: const Center(child: CircularProgressIndicator())),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    child: IconButton(
                      onPressed: () {
                        _playPreviousVideo();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    downloadVideo();
                  },
                  child: const Text("Download"),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    child: IconButton(
                      onPressed: () {
                        _playNextVideo();
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
