import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class viajanteVideo extends StatefulWidget {
  const viajanteVideo({super.key});

  @override
  State<viajanteVideo> createState() => _viajanteVideoState();
}

class _viajanteVideoState extends State<viajanteVideo> {

  late VideoPlayerController _videoPlayerController;
  
  @override
  void initState(){
    super.initState();
    _videoPlayerController = VideoPlayerController.asset("lib/images/viajantevideo.mp4")
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
          title: const Text("O Viajante"),
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
              height: _videoPlayerController?.value?.size?.height ?? 0.0,
              width: _videoPlayerController?.value?.size?.width ?? 0.0,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),
        )
      ],),
    );
  }
}