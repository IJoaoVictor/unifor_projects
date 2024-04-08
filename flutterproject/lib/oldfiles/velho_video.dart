import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class velhoVideo extends StatefulWidget {
  const velhoVideo({super.key});

  @override
  State<velhoVideo> createState() => _velhoVideoState();
}

class _velhoVideoState extends State<velhoVideo> {

  late VideoPlayerController _videoPlayerController;
  
  @override
  void initState(){
    super.initState();
    _videoPlayerController = VideoPlayerController.asset("lib/images/velhovideo.mp4")
    ..initialize().then((context) {
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
      setState(() {});
    }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          title: const Text("Velho Trabalhador"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        
      body: Stack(children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              height: _videoPlayerController?.value?.size?.height ?? 0,
              width: _videoPlayerController?.value?.size?.width ?? 0,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),
        )
      ],),
    );
  }
}